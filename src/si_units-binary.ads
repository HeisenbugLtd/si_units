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
--  Image subprograms for binary (i.e. information technology related) values.
--------------------------------------------------------------------------------
package SI_Units.Binary is

   type Prefixes is (None, kibi, mebi, gibi, tebi, pebi, exbi, zebi, yobi);
   --  Prefixes supported in instantiated Image subprograms.

   Magnitude : constant := 1024.0;
   --  Magnitude change when trying to find the best representation for a given
   --  value.

   --  As this is intended for binary values (i.e. kibiBytes etc.), we neither
   --  support negative nor non-integral values.
   --
   --  TODO: We could support non-modular integral types, though.

   generic
      type Item is mod <>;
      Default_Aft : in Ada.Text_IO.Field;
      Unit        : in Unit_Name;
   function Image
     (Value : in Item;
      Aft   : in Ada.Text_IO.Field := Default_Aft) return String with
     Global => null;
   --  Image function for modular types.
   --
   --  Parameters:
   --
   --  Item        - the type you want an Image function instantiated for.
   --  Default_Aft - the default number of digits after the decimal point
   --                (regardless of the prefix finally used).
   --  Unit        - The name of your unit, e.g. "Bytes", "Bit/s" or such.

end SI_Units.Binary;
