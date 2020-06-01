--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

--------------------------------------------------------------------------------
--  Binary units scaling support.
--
--  Conversion between differently prefixed raw values, i.e. from GBit to Bit.
--------------------------------------------------------------------------------
package SI_Units.Binary.Scaling is

   pragma Warnings (Off, "declaration hides ""Prefixes"""); -- intentional
   type Prefixes is new SI_Units.Binary.Prefixes with
     Size => Integer'Size;
   pragma Warnings (On, "declaration hides ""Prefixes""");
   for Prefixes use (None =>  0,
                     kibi => 10,
                     mebi => 20,
                     gibi => 30,
                     tebi => 40,
                     pebi => 50,
                     exbi => 60,
                     zebi => 70,
                     yobi => 80);

   generic
      type Item is mod <>;
   function Mod_Scale (Value       : Item;
                       From_Prefix : Prefixes;
                       To_Prefix   : Prefixes := None) return Item;

end SI_Units.Binary.Scaling;
