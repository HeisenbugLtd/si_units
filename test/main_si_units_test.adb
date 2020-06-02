--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

with Ada.Command_Line;
with Ada.Text_IO;
with SI_Units.Binary.Scaling;
pragma Unreferenced (SI_Units.Binary.Scaling);
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

   function Scale_Float is
     new SI_Units.Metric.Scaling.Float_Scale (Item => Long_Float);

   package Test_Cases is

      procedure Add (Passed  : in Boolean;
                     Message : in String);

      function Num_Total return Natural;
      function Num_Passed return Natural;

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
            Ada.Text_IO.Put_Line
              (Item =>
                 "Test_Case" & Num_Test_Cases'Image & " failed: " & Message);
         end if;
      end Add;

      function Num_Passed return Natural is (Num_Succeeded);
      function Num_Total  return Natural is (Num_Test_Cases);
   end Test_Cases;

   Micro_Sign     : constant String :=
     Character'Val (16#C2#) & Character'Val (16#B5#);
   No_Break_Space : constant String :=
     Character'Val (16#C2#) & Character'Val (16#A0#);

   type String_Access is not null access String;
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
     (Passed  =>
        Fixed_MI (0.0) = "0.000000" & No_Break_Space & SI_Units.Names.Ampere,
      Message => "Fixed_MI (0.0)");

   Test_Cases.Add
     (Passed  =>
        Fixed_MI (Scalar'Small) = "232.830644" & No_Break_Space & "p" &
        SI_Units.Names.Ampere,
      Message => "Fixed_MI (Scalar'Small)");

   Test_Cases.Add
     (Passed  =>
        Fixed_MI (Scalar'First) = "-2.147484" & No_Break_Space & "G" &
        SI_Units.Names.Ampere,
      Message => "Fixed_MI (Scalar'First)");

   Test_Cases.Add
     (Passed  =>
        Fixed_MI (Scalar'Last) = "2.147484" & No_Break_Space & "G" &
        SI_Units.Names.Ampere,
      Message => "Fixed_MI (Scalar'Last)");

   declare
      Normal_Suffix : constant String := No_Break_Space & SI_Units.Names.Ampere;
      Kilo_Suffix   : constant String :=
        No_Break_Space & "k" & SI_Units.Names.Ampere;

      type Loop_Iteration is range 1 .. 32;
      type Expected_List is array (Loop_Iteration) of String_Access;
      Median  : constant Scalar := 1000.0;
      Operand : Scalar          := 1.0;
   begin
      declare
         --  Known memory leak due to string creation. As this is a test program
         --  only run once we don't care.
         Expected_Results : constant Expected_List :=
           (32      => new String'("999.000000" & Normal_Suffix),
            31      => new String'("999.500000" & Normal_Suffix),
            30      => new String'("999.750000" & Normal_Suffix),
            29      => new String'("999.875000" & Normal_Suffix),
            28      => new String'("999.937500" & Normal_Suffix),
            27      => new String'("999.968750" & Normal_Suffix),
            26      => new String'("999.984375" & Normal_Suffix),
            25      => new String'("999.992188" & Normal_Suffix),
            24      => new String'("999.996094" & Normal_Suffix),
            23      => new String'("999.998047" & Normal_Suffix),
            22      => new String'("999.999023" & Normal_Suffix),
            21      => new String'("999.999512" & Normal_Suffix),
            20      => new String'("999.999756" & Normal_Suffix),
            19      => new String'("999.999878" & Normal_Suffix),
            18      => new String'("999.999939" & Normal_Suffix),
            17      => new String'("999.999969" & Normal_Suffix),
            16      => new String'("999.999985" & Normal_Suffix),
            15      => new String'("999.999992" & Normal_Suffix),
            14      => new String'("999.999996" & Normal_Suffix),
            13      => new String'("999.999998" & Normal_Suffix),
            12      => new String'("999.999999" & Normal_Suffix),
            1 .. 11 => new String'("1.000000"   & Kilo_Suffix));
      begin
         for Exponent in reverse Loop_Iteration loop
            Test_Cases.Add
              (Passed  =>
                 Fixed_MI (Median - Operand) = Expected_Results (Exponent).all,
               Message => "Fixed_MI (Median - Operand)/" & Exponent'Image);
            Operand := Operand / 2.0;
         end loop;
      end;

      Test_Cases.Add
        (Passed  =>
           Fixed_MI (Median) = "1.000000" & No_Break_Space & "k" &
           SI_Units.Names.Ampere,
         Message => "Fixed_MI (Median)");

      declare
         --  Known memory leak due to string creation. As this is a test program
         --  only run once we don't care.
         Expected_Results : constant Expected_List :=
           (1 .. 22 => new String'("1.000000" & Kilo_Suffix),
            23      => new String'("1.000001" & Kilo_Suffix),
            24      => new String'("1.000002" & Kilo_Suffix),
            25      => new String'("1.000004" & Kilo_Suffix),
            26      => new String'("1.000008" & Kilo_Suffix),
            27      => new String'("1.000016" & Kilo_Suffix),
            28      => new String'("1.000031" & Kilo_Suffix),
            29      => new String'("1.000062" & Kilo_Suffix),
            30      => new String'("1.000125" & Kilo_Suffix),
            31      => new String'("1.000250" & Kilo_Suffix),
            32      => new String'("1.000500" & Kilo_Suffix));
      begin
         for Exponent in Loop_Iteration loop
            Test_Cases.Add
              (Passed  =>
                 Fixed_MI (Median + Operand) = Expected_Results (Exponent).all,
               Message => "Fixed_MI (Median + Operand)/" & Exponent'Image);
            Operand := Operand * 2.0;
         end loop;
      end;
   end;

   declare
      subtype Loop_Iteration is Natural range 1 .. 18;
      type Less_Equal_Greater is (LT, EQ, GT);
      type Expected_List is array (Loop_Iteration,
                                   Less_Equal_Greater) of String_Access;

      Median    : constant Scalar := 1000.0;
      LT_Median : constant Scalar := Median - Scalar'Small;
      GT_Median : constant Scalar := Median + Scalar'Small;
      Normal_Suffix : constant String := No_Break_Space & SI_Units.Names.Ampere;
      Kilo_Suffix   : constant String :=
        No_Break_Space & "k" & SI_Units.Names.Ampere;

      Expected_Results : constant Expected_List :=
        (01 => (LT => new String'("1.0"                    & Kilo_Suffix),
                EQ => new String'("1.0"                    & Kilo_Suffix),
                GT => new String'("1.0"                    & Kilo_Suffix)),
         02 => (LT => new String'("1.00"                   & Kilo_Suffix),
                EQ => new String'("1.00"                   & Kilo_Suffix),
                GT => new String'("1.00"                   & Kilo_Suffix)),
         03 => (LT => new String'("1.000"                  & Kilo_Suffix),
                EQ => new String'("1.000"                  & Kilo_Suffix),
                GT => new String'("1.000"                  & Kilo_Suffix)),
         04 => (LT => new String'("1.0000"                 & Kilo_Suffix),
                EQ => new String'("1.0000"                 & Kilo_Suffix),
                GT => new String'("1.0000"                 & Kilo_Suffix)),
         05 => (LT => new String'("1.00000"                & Kilo_Suffix),
                EQ => new String'("1.00000"                & Kilo_Suffix),
                GT => new String'("1.00000"                & Kilo_Suffix)),
         06 => (LT => new String'("1.000000"               & Kilo_Suffix),
                EQ => new String'("1.000000"               & Kilo_Suffix),
                GT => new String'("1.000000"               & Kilo_Suffix)),
         07 => (LT => new String'("1.0000000"              & Kilo_Suffix),
                EQ => new String'("1.0000000"              & Kilo_Suffix),
                GT => new String'("1.0000000"              & Kilo_Suffix)),
         08 => (LT => new String'("1.00000000"             & Kilo_Suffix),
                EQ => new String'("1.00000000"             & Kilo_Suffix),
                GT => new String'("1.00000000"             & Kilo_Suffix)),
         09 => (LT => new String'("1.000000000"            & Kilo_Suffix),
                EQ => new String'("1.000000000"            & Kilo_Suffix),
                GT => new String'("1.000000000"            & Kilo_Suffix)),
         10 => (LT => new String'("999.9999999998"         & Normal_Suffix),
                EQ => new String'("1.0000000000"           & Kilo_Suffix),
                GT => new String'("1.0000000000"           & Kilo_Suffix)),
         11 => (LT => new String'("999.99999999977"        & Normal_Suffix),
                EQ => new String'("1.00000000000"          & Kilo_Suffix),
                GT => new String'("1.00000000000"          & Kilo_Suffix)),
         12 => (LT => new String'("999.999999999767"       & Normal_Suffix),
                EQ => new String'("1.000000000000"         & Kilo_Suffix),
                GT => new String'("1.000000000000"         & Kilo_Suffix)),
         13 => (LT => new String'("999.9999999997672"      & Normal_Suffix),
                EQ => new String'("1.0000000000000"        & Kilo_Suffix),
                GT => new String'("1.0000000000002"        & Kilo_Suffix)),
         14 => (LT => new String'("999.99999999976717"     & Normal_Suffix),
                EQ => new String'("1.00000000000000"       & Kilo_Suffix),
                GT => new String'("1.00000000000023"       & Kilo_Suffix)),
         15 => (LT => new String'("999.999999999767169"    & Normal_Suffix),
                EQ => new String'("1.000000000000000"      & Kilo_Suffix),
                GT => new String'("1.000000000000233"      & Kilo_Suffix)),
         16 => (LT => new String'("999.9999999997671690"   & Normal_Suffix),
                EQ => new String'("1.0000000000000000"     & Kilo_Suffix),
                GT => new String'("1.0000000000002328"     & Kilo_Suffix)),
         17 => (LT => new String'("999.99999999976716900"  & Normal_Suffix),
                EQ => new String'("1.00000000000000000"    & Kilo_Suffix),
                GT => new String'("1.00000000000023283"    & Kilo_Suffix)),
         18 => (LT => new String'("999.999999999767169000" & Normal_Suffix),
                EQ => new String'("1.000000000000000000"   & Kilo_Suffix),
                GT => new String'("1.000000000000232830"   & Kilo_Suffix)));
   begin
      for Aft in Loop_Iteration loop
         Test_Cases.Add
           (Passed  => Fixed_MI (Value => LT_Median,
                                 Aft   => Aft) = Expected_Results (Aft, LT).all,
            Message =>
              "Fixed_MI (Value => LT_Median, Aft =>" & Aft'Image & ")");
         Test_Cases.Add
           (Passed  => Fixed_MI (Value => Median,
                                 Aft   => Aft) = Expected_Results (Aft, EQ).all,
            Message => "Fixed_MI (Value => Median, Aft =>" & Aft'Image & ")");
         Test_Cases.Add
           (Passed  => Fixed_MI (Value => GT_Median,
                                 Aft   => Aft) = Expected_Results (Aft, GT).all,
            Message =>
              "Fixed_MI (Value => GT_Median, Aft =>" & Aft'Image & ")");
      end loop;
   end;

   Test_Cases.Add
     (Passed  =>
        Float_MI (0.0) = "0.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (0.0)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (Long_Float'Safe_Small) = "0.000" &
        No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (Long_Float'Safe_Small)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (Long_Float'Safe_First) = "-inf    " & No_Break_Space &
        SI_Units.Names.Volt,
      Message => "Float_MI (Long_Float'Safe_First)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (Long_Float'Safe_Last) = "+inf    " &
        No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (Long_Float'Safe_Last)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (-9.999_999_49E27) = "-inf    " & No_Break_Space &
        SI_Units.Names.Volt,
      Message => "Float_MI (-9.999_999_49E27)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (9.999_999_49E27) = "9999.999" & No_Break_Space & "Y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (9.999_999_49E27)");

   --  "infinity"
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E27) = "-inf    " & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E27)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E27) = "1000.000" & No_Break_Space & "Y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E27)");

   --  Yotta
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E24) = "-1.000" & No_Break_Space & "Y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E24)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E24) = "1.000" & No_Break_Space & "Y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E24)");

   --  Zeta
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E21) = "-1.000" & No_Break_Space & "Z" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E21)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E21) = "1.000" & No_Break_Space & "Z" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E21)");

   --  Exa
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E18) = "-1.000" & No_Break_Space & "E" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E18)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E18) = "1.000" & No_Break_Space & "E" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E18)");

   --  Peta
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E15) = "-1.000" & No_Break_Space & "P" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E15)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E15) = "1.000" & No_Break_Space & "P" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E15)");

   --  Tera
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E12) = "-1.000" & No_Break_Space & "T" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E12)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E12) = "1.000" & No_Break_Space & "T" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E12)");

   --  Giga
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E9) = "-1.000" & No_Break_Space & "G" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E9)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E9) = "1.000" & No_Break_Space & "G" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E9)");

   --  Mega
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E6) = "-1.000" & No_Break_Space & "M" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E6)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E6) = "1.000" & No_Break_Space & "M" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E6)");

   --  kilo
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E3) = "-1.000" & No_Break_Space & "k" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E3)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E3) = "1.000" & No_Break_Space & "k" & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E3)");

   --  None
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E0) = "-1.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E0)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E0) = "1.000" & No_Break_Space & SI_Units.Names.Volt,
      Message => "Float_MI (1.0E0)");

   --  milli
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-3) = "-1.000" & No_Break_Space & "m" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-3)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-3) = "1.000" & No_Break_Space & "m" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-3)");

   --  micro
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-6) = "-1.000" & No_Break_Space & Micro_Sign &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-6)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-6) = "1.000" & No_Break_Space & Micro_Sign &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-6)");

   --  nano
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-9) = "-1.000" & No_Break_Space & "n" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-9)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-9) = "1.000" & No_Break_Space & "n" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-9)");

   --  pico
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-12) = "-1.000" & No_Break_Space & "p" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-12)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-12) = "1.000" & No_Break_Space & "p" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-12)");

   --  femto
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-15) = "-1.000" & No_Break_Space & "f" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-15)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-15) = "1.000" & No_Break_Space & "f" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-15)");

   --  atto
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-18) = "-1.000" & No_Break_Space & "a" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-18)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-18) = "1.000" & No_Break_Space & "a" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-18)");

   --  zepto
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-21) = "-1.000" & No_Break_Space & "z" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-21)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-21) = "1.000" & No_Break_Space & "z" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-21)");

   --  yocto
   Test_Cases.Add
     (Passed  =>
        Float_MI (-1.0E-24) = "-1.000" & No_Break_Space & "y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-1.0E-24)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (1.0E-24) = "1.000" & No_Break_Space & "y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (1.0E-24)");

   --  almost zero, still with (smallest) prefix
   Test_Cases.Add
     (Passed  =>
        Float_MI (-5.0E-28) = "-0.001" & No_Break_Space & "y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (-5.0E-28)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (5.0E-28) = "0.001" & No_Break_Space & "y" &
        SI_Units.Names.Volt,
      Message => "Float_MI (5.0E-28)");

   --  virtually zero, no prefix
   Test_Cases.Add
     (Passed  =>
        Float_MI (-4.999_999_999_999_999E-28) = "-0.000" & No_Break_Space &
        SI_Units.Names.Volt,
      Message => "Float_MI (-4.999_999_999_999_999E-28)");

   Test_Cases.Add
     (Passed  =>
        Float_MI (4.999_999_999_999_999E-28) = "0.000" & No_Break_Space &
        SI_Units.Names.Volt,
      Message => "Float_MI (4.999_999_999_999_999E-28)");

   --  Scaling tests
   for From_Prefix in SI_Units.Metric.Scaling.Prefixes loop
      for To_Prefix in SI_Units.Metric.Scaling.Prefixes loop
         Build_Lookup : -- Calculate expected value by hand.
         declare
            type Prefix_Matrix is
              array (SI_Units.Metric.Scaling.Prefixes,
                     SI_Units.Metric.Scaling.Prefixes) of Long_Float;
            use all type SI_Units.Metric.Scaling.Prefixes;
            Scale_Lookup : constant Prefix_Matrix :=
              (yocto => (yocto => 1.0E0,
                         zepto => 1.0E-3,
                         atto  => 1.0E-6,
                         femto => 1.0E-9,
                         pico  => 1.0E-12,
                         nano  => 1.0E-15,
                         micro => 1.0E-18,
                         milli => 1.0E-21,
                         centi => 1.0E-22,
                         deci  => 1.0E-23,
                         None  => 1.0E-24,
                         Deka  => 1.0E-25,
                         Hecto => 1.0E-26,
                         kilo  => 1.0E-27,
                         Mega  => 1.0E-30,
                         Giga  => 1.0E-33,
                         Tera  => 1.0E-36,
                         Peta  => 1.0E-39,
                         Exa   => 1.0E-42,
                         Zetta => 1.0E-45,
                         Yotta => 1.0E-48),
               zepto => (yocto => 1.0E3,
                         zepto => 1.0E0,
                         atto  => 1.0E-3,
                         femto => 1.0E-6,
                         pico  => 1.0E-9,
                         nano  => 1.0E-12,
                         micro => 1.0E-15,
                         milli => 1.0E-18,
                         centi => 1.0E-19,
                         deci  => 1.0E-20,
                         None  => 1.0E-21,
                         Deka  => 1.0E-22,
                         Hecto => 1.0E-23,
                         kilo  => 1.0E-24,
                         Mega  => 1.0E-27,
                         Giga  => 1.0E-30,
                         Tera  => 1.0E-33,
                         Peta  => 1.0E-36,
                         Exa   => 1.0E-39,
                         Zetta => 1.0E-42,
                         Yotta => 1.0E-45),
               atto  => (yocto => 1.0E6,
                         zepto => 1.0E3,
                         atto  => 1.0E0,
                         femto => 1.0E-3,
                         pico  => 1.0E-6,
                         nano  => 1.0E-9,
                         micro => 1.0E-12,
                         milli => 1.0E-15,
                         centi => 1.0E-16,
                         deci  => 1.0E-17,
                         None  => 1.0E-18,
                         Deka  => 1.0E-19,
                         Hecto => 1.0E-20,
                         kilo  => 1.0E-21,
                         Mega  => 1.0E-24,
                         Giga  => 1.0E-27,
                         Tera  => 1.0E-30,
                         Peta  => 1.0E-33,
                         Exa   => 1.0E-36,
                         Zetta => 1.0E-39,
                         Yotta => 1.0E-42),
               femto => (yocto => 1.0E9,
                         zepto => 1.0E6,
                         atto  => 1.0E3,
                         femto => 1.0E0,
                         pico  => 1.0E-3,
                         nano  => 1.0E-6,
                         micro => 1.0E-9,
                         milli => 1.0E-12,
                         centi => 1.0E-13,
                         deci  => 1.0E-14,
                         None  => 1.0E-15,
                         Deka  => 1.0E-16,
                         Hecto => 1.0E-17,
                         kilo  => 1.0E-18,
                         Mega  => 1.0E-21,
                         Giga  => 1.0E-24,
                         Tera  => 1.0E-27,
                         Peta  => 1.0E-30,
                         Exa   => 1.0E-33,
                         Zetta => 1.0E-36,
                         Yotta => 1.0E-39),
               pico  => (yocto => 1.0E12,
                         zepto => 1.0E9,
                         atto  => 1.0E6,
                         femto => 1.0E3,
                         pico  => 1.0E0,
                         nano  => 1.0E-3,
                         micro => 1.0E-6,
                         milli => 1.0E-9,
                         centi => 1.0E-10,
                         deci  => 1.0E-11,
                         None  => 1.0E-12,
                         Deka  => 1.0E-13,
                         Hecto => 1.0E-14,
                         kilo  => 1.0E-15,
                         Mega  => 1.0E-18,
                         Giga  => 1.0E-21,
                         Tera  => 1.0E-24,
                         Peta  => 1.0E-27,
                         Exa   => 1.0E-30,
                         Zetta => 1.0E-33,
                         Yotta => 1.0E-36),
               nano  => (yocto => 1.0E15,
                         zepto => 1.0E12,
                         atto  => 1.0E9,
                         femto => 1.0E6,
                         pico  => 1.0E3,
                         nano  => 1.0E0,
                         micro => 1.0E-3,
                         milli => 1.0E-6,
                         centi => 1.0E-7,
                         deci  => 1.0E-8,
                         None  => 1.0E-9,
                         Deka  => 1.0E-10,
                         Hecto => 1.0E-11,
                         kilo  => 1.0E-12,
                         Mega  => 1.0E-15,
                         Giga  => 1.0E-18,
                         Tera  => 1.0E-21,
                         Peta  => 1.0E-24,
                         Exa   => 1.0E-27,
                         Zetta => 1.0E-30,
                         Yotta => 1.0E-33),
               micro => (yocto => 1.0E18,
                         zepto => 1.0E15,
                         atto  => 1.0E12,
                         femto => 1.0E9,
                         pico  => 1.0E6,
                         nano  => 1.0E3,
                         micro => 1.0E0,
                         milli => 1.0E-3,
                         centi => 1.0E-4,
                         deci  => 1.0E-5,
                         None  => 1.0E-6,
                         Deka  => 1.0E-7,
                         Hecto => 1.0E-8,
                         kilo  => 1.0E-9,
                         Mega  => 1.0E-12,
                         Giga  => 1.0E-15,
                         Tera  => 1.0E-18,
                         Peta  => 1.0E-21,
                         Exa   => 1.0E-24,
                         Zetta => 1.0E-27,
                         Yotta => 1.0E-30),
               milli => (yocto => 1.0E21,
                         zepto => 1.0E18,
                         atto  => 1.0E15,
                         femto => 1.0E12,
                         pico  => 1.0E9,
                         nano  => 1.0E6,
                         micro => 1.0E3,
                         milli => 1.0E0,
                         centi => 1.0E-1,
                         deci  => 1.0E-2,
                         None  => 1.0E-3,
                         Deka  => 1.0E-4,
                         Hecto => 1.0E-5,
                         kilo  => 1.0E-6,
                         Mega  => 1.0E-9,
                         Giga  => 1.0E-12,
                         Tera  => 1.0E-15,
                         Peta  => 1.0E-18,
                         Exa   => 1.0E-21,
                         Zetta => 1.0E-24,
                         Yotta => 1.0E-27),
               centi => (yocto => 1.0E22,
                         zepto => 1.0E19,
                         atto  => 1.0E16,
                         femto => 1.0E13,
                         pico  => 1.0E10,
                         nano  => 1.0E7,
                         micro => 1.0E4,
                         milli => 1.0E1,
                         centi => 1.0E0,
                         deci  => 1.0E-1,
                         None  => 1.0E-2,
                         Deka  => 1.0E-3,
                         Hecto => 1.0E-4,
                         kilo  => 1.0E-5,
                         Mega  => 1.0E-8,
                         Giga  => 1.0E-11,
                         Tera  => 1.0E-14,
                         Peta  => 1.0E-17,
                         Exa   => 1.0E-20,
                         Zetta => 1.0E-23,
                         Yotta => 1.0E-26),
               deci  => (yocto => 1.0E23,
                         zepto => 1.0E20,
                         atto  => 1.0E17,
                         femto => 1.0E14,
                         pico  => 1.0E11,
                         nano  => 1.0E8,
                         micro => 1.0E5,
                         milli => 1.0E2,
                         centi => 1.0E1,
                         deci  => 1.0E0,
                         None  => 1.0E-1,
                         Deka  => 1.0E-2,
                         Hecto => 1.0E-3,
                         kilo  => 1.0E-4,
                         Mega  => 1.0E-7,
                         Giga  => 1.0E-10,
                         Tera  => 1.0E-13,
                         Peta  => 1.0E-16,
                         Exa   => 1.0E-19,
                         Zetta => 1.0E-22,
                         Yotta => 1.0E-25),
               None  => (yocto => 1.0E24,
                         zepto => 1.0E21,
                         atto  => 1.0E18,
                         femto => 1.0E15,
                         pico  => 1.0E12,
                         nano  => 1.0E9,
                         micro => 1.0E6,
                         milli => 1.0E3,
                         centi => 1.0E2,
                         deci  => 1.0E1,
                         None  => 1.0E0,
                         Deka  => 1.0E-1,
                         Hecto => 1.0E-2,
                         kilo  => 1.0E-3,
                         Mega  => 1.0E-6,
                         Giga  => 1.0E-9,
                         Tera  => 1.0E-12,
                         Peta  => 1.0E-15,
                         Exa   => 1.0E-18,
                         Zetta => 1.0E-21,
                         Yotta => 1.0E-24),
               Deka  => (yocto => 1.0E25,
                         zepto => 1.0E22,
                         atto  => 1.0E19,
                         femto => 1.0E16,
                         pico  => 1.0E13,
                         nano  => 1.0E10,
                         micro => 1.0E7,
                         milli => 1.0E4,
                         centi => 1.0E3,
                         deci  => 1.0E2,
                         None  => 1.0E1,
                         Deka  => 1.0E0,
                         Hecto => 1.0E-1,
                         kilo  => 1.0E-2,
                         Mega  => 1.0E-5,
                         Giga  => 1.0E-8,
                         Tera  => 1.0E-11,
                         Peta  => 1.0E-14,
                         Exa   => 1.0E-17,
                         Zetta => 1.0E-20,
                         Yotta => 1.0E-23),
               Hecto => (yocto => 1.0E26,
                         zepto => 1.0E23,
                         atto  => 1.0E20,
                         femto => 1.0E17,
                         pico  => 1.0E14,
                         nano  => 1.0E11,
                         micro => 1.0E8,
                         milli => 1.0E5,
                         centi => 1.0E4,
                         deci  => 1.0E3,
                         None  => 1.0E2,
                         Deka  => 1.0E1,
                         Hecto => 1.0E0,
                         kilo  => 1.0E-1,
                         Mega  => 1.0E-4,
                         Giga  => 1.0E-7,
                         Tera  => 1.0E-10,
                         Peta  => 1.0E-13,
                         Exa   => 1.0E-16,
                         Zetta => 1.0E-19,
                         Yotta => 1.0E-22),
               kilo  => (yocto => 1.0E27,
                         zepto => 1.0E24,
                         atto  => 1.0E21,
                         femto => 1.0E18,
                         pico  => 1.0E15,
                         nano  => 1.0E12,
                         micro => 1.0E9,
                         milli => 1.0E6,
                         centi => 1.0E5,
                         deci  => 1.0E4,
                         None  => 1.0E3,
                         Deka  => 1.0E2,
                         Hecto => 1.0E1,
                         kilo  => 1.0E0,
                         Mega  => 1.0E-3,
                         Giga  => 1.0E-6,
                         Tera  => 1.0E-9,
                         Peta  => 1.0E-12,
                         Exa   => 1.0E-15,
                         Zetta => 1.0E-18,
                         Yotta => 1.0E-21),
               Mega  => (yocto => 1.0E30,
                         zepto => 1.0E27,
                         atto  => 1.0E24,
                         femto => 1.0E21,
                         pico  => 1.0E18,
                         nano  => 1.0E15,
                         micro => 1.0E12,
                         milli => 1.0E9,
                         centi => 1.0E8,
                         deci  => 1.0E7,
                         None  => 1.0E6,
                         Deka  => 1.0E5,
                         Hecto => 1.0E4,
                         kilo  => 1.0E3,
                         Mega  => 1.0E0,
                         Giga  => 1.0E-3,
                         Tera  => 1.0E-6,
                         Peta  => 1.0E-9,
                         Exa   => 1.0E-12,
                         Zetta => 1.0E-15,
                         Yotta => 1.0E-18),
               Giga  => (yocto => 1.0E33,
                         zepto => 1.0E30,
                         atto  => 1.0E27,
                         femto => 1.0E24,
                         pico  => 1.0E21,
                         nano  => 1.0E18,
                         micro => 1.0E15,
                         milli => 1.0E12,
                         centi => 1.0E11,
                         deci  => 1.0E10,
                         None  => 1.0E9,
                         Deka  => 1.0E8,
                         Hecto => 1.0E7,
                         kilo  => 1.0E6,
                         Mega  => 1.0E3,
                         Giga  => 1.0E0,
                         Tera  => 1.0E-3,
                         Peta  => 1.0E-6,
                         Exa   => 1.0E-9,
                         Zetta => 1.0E-12,
                         Yotta => 1.0E-15),
               Tera  => (yocto => 1.0E36,
                         zepto => 1.0E33,
                         atto  => 1.0E30,
                         femto => 1.0E27,
                         pico  => 1.0E24,
                         nano  => 1.0E21,
                         micro => 1.0E18,
                         milli => 1.0E15,
                         centi => 1.0E14,
                         deci  => 1.0E13,
                         None  => 1.0E12,
                         Deka  => 1.0E11,
                         Hecto => 1.0E10,
                         kilo  => 1.0E9,
                         Mega  => 1.0E6,
                         Giga  => 1.0E3,
                         Tera  => 1.0E0,
                         Peta  => 1.0E-3,
                         Exa   => 1.0E-6,
                         Zetta => 1.0E-9,
                         Yotta => 1.0E-12),
               Peta  => (yocto => 1.0E39,
                         zepto => 1.0E36,
                         atto  => 1.0E33,
                         femto => 1.0E30,
                         pico  => 1.0E27,
                         nano  => 1.0E24,
                         micro => 1.0E21,
                         milli => 1.0E18,
                         centi => 1.0E17,
                         deci  => 1.0E16,
                         None  => 1.0E15,
                         Deka  => 1.0E14,
                         Hecto => 1.0E13,
                         kilo  => 1.0E12,
                         Mega  => 1.0E9,
                         Giga  => 1.0E6,
                         Tera  => 1.0E3,
                         Peta  => 1.0E0,
                         Exa   => 1.0E-3,
                         Zetta => 1.0E-6,
                         Yotta => 1.0E-9),
               Exa   => (yocto => 1.0E42,
                         zepto => 1.0E39,
                         atto  => 1.0E36,
                         femto => 1.0E33,
                         pico  => 1.0E30,
                         nano  => 1.0E27,
                         micro => 1.0E24,
                         milli => 1.0E21,
                         centi => 1.0E20,
                         deci  => 1.0E19,
                         None  => 1.0E18,
                         Deka  => 1.0E17,
                         Hecto => 1.0E16,
                         kilo  => 1.0E15,
                         Mega  => 1.0E12,
                         Giga  => 1.0E9,
                         Tera  => 1.0E6,
                         Peta  => 1.0E3,
                         Exa   => 1.0E0,
                         Zetta => 1.0E-3,
                         Yotta => 1.0E-6),
               Zetta => (yocto => 1.0E45,
                         zepto => 1.0E42,
                         atto  => 1.0E39,
                         femto => 1.0E36,
                         pico  => 1.0E33,
                         nano  => 1.0E30,
                         micro => 1.0E27,
                         milli => 1.0E24,
                         centi => 1.0E23,
                         deci  => 1.0E22,
                         None  => 1.0E21,
                         Deka  => 1.0E20,
                         Hecto => 1.0E19,
                         kilo  => 1.0E18,
                         Mega  => 1.0E15,
                         Giga  => 1.0E12,
                         Tera  => 1.0E9,
                         Peta  => 1.0E6,
                         Exa   => 1.0E3,
                         Zetta => 1.0E0,
                         Yotta => 1.0E-3),
               Yotta => (yocto => 1.0E48,
                         zepto => 1.0E45,
                         atto  => 1.0E42,
                         femto => 1.0E39,
                         pico  => 1.0E36,
                         nano  => 1.0E33,
                         micro => 1.0E30,
                         milli => 1.0E27,
                         centi => 1.0E26,
                         deci  => 1.0E25,
                         None  => 1.0E24,
                         Deka  => 1.0E23,
                         Hecto => 1.0E22,
                         kilo  => 1.0E21,
                         Mega  => 1.0E18,
                         Giga  => 1.0E15,
                         Tera  => 1.0E12,
                         Peta  => 1.0E9,
                         Exa   => 1.0E6,
                         Zetta => 1.0E3,
                         Yotta => 1.0E0));
         begin
            for X in -10 .. 10 loop
               Calculate_Expected :
               declare
                  Origin_Value : constant Long_Float := 2.0 ** X;
                  Expected     : constant Long_Float :=
                    Origin_Value * Scale_Lookup (From_Prefix, To_Prefix);
               begin
                  if Expected /= 0.0 then
                     Test_Cases.Add
                       (Passed =>
                          Scale_Float (Value       => Origin_Value,
                                       From_Prefix => From_Prefix,
                                       To_Prefix   => To_Prefix) = Expected,
                        Message =>
                          "Scale_Float (Value => " & Origin_Value'Image &
                          ", From_Prefix => " & From_Prefix'Image &
                          ", To_Prefix => " & To_Prefix'Image & ")");
                  end if;
               end Calculate_Expected;
            end loop;
         end Build_Lookup;
      end loop;
   end loop;

   pragma Warnings (Off, "static fixed-point value is not a multiple of Small");
   Test_Cases.Add
     (Passed  =>
        Fixed_MI (Value => 0.55, Aft => 0) = "550.0" & No_Break_Space & "m" &
        SI_Units.Names.Ampere,
      Message => "Fixed_MI (0.55)");

   Test_Cases.Add
     (Passed  =>
        Fixed_MI (Value => 0.55, Aft => 1) = "550.0" & No_Break_Space & "m" &
        SI_Units.Names.Ampere,
      Message => "Fixed_MI (0.55)");
   pragma Warnings (On, "static fixed-point value is not a multiple of Small");

   Print_Test_Summary :
   declare
      Total  : constant Natural := Test_Cases.Num_Total;
      Passed : constant Natural := Test_Cases.Num_Passed;
   begin
      Ada.Text_IO.Put_Line
        (Item =>
           "Test results:" & Passed'Image & " out of" & Total'Image &
           " succeeded.");
      Ada.Text_IO.Put_Line
        (Item => (if Passed = Total then "<OK>" else "<FAILED>"));

      Ada.Command_Line.Set_Exit_Status
        (Code => (if Passed = Total
                  then Ada.Command_Line.Success
                  else Ada.Command_Line.Failure));
   end Print_Test_Summary;

end Main_SI_Units_Test;
