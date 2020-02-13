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
--  SI_Units, internal support package.
--
--  To ease implementation and avoid duplicating code, most generic subprograms
--  implementing value/string conversion for different types will work by first
--  converting the input value into a floating point value and then call a
--  common subprogram to do the actual conversion.
--------------------------------------------------------------------------------
private package SI_Units.Float_IO is

   type General_Float is new Standard.Long_Long_Float;
   --  General_Float can be replaced by any other float type.  For now, we use
   --  Long_Long_Float which is standard Ada and should have a sufficient
   --  precision for all practical purposes.

   package General_Float_IO is new Ada.Text_IO.Float_IO (Num => General_Float);
   --  Instantiate the appropriate IO package for the type.

end SI_Units.Float_IO;
