--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

with Ada.Text_IO;

--------------------------------------------------------------------------------
--  Image subprograms for metric (SI) physical values.
--
--  Please note that the rather unusual prefixes centi, deci, Deka, and Hecto
--  are not supported by these subprograms.  You can use the Scaling package to
--  convert between differently prefixed value and work from there, though.
--------------------------------------------------------------------------------
package SI_Units.Metric is

   type Prefixes is (yocto, zepto, atto, femto, pico, nano, micro, milli,
                     None,
                     kilo, Mega, Giga, Tera, Peta, Exa, Zetta, Yotta);
   --  Prefixes supported in instantiated Image subprograms.

   Magnitude : constant := 1000.0;
   --  Magnitude change when trying to find the best representation for a given
   --  value.

   --
   --  Generic image function for different types.
   --
   --  Parameters:
   --
   --  Item        - the type you want an Image function instantiated for.
   --  Default_Aft - the default number of digits after the decimal point
   --                (regardless of the prefix finally used).
   --  Unit        - The name of your unit, e.g. "Hz", "m" or such (also see
   --                package SI_Units.Names).
   --

   generic
      type Item is delta <>;
      Default_Aft : in Ada.Text_IO.Field;
      Unit        : in Unit_Name;
   function Fixed_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String with
     Global => null;
   --  Image subroutine that can be instantiated for fixed types.

   generic
      type Item is digits <>;
      Default_Aft : in Ada.Text_IO.Field;
      Unit        : in Unit_Name;
   function Float_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String with
     Global => null;
   --  Image subroutine that can be instantiated for floating point types.

   generic
      type Item is range <>;
      Default_Aft : in Ada.Text_IO.Field;
      Unit        : in Unit_Name;
   function Integer_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String with
     Global => null;
   --  Image subroutine that can be instantiated for integer types.

   generic
      type Item is mod <>;
      Default_Aft : in Ada.Text_IO.Field;
      Unit        : in Unit_Name;
   function Mod_Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String with
     Global => null;
   --  Image subroutine that can be instantiated for modular types.

end SI_Units.Metric;
