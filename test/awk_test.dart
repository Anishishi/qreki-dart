import 'dart:io';

import 'package:qreki_dart/qreki_dart.dart';
import 'package:test/test.dart';

void main() {
  test('Kyureki matches golden (2020-2100 full)', () {
    final golden = _loadGolden();
    final dates = golden.keys.toList()..sort();

    for (final date in dates) {
      final g = golden[date]!;
      final dt = _dt(date);

      final a = Kyureki.fromDate(dt);
      final b = Kyureki.fromYMD(dt.year, dt.month, dt.day);

      _expect(date, a, g);
      _expect(date, b, g);
    }
  });
}

Map<String, List<dynamic>> _loadGolden() {
  final file = File('test/testdata/qreki_golden_2020_2100.csv');
  if (!file.existsSync()) {
    throw StateError('golden csv not found');
  }

  final map = <String, List<dynamic>>{};
  for (final line in file.readAsLinesSync()) {
    if (line.isEmpty || line.startsWith('#')) continue;

    final c = line.split(',');
    if (c.length != 5) continue;

    map[c[0]] = [
      int.parse(c[1]),
      int.parse(c[2]),
      int.parse(c[3]),
      c[4],
    ];
  }
  return map;
}

DateTime _dt(String s) {
  final p = s.split('-');
  return DateTime.utc(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
}

void _expect(String date, Kyureki k, List<dynamic> g) {
  expect(k.year, g[0], reason: date);
  expect(k.month, g[1], reason: date);
  expect(k.day, g[2], reason: date);
  expect(k.rokuyouValue, g[3], reason: date);
}
