--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

--------------------------------------------------------------------------------
--  Metric (SI) units scaling support.
--
--  Conversion between differently prefixed raw values, i.e. from hPa to Pa.
--------------------------------------------------------------------------------
package SI_Units.Metric.Scaling is

   pragma Warnings (Off, "declaration hides ""Prefixes"""); -- intentional
   type Prefixes is (yocto, zepto, atto, femto, pico, nano, micro, milli,
                     centi, deci,
                     None,
                     Deka, Hecto,
                     kilo, Mega, Giga, Tera, Peta, Exa, Zetta, Yotta);
   pragma Warnings (On, "declaration hides ""Prefixes""");

   for Prefixes'Size use Integer'Size;

   for Prefixes use (yocto => -24,
                     zepto => -21,
                     atto  => -18,
                     femto => -15,
                     pico  => -12,
                     nano  =>  -9,
                     micro =>  -6,
                     milli =>  -3,
                     centi =>  -2,
                     deci  =>  -1,
                     None  =>   0,
                     Deka  =>   1,
                     Hecto =>   2,
                     kilo  =>   3,
                     Mega  =>   6,
                     Giga  =>   9,
                     Tera  =>  12,
                     Peta  =>  15,
                     Exa   =>  18,
                     Zetta =>  21,
                     Yotta =>  24);

   generic
      type Item is delta <>;
   function Fixed_Scale (Value       : Item;
                         From_Prefix : Prefixes;
                         To_Prefix   : Prefixes := None) return Item;

   generic
      type Item is digits <>;
   function Float_Scale (Value       : Item;
                         From_Prefix : Prefixes;
                         To_Prefix   : Prefixes := None) return Item;

end SI_Units.Metric.Scaling;
