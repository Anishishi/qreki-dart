import 'dart:io';

import 'package:qreki_dart/qreki_dart.dart';
import 'package:test/test.dart';

void main() {
  group("test_to_match_qreki.awk_and_qreki_dart", () {
    // check from 2020-01-01 to 2100-12-31
    final dateTimes = <DateTime>[];
    for (DateTime dt = DateTime(2020, 1, 1);
        dt.isBefore(DateTime(2101, 1, 1));
        dt = dt.add(const Duration(days: 1))) {
      dateTimes.add(dt);
    }

    print("Total test count: ${dateTimes.length}");

    for (final dt in dateTimes) {
      test("test for $dt", () async {
        final kFromDateDart = Kyureki.fromDate(dt);
        final kFromYMDDart = Kyureki.fromYMD(dt.year, dt.month, dt.day);

        final resAwk = await Process.run("awk", [
          "-f",
          "./QRSAMP/QREKI.AWK",
          dt.year.toString(),
          dt.month.toString(),
          dt.day.toString()
        ]);
        final values =
            resAwk.stdout.toString().split(",").map((e) => e.trim()).toList();
        final kYear = int.parse(values[0].replaceAll("年", ""));
        final valMonth = values[1].replaceAll("月", "").replaceAll("閏", "");
        final kMonth = switch (valMonth) {
          "正" => 1,
          _ => int.parse(valMonth),
        };
        final valDay = values[2].replaceAll("日", "");
        final kDate = switch (valDay) {
          "朔" => 1,
          _ => int.parse(valDay),
        };
        final roku = values[3];

        expect(kFromDateDart.year, kYear);
        expect(kFromDateDart.month, kMonth);
        expect(kFromDateDart.day, kDate);
        expect(kFromDateDart.rokuyouValue, roku);

        expect(kFromYMDDart.year, kYear);
        expect(kFromYMDDart.month, kMonth);
        expect(kFromYMDDart.day, kDate);
        expect(kFromYMDDart.rokuyouValue, roku);
      });
    }
  });
}
