--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

--------------------------------------------------------------------------------
--  Names of all officially defined SI units (including derived units).
--
--  Please note that due to current lack of proper unicode support, the symbol
--  for electric resistance is defined as "Ohm" here, not the Greek letter
--  Omega.  The library itself is unicode agnostic, so you can just instantiate
--  your Image subprograms with the proper UTF-8 string.
--------------------------------------------------------------------------------
package SI_Units.Names is

   --  Unit names (as defined by SI).
   Ampere         : constant Unit_Name;
   Becquerel      : constant Unit_Name;
   Candela        : constant Unit_Name;
   Coulomb        : constant Unit_Name;
   Degree_Celsius : constant Unit_Name;
   Farad          : constant Unit_Name;
   Gram           : constant Unit_Name; --  official SI base unit is kilogram
   Gray           : constant Unit_Name;
   Henry          : constant Unit_Name;
   Hertz          : constant Unit_Name;
   Joule          : constant Unit_Name;
   Katal          : constant Unit_Name;
   Kelvin         : constant Unit_Name;
   Lumen          : constant Unit_Name;
   Lux            : constant Unit_Name;
   Metre          : constant Unit_Name;
   Mole           : constant Unit_Name;
   Newton         : constant Unit_Name;
   Ohm            : constant Unit_Name;
   Pascal         : constant Unit_Name;
   Percent        : constant Unit_Name;
   Radian         : constant Unit_Name;
   Second         : constant Unit_Name;
   Siemens        : constant Unit_Name;
   Sievert        : constant Unit_Name;
   Steradian      : constant Unit_Name;
   Tesla          : constant Unit_Name;
   Volt           : constant Unit_Name;
   Watt           : constant Unit_Name;
   Weber          : constant Unit_Name;

private

   Ampere         : constant Unit_Name := "A";
   Becquerel      : constant Unit_Name := "Bq";
   Candela        : constant Unit_Name := "cd";
   Coulomb        : constant Unit_Name := "C";
   Degree_Celsius : constant Unit_Name :=
     Character'Val (16#E2#) &
     Character'Val (16#84#) &
     Character'Val (16#83#); -- U+2103
   Farad          : constant Unit_Name := "F";
   Gram           : constant Unit_Name := "g";
   Gray           : constant Unit_Name := "Gy";
   Henry          : constant Unit_Name := "H";
   Hertz          : constant Unit_Name := "Hz";
   Joule          : constant Unit_Name := "J";
   Katal          : constant Unit_Name := "kat";
   Kelvin         : constant Unit_Name := "K";
   Lumen          : constant Unit_Name := "lm";
   Lux            : constant Unit_Name := "lx";
   Metre          : constant Unit_Name := "m";
   Mole           : constant Unit_Name := "mol";
   Newton         : constant Unit_Name := "N";
   Ohm            : constant Unit_Name :=
     Character'Val (16#E2#) &
     Character'Val (16#84#) &
     Character'Val (16#A6#); -- U+2126
   Pascal         : constant Unit_Name := "Pa";
   Percent        : constant Unit_Name := "%";
   Radian         : constant Unit_Name := "rad";
   Second         : constant Unit_Name := "s";
   Siemens        : constant Unit_Name := "S";
   Sievert        : constant Unit_Name := "Sv";
   Steradian      : constant Unit_Name := "sr";
   Tesla          : constant Unit_Name := "T";
   Volt           : constant Unit_Name := "V";
   Watt           : constant Unit_Name := "W";
   Weber          : constant Unit_Name := "Wb";

end SI_Units.Names;
