import std.stdio;
import std.conv;

int main(string[] args) {
  File input = stdin;

  // Read from a file instead of stdin if one is given
  if (args.length > 1) {
    input = File(args[1]);
  }

  uint[int[2]] deliveredPresents;
  int[2] currentHouse = [0, 0];

  // The first house gets a present too
  deliveredPresents[currentHouse] += 1;

  foreach (ubyte[] chunk; input.byChunk(1)) {
    char c = to!char(chunk[0]);
    
    if (c == '<') {
      currentHouse[0] -= 1;
    } else if (c == '>') {
      currentHouse[0] += 1;
    } else if (c == '^') {
      currentHouse[1] += 1;
    } else if (c == 'v') {
      currentHouse[1] -= 1;
    }
    deliveredPresents[currentHouse] += 1;
  }

  writeln(deliveredPresents.length, " house(s) got at least one present");
  return 0;
}
