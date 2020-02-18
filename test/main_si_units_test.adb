--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

with Ada.Characters.Latin_1;
with Ada.Text_IO;
with SI_Units.Binary.Scaling;
with SI_Units.Metric.Scaling;
with SI_Units.Names;

--------------------------------------------------------------------------------
--  SI_Units - Test run.
--------------------------------------------------------------------------------
procedure Main_SI_Units_Test is

   type Scalar is delta 1.0 / 2 ** 32 range
     -2.0 ** 31 .. 2.0 ** 31 - 1.0 / 2 ** 32;

   type Modular is mod 2 ** 64;

   function Modular_BI is new SI_Units.Binary.Image (Item        => Modular,
                                                     Default_Aft => 3,
                                                     Unit        => "Mod");

   function Modular_MI is new SI_Units.Metric.Mod_Image (Item        => Modular,
                                                         Default_Aft => 3,
                                                         Unit        => "Mod");

   function Fixed_MI is
     new SI_Units.Metric.Fixed_Image (Item        => Scalar,
                                      Default_Aft => 6,
                                      Unit        => SI_Units.Names.Ampere);

   function Float_MI is
     new SI_Units.Metric.Float_Image (Item        => Long_Float,
                                      Default_Aft => 3,
                                      Unit        => SI_Units.Names.Volt);

   package Test_Cases is

      procedure Add (Passed  : in Boolean;
                     Message : in String);

      function Total return Natural;
      function Passed return Natural;

   end Test_Cases;

   package body Test_Cases is

      Num_Test_Cases : Natural := 0;
      Num_Succeeded  : Natural := 0;

      procedure Add (Passed  : in Boolean;
                     Message : in String) is
      begin
         Num_Test_Cases := Num_Test_Cases + 1;

         if Passed then
            Num_Succeeded := Num_Succeeded + 1;
         else
            Ada.Text_IO.Put_Line ("Test_Case failed: " & Message);
         end if;
      end Add;

      function Passed return Natural is (Num_Succeeded);
      function Total  return Natural is (Num_Test_Cases);
   end Test_Cases;

   Micro_Sign     : Character renames Ada.Characters.Latin_1.Micro_Sign;
   No_Break_Space : Character renames Ada.Characters.Latin_1.No_Break_Space;
