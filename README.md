# SI Units

Utility library to pretty print physical units in proper metric units.

### Problem

Assuming you're writing software that deals with real world values (like frequency, speed, distance, pressure, etc. pp.), at some point you probably want to print values of such types.  To be nice to the user, such values should be properly formatted.  Ada provides formatting libraries (like `Float_Text_IO`, or even the simple `'Image` attribute) for that purpose, but these do not scale input values, they plainly output whatever you give them in whatever formatting you requested.  So, if you are using a base value of "m" for your distance type, a distance of 42.0 km will be output as something like

`42000.000`

by some properly instantiated `Text_IO` package.

### Solution

Use SI_Units!  It provides several `Image` function generics for formatting such values.  What it does, is that it takes the given value into consideration before converting it into a string and returning an appropriately formatted string including the prefixed physical unit.

### Examples

So, in the above example, you first instantiate an appropriate `Image` subprogram for your `Distance` type:

```ada
function Image is new SI_Units.Metric.Float_Image (Item        => Distance,
                                                   Default_Aft => 3,
                                                   Unit        => SI_Units.Meter);
```

This instantiates the subprogram `Image` for the type `Distance`, the default number of digits after the decimal point will be `3` and the unit name is `m` (meter).

Then you can call this `Image` instantiated for your `Distance` type like this:

```ada
Ada.Text_IO.Put_Line (Image (42000.0));
Ada.Text_IO.Put_Line (Image (4200.0));
Ada.Text_IO.Put_Line (Image (420.0));
Ada.Text_IO.Put_Line (Image (42.0));
Ada.Text_IO.Put_Line (Image (4.2));
Ada.Text_IO.Put_Line (Image (0.42));
Ada.Text_IO.Put_Line (Image (0.042));
Ada.Text_IO.Put_Line (Image (0.0042));
Ada.Text_IO.Put_Line (Image (0.00042));
```

and you'll get:

```
42.000 km
4.200 km
420.000 m
42.000 m
4.200 m
420.000 mm
42.000 mm
4.200 mm
420.0 µm
```

Neat, isn't it?

`Default_Aft` is merely provided for convenience, the number of digits after the decimal point can be specified for each call to `Image`:

`Ada.Text_IO.Put_Line (Image (4200.0, Aft => 1));`

will output

`4.2 km`

instead.

### (More) Examples

You may have noticed that the instantiation above used a package name `SI_Units.Metric`.  Now, if you'd expect a child package named `Imperial`, you'd be wrong.  After all, the library is called "SI Units", so sorry, I am not supporting things foot pound per square inch.  But, besided decimal (what we usually call metric), there's also an official definition for binary prefixes.  So, yes, the other child package hierarchy is `SI_Units.Binary` and provides a similar[1] functionality for values that are better written with binary prefixes:

```ada
function Image is new SI_Units.Binary.Mod_Image (Item        => Transmission_Speed,
                                                 Default_Aft => 1,
                                                 Unit        => "byte/s");
```

### Scaling support

Sometimes, dealing with inputs from external sources means that values come in different scales than the ones you're using internally.  For instance, the [JSON API from openweathermap.org](https://openweathermap.org/api) returns the atmospheric pressure in hPa (hecto-Pascal), not in the base unit Pa.  Also, SI defines kg as the base unit, not g(ram), so if you're using values in kg within your program, you may need to convert such values to the prefixless version before feeding it to their respective `Image` subprogram.
We got you covered, `SI_Units.Metric.Scaling` does that for you.  Actually from any prefix into any other prefix.  So, if you need to convert a value given in km into a value in mm, this got you covered.  Just be careful, you may easily exceed the defined range of your type if you scale it around like a mad person.

### Unit names

Unit names given in instantiations are standard strings, except for a tiny, little `Dynamic_Predicate` that states it can either be completely empty or shall not start with white space.  For any proper use, this predicate can be ignored.  I can't think of any proper use case that would warrant the use of a vertical tab between the value and the actual unit.  In fact, both will be separated by a non-breaking space for better readability and to confirm with what SI has to say about it.

For your convenience, all the names of the SI defined physical units are declared in `SI_Units.Names`.


[1] There are no SI prefixes defined for absolute values less than one, so the support for binary image is currently restricted to natural numbers.
