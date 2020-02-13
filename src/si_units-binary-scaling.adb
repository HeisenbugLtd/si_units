--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

with Ada.Unchecked_Conversion;
with SI_Units.Float_IO;

package body SI_Units.Binary.Scaling is

   function To_Exponent is new Ada.Unchecked_Conversion (Source => Prefixes,
                                                         Target => Integer);

   use type Float_IO.General_Float;

   function General_Scale
     (Value       : in Float_IO.General_Float;
      From_Prefix : in Prefixes;
      To_Prefix   : in Prefixes) return Float_IO.General_Float
   is
     (Value * 2.0 ** (To_Exponent (From_Prefix) - To_Exponent (To_Prefix)));

   function Mod_Scale (Value       : in Item;
                       From_Prefix : in Prefixes;
                       To_Prefix   : in Prefixes := None) return Item is
     (Item (General_Scale (Value       => Float_IO.General_Float (Value),
                           From_Prefix => From_Prefix,
                           To_Prefix   => To_Prefix)));

end SI_Units.Binary.Scaling;