begin
   Test_Cases.Add
     (Passed  => Modular_BI (-1) = "16.000" & No_Break_Space & "EiMod",
      Message => "Modular_BI (-1)");

   Test_Cases.Add
     (Passed  => Modular_MI (-1) = "18.447" & No_Break_Space & "EMod",
      Message => "Modular_MI (-1)");

   Test_Cases.Add
     (Passed  => Modular_BI (1023) = "1023.000" & No_Break_Space & "Mod",
      Message => "Modular_BI (1023)");

   Test_Cases.Add
     (Passed  => Modular_MI (1023) = "1.023" & No_Break_Space & "kMod",
      Message => "Modular_MI (1023)");

   Test_Cases.Add
     (Passed  => Modular_BI (1024) = "1.000" & No_Break_Space & "KiMod",
      Message => "Modular_BI (1024)");

   Test_Cases.Add
     (Passed  => Modular_MI (1024) = "1.024" & No_Break_Space & "kMod",
      Message => "Modular_MI (1024)");

   Test_Cases.Add
     (Passed  => Modular_BI (1025) = "1.001" & No_Break_Space & "KiMod",
      Message => "Modular_BI (1025)");

   Test_Cases.Add
     (Passed  => Modular_MI (1025) = "1.025" & No_Break_Space & "kMod",
      Message => "Modular_MI (1025)");

   Test_Cases.Add
     (Passed  => Fixed_MI (0.0) = "0.000000" & No_Break_Space & SI_Units.Names.Ampere,
      Message => "Fixed_MI (0.0)");

   Test_Cases.Add
     (Passed  => Fixed_MI (Scalar'Small) = "232.830644" & No_Break_Space & "p" & SI_Units.Names.Ampere,
      Message => "Fixed_MI (Scalar'Small)");

   Test_Cases.Add
     (Passed  => Fixed_MI (Scalar'First) = "-2.147484" & No_Break_Space & "G" & SI_Units.Names.Ampere,
      Message => "Fixed_MI (Scalar'First)");

   Test_Cases.Add
     (Passed  => Fixed_MI (Scalar'Last) = "2.147484" & No_Break_Space & "G" & SI_Units.Names.Ampere,
      Message => "Fixed_MI (Scalar'Last)");

   declare
      type Loop_Iteration is range 1 .. 32;
      Median  : constant Scalar := 1000.0;
      Operand : Scalar          := 1.0;
   begin
      for Exponent in reverse Loop_Iteration loop
         Ada.Text_IO.Put_Line (Fixed_MI (Median - Operand));
         Operand := Operand / 2.0;
      end loop;

      Ada.Text_IO.Put_Line (Fixed_MI (Median));

      for Exponent in Loop_Iteration loop
         Ada.Text_IO.Put_Line (Fixed_MI (Median + Operand));
         Operand := Operand * 2.0;
      end loop;
   end;

   declare
      Median    : constant Scalar := 1000.0;
      LT_Median : constant Scalar := Median - Scalar'Small;
      GT_Median : constant Scalar := Median + Scalar'Small;
   begin
      for Aft in 1 .. 18 loop
         Ada.Text_IO.Put_Line ("< 1000.0: " & Fixed_MI (Value => LT_Median,
                                                        Aft   => Aft));
         Ada.Text_IO.Put_Line ("= 1000.0: " & Fixed_MI (Value => Median,
                                                        Aft   => Aft));
         Ada.Text_IO.Put_Line ("> 1000.0: " & Fixed_MI (Value => GT_Median,
                                                        Aft   => Aft));
      end loop;
   end;

   Test_Cases.Add
     (Passed  => Float_MI (0.0) = "0.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (0.0)");

   Test_Cases.Add
     (Passed  => Float_MI (Long_Float'Safe_Small) = "0.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (Long_Float'Safe_Small)");

   Test_Cases.Add
     (Passed  => Float_MI (Long_Float'Safe_First) = "-inf    " & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (Long_Float'Safe_First)");

   Test_Cases.Add
     (Passed  => Float_MI (Long_Float'Safe_Last) = "+inf    " & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (Long_Float'Safe_Last)");

   Test_Cases.Add
     (Passed  => Float_MI (-9.999_999_49E27) = "-inf    " & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (-9.999_999_49E27)");

   Test_Cases.Add
     (Passed  => Float_MI (9.999_999_49E27) = "9999.999" & No_Break_Space & "Y" & SI_Units.Names.Volt,
      Message => "Float_MI (9.999_999_49E27)");

   --  "infinity"
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E27) = "-inf    " & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E27)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E27) = "1000.000" & No_Break_Space & "Y" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E27)");

   --  Yotta
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E24) = "-1.000" & No_Break_Space & "Y" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E24)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E24) = "1.000" & No_Break_Space & "Y" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E24)");

   --  Zeta
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E21) = "-1.000" & No_Break_Space & "Z" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E21)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E21) = "1.000" & No_Break_Space & "Z" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E21)");

   --  Exa
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E18) = "-1.000" & No_Break_Space & "E" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E18)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E18) = "1.000" & No_Break_Space & "E" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E18)");

   --  Peta
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E15) = "-1.000" & No_Break_Space & "P" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E15)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E15) = "1.000" & No_Break_Space & "P" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E15)");

   --  Tera
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E12) = "-1.000" & No_Break_Space & "T" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E12)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E12) = "1.000" & No_Break_Space & "T" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E12)");

   --  Giga
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E9) = "-1.000" & No_Break_Space & "G" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E9)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E9) = "1.000" & No_Break_Space & "G" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E9)");

   --  Mega
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E6) = "-1.000" & No_Break_Space & "M" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E6)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E6) = "1.000" & No_Break_Space & "M" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E6)");

   --  kilo
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E3) = "-1.000" & No_Break_Space & "k" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E3)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E3) = "1.000" & No_Break_Space & "k" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E3)");

   --  None
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E0) = "-1.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E0)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E0) = "1.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E0)");

   --  milli
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-3) = "-1.000" & No_Break_Space & "m" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-3)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-3) = "1.000" & No_Break_Space & "m" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-3)");

   --  micro
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-6) = "-1.000" & No_Break_Space & Micro_Sign & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-6)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-6) = "1.000" & No_Break_Space & Micro_Sign & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-6)");

   --  nano
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-9) = "-1.000" & No_Break_Space & "n" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-9)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-9) = "1.000" & No_Break_Space & "n" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-9)");

   --  pico
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-12) = "-1.000" & No_Break_Space & "p" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-12)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-12) = "1.000" & No_Break_Space & "p" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-12)");

   --  femto
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-15) = "-1.000" & No_Break_Space & "f" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-15)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-15) = "1.000" & No_Break_Space & "f" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-15)");

   --  atto
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-18) = "-1.000" & No_Break_Space & "a" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-18)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-18) = "1.000" & No_Break_Space & "a" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-18)");

   --  zepto
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-21) = "-1.000" & No_Break_Space & "z" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-21)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-21) = "1.000" & No_Break_Space & "z" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-21)");

   --  yocto
   Test_Cases.Add
     (Passed  => Float_MI (-1.0E-24) = "-1.000" & No_Break_Space & "y" & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-24)");

   Test_Cases.Add
     (Passed  => Float_MI (1.0E-24) = "1.000" & No_Break_Space & "y" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-24)");

   --  almost zero, still with (smallest) prefix
   Test_Cases.Add
     (Passed  => Float_MI (-5.0E-28) = "-0.001" & No_Break_Space & "y" & SI_Units.Names.Volt,
      Message => "Float_MI (-5.0E-28)");
   Test_Cases.Add
     (Passed  => Float_MI (5.0E-28) = "0.001" & No_Break_Space & "y" & SI_Units.Names.Volt,
      Message => "Float_MI (5.0E-28)");

   --  virtually zero, no prefix
   Test_Cases.Add
     (Passed  => Float_MI (-4.999_999_999_999_999E-28) = "-0.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (-4.999_999_999_999_999E-28)");
   Test_Cases.Add
     (Passed  => Float_MI (4.999_999_999_999_999E-28) = "0.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (4.999_999_999_999_999E-28)");

   Print_Test_Summary :
   declare
      Total : Natural := Test_Cases.Total;
      Passed : Natural := Test_Cases.Passed;
   begin
      Ada.Text_IO.Put_Line
        (Passed'Image & " out of" & Total'Image & " tests succeeded.");

      if Test_Cases.Total = Test_Cases.Passed then
         Ada.Text_IO.Put_Line ("<OK>");
      else
         Ada.Text_IO.Put_Line ("<Failed>");
      end if;
   end Print_Test_Summary;

end Main_SI_Units_Test;
