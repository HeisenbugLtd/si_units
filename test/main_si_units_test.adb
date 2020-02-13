--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

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

begin
   Ada.Text_IO.Put_Line (Modular_BI (-1));
   Ada.Text_IO.Put_Line (Modular_MI (-1));
   Ada.Text_IO.Put_Line (Modular_BI (1023));
   Ada.Text_IO.Put_Line (Modular_MI (1023));
   Ada.Text_IO.Put_Line (Modular_BI (1024));
   Ada.Text_IO.Put_Line (Modular_MI (1024));
   Ada.Text_IO.Put_Line (Modular_BI (1025));
   Ada.Text_IO.Put_Line (Modular_MI (1025));

   Ada.Text_IO.Put_Line (Fixed_MI (0.0));
   Ada.Text_IO.Put_Line (Fixed_MI (Scalar'Small));
   Ada.Text_IO.Put_Line (Fixed_MI (Scalar'First));
   Ada.Text_IO.Put_Line (Fixed_MI (Scalar'Last));

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

   Ada.Text_IO.Put_Line (Float_MI (0.0));
   Ada.Text_IO.Put_Line (Float_MI (Long_Float'Safe_Small));
   Ada.Text_IO.Put_Line (Float_MI (Long_Float'Safe_First));
   Ada.Text_IO.Put_Line (Float_MI (Long_Float'Safe_Last));

   Ada.Text_IO.Put_Line (Float_MI (-9.999_999_49E27));
   Ada.Text_IO.Put_Line (Float_MI (9.999_999_49E27));

   Ada.Text_IO.Put_Line (Float_MI (-1.0E27));
   Ada.Text_IO.Put_Line (Float_MI (1.0E27)); -- "infinity"
   Ada.Text_IO.Put_Line (Float_MI (-1.0E24));
   Ada.Text_IO.Put_Line (Float_MI (1.0E24)); -- Yotta
   Ada.Text_IO.Put_Line (Float_MI (-1.0E21));
   Ada.Text_IO.Put_Line (Float_MI (1.0E21)); -- Zeta
   Ada.Text_IO.Put_Line (Float_MI (-1.0E18));
   Ada.Text_IO.Put_Line (Float_MI (1.0E18)); -- Exa
   Ada.Text_IO.Put_Line (Float_MI (-1.0E15));
   Ada.Text_IO.Put_Line (Float_MI (1.0E15)); -- Peta
   Ada.Text_IO.Put_Line (Float_MI (-1.0E12));
   Ada.Text_IO.Put_Line (Float_MI (1.0E12)); -- Tera
   Ada.Text_IO.Put_Line (Float_MI (-1.0E9));
   Ada.Text_IO.Put_Line (Float_MI (1.0E9)); -- Giga
   Ada.Text_IO.Put_Line (Float_MI (-1.0E6));
   Ada.Text_IO.Put_Line (Float_MI (1.0E6)); -- Mega
   Ada.Text_IO.Put_Line (Float_MI (-1.0E3));
   Ada.Text_IO.Put_Line (Float_MI (1.0E3)); -- kilo
   Ada.Text_IO.Put_Line (Float_MI (-1.0E0));
   Ada.Text_IO.Put_Line (Float_MI (1.0E0)); -- None

   Ada.Text_IO.Put_Line (Float_MI (-1.0E-3));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-3)); -- milli
   Ada.Text_IO.Put_Line (Float_MI (-1.0E-6));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-6)); -- micro
   Ada.Text_IO.Put_Line (Float_MI (-1.0E-9));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-9)); -- nano
   Ada.Text_IO.Put_Line (Float_MI (-1.0E-12));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-12)); -- pico
   Ada.Text_IO.Put_Line (Float_MI (-1.0E-15));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-15)); -- femto
   Ada.Text_IO.Put_Line (Float_MI (-1.0E-18));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-18)); -- atto
   Ada.Text_IO.Put_Line (Float_MI (-1.0E-21));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-21)); -- zepto
   Ada.Text_IO.Put_Line (Float_MI (-1.0E-24));
   Ada.Text_IO.Put_Line (Float_MI (1.0E-24)); -- yocto

   Ada.Text_IO.Put_Line (Float_MI (-5.0E-28));
   Ada.Text_IO.Put_Line (Float_MI (5.0E-28)); -- almost zero

   Ada.Text_IO.Put_Line (Float_MI (-4.999_999_999_999_999E-28));
   Ada.Text_IO.Put_Line (Float_MI (4.999_999_999_999_999E-28)); -- virtually zero
end Main_SI_Units_Test;
