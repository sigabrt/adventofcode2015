import std.stdio;
import std.conv;
import std.algorithm;
import std.string;
import std.array;

bool isVowel(dchar c) {
  if (c == 'a' || c == 'e' || c == 'i' ||
      c == 'o' || c == 'u') {
    return true;
  } else {
    return false;
  }
}

bool isStringNice(string str) {
  auto vowels = array(filter!(c => isVowel(c))(str));

  // Nice words must have at least three unique vowels
  if (vowels.length < 3) {
    return false;
  }

  bool doubleLetter = false;
  for (int i = 0; i < (str.length - 1); i++) {
    if (str[i] == str[i+1]) {
      doubleLetter = true;
      break;
    }
  }

  // Nice words must have at least one letter that appears
  // twice in a row.
  if (!doubleLetter) {
    return false;
  }

  string[] badWords = ["ab", "cd", "pq", "xy"];
  auto badWordOccurences = array(badWords.filter!(w => str.indexOf(w) != -1));

  // Nice words cannot have any occurences of the "bad words"
  if (badWordOccurences.length > 0) {
    return false;
  }

  return true;
}

unittest {
  assert(isStringNice("ugknbfddgicrmopn") == true);
  assert(isStringNice("aaa") == true);
  assert(isStringNice("jchzalrnumimnmhp") == false);
  assert(isStringNice("haegwjzuvuyypxyu") == false);
  assert(isStringNice("dvszwmarrgswjxmb") == false);
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
