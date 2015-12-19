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

/// Calculates the length, in feet, of ribbon required for
/// Santa's elves to adorn a box of the specified size.
///
/// Params:
///   l = length of the box, in feet
///   w = width of the box, in feet
///   h = height of the box, in feet
uint getRibbonLengthForBoxSize(uint l, uint w, uint h) {
  uint perim1 = 2*l + 2*w;
  uint perim2 = 2*w + 2*h;
  uint perim3 = 2*l + 2*h;

  return min(perim1, perim2, perim3) + (l * w * h);
}

unittest {
  assert(getRibbonLengthForBoxSize(0, 0, 0) == 0);
  assert(getRibbonLengthForBoxSize(2, 3, 4) == 34);
  assert(getRibbonLengthForBoxSize(1, 1, 10) == 14);
}

int main(string[] args) {
  File input = stdin;

  // Read from a file instead of stdin if one is given
  if (args.length > 1) {
    input = File(args[1]);
  }

  uint wrappingPaperArea = 0;
  uint ribbonLength = 0;

  foreach (line; input.byLine()) {
    // Input lines will be of the format WxLxH
    uint[] dimensions = to!(uint[])(line.split('x'));
    
    wrappingPaperArea += getWrappingPaperAreaForBoxSize(
        dimensions[0], dimensions[1], dimensions[2]);
    ribbonLength += getRibbonLengthForBoxSize(
        dimensions[0], dimensions[1], dimensions[2]);
  }

  writeln(wrappingPaperArea, " square feet of wrapping paper");
  writeln(ribbonLength, " feet of ribbon");

  return 0;
}
