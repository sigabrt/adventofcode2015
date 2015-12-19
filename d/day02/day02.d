import std.stdio;
import std.algorithm;
import std.string;
import std.conv;

 /// Calculates the area, in square feet, of wrapping paper
 /// required for Santa's elves to wrap a box of the
 /// specified size.
 ///
 /// Params:
 ///   l = length of the box, in feet
 ///   w = width of the box, in feet
 ///   h = height of the box, in feet
 uint getWrappingPaperAreaForBoxSize(uint l, uint w, uint h) {
  uint side1 = l * w;
  uint side2 = w * h;
  uint side3 = l * h;

  // Area of the smallest side
  uint extra = min(side1, side2, side3);

  // Two of each side plus extra
  return (2 * side1) + (2 * side2) + (2 * side3) + extra;
}

unittest {
  assert(getWrappingPaperAreaForBoxSize(0, 0, 0) == 0);
  assert(getWrappingPaperAreaForBoxSize(1, 0, 0) == 0);
  assert(getWrappingPaperAreaForBoxSize(2, 3, 4) == 58);
  assert(getWrappingPaperAreaForBoxSize(1, 1, 10) == 43);
}

int main(string[] args) {
  File input = stdin;

  if (args.length > 1) {
    input = File(args[1]);
  }

  uint area = input.byLine()
       .map!(line => line.split('x'))                // Input is of the format AxBxC, split the three dimensions.
       .map!(strdims => to!(uint[])(strdims))        // Convert the resulting array of strings to an array of integers.
       .map!(dims => getWrappingPaperAreaForBoxSize( // Get the amount of wrapping paper required for the specified
                         dims[0], dims[1], dims[2])) // box size.
       .sum();                                       // Add all the results together.
  writeln(area, " square feet");
  return 0;
}
