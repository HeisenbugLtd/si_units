--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

with Ada.IO_Exceptions;
with SI_Units.Float_IO;

package body SI_Units.Metric is

   function Prefix (S : in Prefixes) return String is
     (case S is
         when yocto => "y",
         when zepto => "z",
         when atto  => "a",
         when femto => "f",
         when pico  => "p",
         when nano  => "n",
         when micro => Micro_Sign,
         when milli => "m",
         when None  => "",
         when kilo  => "k",
         when Mega  => "M",
         when Giga  => "G",
         when Tera  => "T",
         when Peta  => "P",
         when Exa   => "E",
         when Zetta => "Z",
         when Yotta => "Y") with
        Inline => True;

   function General_Image (Value : in Float_IO.General_Float;
                           Aft   : in Ada.Text_IO.Field;
                           Unit  : in String) return String;
   --  The actual implementation of each of the Image subprograms.
   --
   --  Finds the best match for a value such that the value to be displayed will
   --  be in the interval (0.0 .. 1000.0] with an appropriate prefix for the
   --  unit name, i.e. a call to
   --
   --    General_Image (123_456_789.0, 3, "Hz");
   --
   --  will return the string
   --
   --    123.457 MHz

   function General_Image (Value : in Float_IO.General_Float;
                           Aft   : in Ada.Text_IO.Field;
                           Unit  : in String) return String
   is
      use type Float_IO.General_Float;

      Temp  : Float_IO.General_Float := abs Value;
      --  Ignore sign for temporary value.
      Scale : Prefixes               := None;
   begin
      --  No prefix if no unit is given or value is exactly zero.
      if Unit /= No_Unit and then Temp /= 0.0 then
         --  We ignored the sign of the input value, so we only have to cope
         --  with positive values here.
         if Temp < 1.0 then
            Handle_Small_Prefixes :
            declare
               --  Set threshold, if the value is less than that it will be
               --  rounded down. Please note, that an Aft of 0 will be handled
               --  like an Aft of 1 (as we always emit at least one digit after
               --  the decimal point.
               Threshold : constant Float_IO.General_Float
                 := 1.0 - (0.1 ** (Ada.Text_IO.Field'Max (1, Aft))) / 2.0;
            begin
               Find_Best_Small_Prefix :
               while Temp <= Threshold loop
                  exit Find_Best_Small_Prefix when Scale = Prefixes'First;
                  --  Value is too small to be optimally represented.

                  --  Down to next prefix.
                  Scale := Prefixes'Pred (Scale);
                  Temp := Temp * Magnitude;
               end loop Find_Best_Small_Prefix;

               --  Value is (still) too small to be properly represented, treat
               --  as zero.
               if Temp < 1.0 - Threshold then
                  Temp  := 0.0;
                  Scale := None;
               end if;
            end Handle_Small_Prefixes;
         else
            Handle_Large_Prefixes :
            declare
               Threshold : constant Float_IO.General_Float :=
                 Magnitude - ((0.1 ** Aft) / 2.0);
               --  If the value is greater than that it will be rounded up.
            begin
               Find_Best_Large_Prefix :
               while Temp >= Threshold loop
                  exit Find_Best_Large_Prefix when Scale = Prefixes'Last;
                  --  Value is too large to be optimally represented.

                  --  Up to next prefix.
                  Scale := Prefixes'Succ (Scale);
                  Temp := Temp / Magnitude;
               end loop Find_Best_Large_Prefix;
            end Handle_Large_Prefixes;
         end if;
      end if;

      --  Restore sign before converting into string.
      if Value < 0.0 then
         Temp := -Temp;
      end if;

      Convert_To_Postfixed_String :
      declare
         Result : String (1 .. 5 + Ada.Text_IO.Field'Max (1, Aft));
         --  "-999.[...]";
      begin
         Try_Numeric_To_String_Conversion :
         begin
            Float_IO.General_Float_IO.Put (To   => Result,
                                           Item => Temp,
                                           Aft  => Aft,
                                           Exp  => 0);
         exception
            when Ada.IO_Exceptions.Layout_Error =>
               --  Value was larger than 999 Yunits and didn't fit into the
               --  string.
               --  Reset Scale and return "<inf>"inity instead.
               Scale := None;
               Result (1 .. 4)           := (if Temp < 0.0
                                             then Minus_Sign
                                             else Plus_Sign) & "inf";
               Result (5 .. Result'Last) := (others => ' ');
         end Try_Numeric_To_String_Conversion;

         return Trim (Result &
                      (if Unit = No_Unit
                         then ""
                         else No_Break_Space & Prefix (Scale) & Unit));
      end Convert_To_Postfixed_String;
   end General_Image;

   function Fixed_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String is
     (General_Image (Value => Float_IO.General_Float (Value),
                     Aft   => Aft,
                     Unit  => Unit));

   function Float_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String is
     (General_Image (Value => Float_IO.General_Float (Value),
                     Aft   => Aft,
                     Unit  => Unit));

   function Integer_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String is
     (General_Image (Value => Float_IO.General_Float (Value),
                     Aft   => Aft,
                     Unit  => Unit));

   function Mod_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String is
     (General_Image (Value => Float_IO.General_Float (Value),
                     Aft   => Aft,
                     Unit  => Unit));

end SI_Units.Metric;
