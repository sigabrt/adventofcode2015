import std.stdio;
import std.conv;
import std.digest.md;

bool hashStartsWithFiveZeroes(ubyte[] hash) {
  if (hash.length < 3) {
    return false;
  }

  if (hash[0] == 0x00 && hash[1] == 0x00 &&
      (hash[2] & 0xF0) == 0x0) {
    return true;
  } else {
    return false;
  }
}

unittest {
  assert(hashStartsWithFiveZeroes([]) == false);
  assert(hashStartsWithFiveZeroes([0x00, 0x00]) == false);
  assert(hashStartsWithFiveZeroes([0x00, 0x00, 0x00]) == true);
  assert(hashStartsWithFiveZeroes([0x00, 0x00, 0x0F]) == true);
  assert(hashStartsWithFiveZeroes([0x00, 0x00, 0x10]) == false);
  assert(hashStartsWithFiveZeroes([0x10, 0x00, 0x00]) == false);
  assert(hashStartsWithFiveZeroes([0x00, 0xF0, 0x00]) == false);
}

int main(string[] args) {
  if (args.length <= 1) {
    writeln("usage: ", args[0], " hash_prefix");
  }

  string prefix = args[1];
  uint i = 1;
  while (true) {
    string hashInput = prefix ~ to!string(i);
    ubyte[16] hash = md5Of(hashInput);

    if (hashStartsWithFiveZeroes(hash)) {
      writeln(i);
      break;
    }
    i += 1;
  }

  return 0;
}
