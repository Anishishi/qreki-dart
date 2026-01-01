import 'dart:io';

Future<void> main(List<String> args) async {
  final root = _findProjectRoot();
  final defaultOut =
      _join(root, ['test', 'testdata', 'qreki_golden_2020_2100.csv']);
  final outPath = args.isNotEmpty ? args[0] : defaultOut;

  final awkPath = _join(root, ['QRSAMP', 'QREKI.AWK']);

  final start = DateTime.utc(2020, 1, 1);
  final endExclusive = DateTime.utc(2101, 1, 1);
  final totalDays = endExclusive.difference(start).inDays;

  stdout.writeln('Out: $outPath');
  stdout.writeln('Total days: $totalDays');

  final outFile = File(outPath);
  outFile.parent.createSync(recursive: true);

  final sink = outFile.openWrite();
  var i = 0;
  for (var dt = start;
      dt.isBefore(endExclusive);
      dt = dt.add(const Duration(days: 1))) {
    final res = await Process.run('awk', [
      '-f',
      awkPath,
      dt.year.toString(),
      dt.month.toString(),
      dt.day.toString(),
    ]);

    if (res.exitCode != 0) {
      stderr.writeln('AWK failed for ${_fmt(dt)}');
      stderr.writeln(res.stderr);
      exitCode = 1;
      break;
    }

    final parsed = _parseAwkStdout(res.stdout.toString(), dt);
    sink.writeln(
        '${_fmt(dt)},${parsed.kYear},${parsed.kMonth},${parsed.kDay},${parsed.rokuyou}');

    i++;
    if (i % 365 == 0 || i == totalDays) {
      stdout.writeln(
          'Progress: $i/$totalDays (${(i * 100 / totalDays).toStringAsFixed(1)}%)');
    }
  }

  await sink.flush();
  await sink.close();

  stdout.writeln('Done.');
}

({int kYear, int kMonth, int kDay, String rokuyou}) _parseAwkStdout(
    String stdoutText, DateTime dt) {
  final values = stdoutText.split(',').map((e) => e.trim()).toList();
  if (values.length < 4) {
    throw FormatException(
        'Unexpected AWK output for ${_fmt(dt)}: "$stdoutText"');
  }

  final kYear = int.parse(values[0].replaceAll('年', ''));

  final valMonth = values[1].replaceAll('月', '').replaceAll('閏', '');
  final kMonth = switch (valMonth) { '正' => 1, _ => int.parse(valMonth) };

  final valDay = values[2].replaceAll('日', '');
  final kDay = switch (valDay) { '朔' => 1, _ => int.parse(valDay) };

  final rokuyou = values[3];

  return (kYear: kYear, kMonth: kMonth, kDay: kDay, rokuyou: rokuyou);
}

String _fmt(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _findProjectRoot() {
  final dir = Directory(File.fromUri(Platform.script).path).parent.parent;
  return dir.path;
}

String _join(String base, List<String> parts) {
  String p = base;
  for (final part in parts) {
    if (p.endsWith(Platform.pathSeparator)) {
      p = '$p$part';
    } else {
      p = '$p${Platform.pathSeparator}$part';
    }
  }
  return p;
}
