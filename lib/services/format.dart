String fmtMad(double v) => '${v.toStringAsFixed(2)} MAD';

String fmtQty(double v) {
  if (v >= 100) return v.toStringAsFixed(2);
  return v
      .toStringAsFixed(4)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

String fmtDate(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
}

double? parseNum(String s) => double.tryParse(s.trim().replaceAll(',', '.'));
