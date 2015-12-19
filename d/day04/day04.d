import std.stdio;
import std.conv;
import std.digest.md;
import std.format;
import std.math;

bool hashStartsWithZeroes(ubyte[] hash, uint numZeroes) {
  // Odd numbers of zeroes require n/2+1 bytes, because you
  // can't have half a byte.
  uint numRequiredBytes = ceil(to!float(numZeroes) / 2);
  if (hash.length < numRequiredBytes) {
    return false;
  }

  // Move one nibble at a time
  foreach (i; 0 .. numZeroes) {
    // Mask off the second nibble for even values of i,
    // and vice versa.
    ubyte mask = (i%2 == 0) ? 0xF0 : 0x0F;
    if ((hash[i/2] & mask) != 0) {
      return false;
    }
  }
  return true;
}

unittest {
  assert(hashStartsWithZeroes([], 5) == false);
  assert(hashStartsWithZeroes([0x00, 0x00], 5) == false);
  assert(hashStartsWithZeroes([0x00, 0x00, 0x00], 5) == true);
  assert(hashStartsWithZeroes([0x00, 0x00, 0x0F], 5) == true);
  assert(hashStartsWithZeroes([0x00, 0x00, 0x10], 5) == false);
  assert(hashStartsWithZeroes([0x10, 0x00, 0x00], 5) == false);
  assert(hashStartsWithZeroes([0x00, 0xF0, 0x00], 5) == false);
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

    if (hashStartsWithZeroes(hash, 6)) {
      writeln(i);
      break;
    }
    i += 1;
  }

  return 0;
}
