import std.stdio;
import std.regex;
import std.conv;
import std.string;
import std.algorithm;
import std.array;

// Length of a side of the square grid of lights
const auto GRID_SIDE = 1000;

// Regular expression to help chop up command strings
auto CMD_REGEX = ctRegex!(`((?:[A-Za-z]+\s*)+) (\d+,\d+) ((?:[A-Za-z]+\s*)+) (\d+,\d+)`);

void apply(int[] lights, string cmdStr) {
  auto cmdParts = matchFirst(cmdStr, CMD_REGEX);
  assert(!cmdParts.empty);

  string cmd = cmdParts[1];

  // Convert the strings of format "123,456" into arrays of
  // unsigned integers.
  uint[] rangeStart = array(cmdParts[2].split(",").map!(s => to!uint(s)));
  uint[] rangeEnd = array(cmdParts[4].split(",").map!(s => to!uint(s)));

  assert(rangeStart.length == 2);
  assert(rangeStart.length == 2);

  for (int row = rangeStart[0]; row <= rangeEnd[0]; row++) {
    for (int col = rangeStart[1]; col <= rangeEnd[1]; col++) {
      switch (cmd) {
        case "turn on":
          lights[row*GRID_SIDE+col] += 1;
          break;

        case "turn off":
          lights[row*GRID_SIDE+col] -= 1;
          if (lights[row*GRID_SIDE+col] < 0) {
            lights[row*GRID_SIDE+col] = 0;
          }
          break;

        case "toggle":
          lights[row*GRID_SIDE+col] += 2;
          break;

        default:
          throw new Exception("unknown command received: " ~ cmd);
      }
    }
  }
}

int main(string[] args) {
  File input = stdin;

  // Read from a file instead of stdin if one is given
  if (args.length > 1) {
    input = File(args[1]);
  }

  int lights[GRID_SIDE * GRID_SIDE];
  foreach (line; input.byLine()) {
    apply(lights, to!string(line));
  }

  // The slice feels kinda dirty, but apparently static arrays
  // are not ranges and so can't be passed to map().
  auto brightness = lights[0..$].sum();
  writeln("Total brightness: ", brightness);

  return 0;
}
