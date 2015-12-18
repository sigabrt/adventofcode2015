import std.stdio;
import std.algorithm;
import std.string;
import std.conv;

uint getWrappingPaperSize(uint l, uint w, uint h) {
  uint side1 = l * w;
  uint side2 = w * h;
  uint side3 = l * h;

  // Area of the smallest side
  uint extra = min(side1, side2, side3);

  // Two of each side plus extra
  return (2 * side1) + (2 * side2) + (2 * side3) + extra;
}

unittest {
  assert(getWrappingPaperSize(0, 0, 0) == 0);
  assert(getWrappingPaperSize(1, 0, 0) == 0);
  assert(getWrappingPaperSize(2, 3, 4) == 58);
  assert(getWrappingPaperSize(1, 1, 10) == 43);
}

int main(string[] args) {
  File input = stdin;

  if (args.length > 1) {
    input = File(args[1]);
  }

  uint area = input.byLine()
       .map!(line => line.split('x'))
       .map!(strdims => to!(uint[])(strdims))
       .map!(dims => getWrappingPaperSize(
                         dims[0], dims[1], dims[2]))
       .sum();
  writeln(area, " square feet");
  return 0;
}
