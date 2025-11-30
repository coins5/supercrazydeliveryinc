void main() {
  testFormat(1000, "1.00K");
  testFormat(1000000, "1.00M");
  testFormat(1e33, "1.00Dc"); // Decillion
  testFormat(1e36, "1.00Ud"); // Undecillion
  testFormat(1e63, "1.00Vg"); // Vigintillion
  testFormat(1e93, "1.00Tg"); // Trigintillion (last one added)
  testFormat(1e96, "1.00e+96"); // Should fallback to scientific
}

void testFormat(double value, String expected) {
  String result = formatNumber(value);
  if (result == expected) {
    print("PASS: $value -> $result");
  } else {
    print("FAIL: $value -> $result (Expected: $expected)");
  }
}

String formatNumber(double value) {
  const suffixes = [
    "",
    "K",
    "M",
    "B",
    "T",
    "Qa",
    "Qi",
    "Sx",
    "Sp",
    "Oc",
    "No",
    "Dc",
    "Ud",
    "Dd",
    "Td",
    "Qad",
    "Qid",
    "Sxd",
    "Spd",
    "Ocd",
    "Nod",
    "Vg",
    "UVg",
    "DVg",
    "TVg",
    "QaVg",
    "QiVg",
    "SxVg",
    "SpVg",
    "OcVg",
    "NoVg",
    "Tg",
  ];
  int suffixIndex = 0;
  double v = value;

  while (v >= 999.995) {
    v /= 1000;
    suffixIndex++;
  }

  if (suffixIndex >= suffixes.length) {
    return value.toStringAsExponential(2);
  }

  return "${v.toStringAsFixed(2)}${suffixes[suffixIndex]}";
}
