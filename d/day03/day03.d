import std.stdio;
import std.conv;

int main(string[] args) {
  File input = stdin;

  // Read from a file instead of stdin if one is given
  if (args.length > 1) {
    input = File(args[1]);
  }

  uint[int[2]] deliveredPresents;
  int[2] santaPos = [0, 0];
  int[2] roboSantaPos = [0, 0];

  // The first house gets a present too
  deliveredPresents[santaPos] += 1;

  int i = 0;
  foreach (ubyte[] chunk; input.byChunk(1)) {
    char c = to!char(chunk[0]);

    int[] pos;
    if (i%2 == 0) { // Santa moves on even inputs
      pos = santaPos;
    } else {        // Robo santa moves on odd inputs
      pos = roboSantaPos;
    }

    if (c == '<') {
      pos[0] -= 1;
    } else if (c == '>') {
      pos[0] += 1;
    } else if (c == '^') {
      pos[1] += 1;
    } else if (c == 'v') {
      pos[1] -= 1;
    }
    deliveredPresents[to!(int[2])(pos)] += 1;
    i += 1;
  }

  writeln(deliveredPresents.length, " house(s) got at least one present");
  return 0;
}
