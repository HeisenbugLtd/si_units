--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

with Ada.Float_Text_IO;
with Ada.IO_Exceptions;

package body SI_Units.Binary is

   function Prefix (S : in Prefixes) return String is
     (case S is
         when None => "",
         when kibi => "Ki",
         when mebi => "Mi",
         when gibi => "Gi",
         when tebi => "Ti",
         when pebi => "Pi",
         when exbi => "Ei",
         when zebi => "Zi",
         when yobi => "Yi") with
        Inline => True;

   function Image (Value : in Item;
                   Aft   : in Ada.Text_IO.Field := Default_Aft) return String
   is
      Result : String (1 .. 5 + Ada.Text_IO.Field'Max (1, Aft));
      --  "1023.[...]";
      Temp   : Float    := Float (Value);
      Scale  : Prefixes := None;
   begin
      if Unit /= No_Unit then -- No prefix matching if no unit name is given.
         while Temp >= Magnitude loop
            Scale := Prefixes'Succ (Scale);
            Temp := Temp / Magnitude;
         end loop;
      end if;

      Try_Numeric_To_String_Conversion :
      begin
         Ada.Float_Text_IO.Put (To   => Result,
                                Item => Temp,
                                Aft  => Aft,
                                Exp  => 0);
      exception
         when Ada.IO_Exceptions.Layout_Error =>
            --  Value was larger than 9999 Yi<units> and didn't fit into the
            --  string.
            --  Reset Scale and return "inf"inity instead.
            Result (1 .. 4)           := "+inf";
            Result (5 .. Result'Last) := (others => ' ');
      end Try_Numeric_To_String_Conversion;

      return Trim (Result &
                   (if Unit = No_Unit
                      then ""
                      else No_Break_Space & Prefix (Scale) & Unit));
   end Image;

end SI_Units.Binary;
