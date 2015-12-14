import std.stdio;

ulong getFloorOffset(string input) {
  ulong offset = 0;
  foreach (i, c; input) {
    if (c == '(') {
      offset += 1;
    } else {
      offset -= 1;
    }
  }
  return offset;
}

unittest {
  // Empty test
  assert(getFloorOffset("") == 0);

  // Simplest inputs
  assert(getFloorOffset("(") == 1);
  assert(getFloorOffset(")") == -1);

  // Basic offsetting combinations
  assert(getFloorOffset("()") == 0);
  assert(getFloorOffset("(())") == 0);
  assert(getFloorOffset("()()") == 0);
}

ulong getFirstBasementInstruction(string input) {
  long offset = 0;
  foreach (i, c; input) {
    if (c == '(') {
      offset += 1;
    } else {
      offset -= 1;
    }

    if (offset < 0) {
      // According to the instructions, the first character position
      // is 1.
      return i+1;
    }
  }
  return 0;
}

unittest {
  // Empty test (0 is the error case)
  assert(getFirstBasementInstruction("") == 0);

  // Simplest successful input
  assert(getFirstBasementInstruction(")") == 1);

  // Slightly more complicated cases
  assert(getFirstBasementInstruction("())") == 3);
  assert(getFirstBasementInstruction("(()(())))(()()") == 9);
}

int main(string[] args) {
  if (args.length <= 1) {
    writeln("usage: ", args[0], " input");
    return 1;
  }

  writeln("Santa ended up on floor #", getFloorOffset(args[1]), ".");

  ulong firstBasementInstructionIndex = getFirstBasementInstruction(args[1]);
  if (firstBasementInstructionIndex != 0) {
    writeln("Santa entered the basement for the first time because of "
            "instruction #", getFirstBasementInstruction(args[1]), ".");
  }
  return 0;
}
