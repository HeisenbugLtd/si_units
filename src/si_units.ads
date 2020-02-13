--------------------------------------------------------------------------------
--  Copyright (C) 2020 by Heisenbug Ltd. (gh+si_units@heisenbug.eu)
--
--  This work is free. You can redistribute it and/or modify it under the
--  terms of the Do What The Fuck You Want To Public License, Version 2,
--  as published by Sam Hocevar. See the LICENSE file for more details.
--------------------------------------------------------------------------------
pragma License (Unrestricted);

with Ada.Characters.Handling;

private with Ada.Characters.Latin_1;
private with Ada.Strings.Fixed;

package SI_Units with
  Preelaborate => True
is

   No_Unit : constant String;
   --  Designated value for "no unit name", i.e. the empty string.
   --
   --  Normally, when this package and its children are used, we would expect a
   --  non-empty string for any unit (hence the type predicate below), but we
   --  allow the empty string as a special exception.

   subtype Unit_Name is String with
     Dynamic_Predicate =>
       (Unit_Name = No_Unit or else
          (Unit_Name'Length > 0 and then
             (for all C of Unit_Name (Unit_Name'First .. Unit_Name'First) =>
                  not Ada.Characters.Handling.Is_Control (C) and
                  not Ada.Characters.Handling.Is_Space (C))));
   --  Restrict the possibility of a unit name: A unit name can be empty (see
   --  No_Unit), but if it isn't, it shall not start with something weird like
   --  control characters (which includes tabs), or whitespace.  It could start
   --  with digits and other weird stuff, though.

private

   Degree_Sign    : Character renames Ada.Characters.Latin_1.Degree_Sign;
   No_Break_Space : Character renames Ada.Characters.Latin_1.No_Break_Space;
   Micro_Sign     : Character renames Ada.Characters.Latin_1.Micro_Sign;
   Minus_Sign     : Character renames Ada.Characters.Latin_1.Minus_Sign;
   Plus_Sign      : Character renames Ada.Characters.Latin_1.Plus_Sign;

   No_Unit : constant String := "";

   function Trim
     (Source : in String;
      Side   : in Ada.Strings.Trim_End := Ada.Strings.Left) return String
      renames Ada.Strings.Fixed.Trim;

end SI_Units;
