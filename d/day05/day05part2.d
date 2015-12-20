import std.stdio;
import std.conv;
import std.algorithm;
import std.string;
import std.array;
import std.range;
import std.math;

bool isStringNice(string str) {
  bool repeatedPattern = false;
  for (int i = 0; i < (str.length - 1); i++) {
    string pattern = str[i..i+2];

    // If the first and last index are separated from each
    // other by at least two characters, we have two distinct
    // occurences of this pattern.
    if (abs(str.indexOf(pattern) - str.lastIndexOf(pattern)) > 1) {
      repeatedPattern = true;
      break;
    }
  }

  // Nice strings must have a two letter pattern that repeats
  // at least once.
  if (!repeatedPattern) {
    return false;
  }

  bool sandwich = false;
  for (int i = 0; i < (str.length - 2); i++) {
    if (str[i] == str[i+2]) {
      sandwich = true;
      break;
    }
  }

  // Nice strings must have at least one occurrence of a
  // 'letter sandwich', i.e. 'xyx', 'ztz', 'aaa'
  if (!sandwich) {
    return false;
  }

  return true;
}

unittest {
  assert(isStringNice("qjhvhtzxzqqjkmpb") == true);
  assert(isStringNice("xxyxx") == true);
  assert(isStringNice("aaabzb") == false);
  assert(isStringNice("uurcxstgmygtbstg") == false);
  assert(isStringNice("ieodomkazucvgmuy") == false);
}

int main(string[] args) {
  File input = stdin;

  // Read from a file instead of stdin if one is given
  if (args.length > 1) {
    input = File(args[1]);
  }

  auto niceWords = array(
    input.byLine().filter!(
      s => isStringNice(to!string(s))));
  writeln(niceWords.length, " nice words in input");
  return 0;
}
