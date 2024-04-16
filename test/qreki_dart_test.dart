import 'package:qreki_dart/qreki_dart.dart';
import 'package:test/test.dart';

void main() {
  test("test_from_ymd", () {
    final k = Kyureki.fromYMD(2017, 10, 15);
    expect(k.year, 2017);
    expect(k.month, 8);
    expect(k.leapMonth, 0);
    expect(k.day, 26);
  });

  test("test_from_date", () {
    final date = DateTime(2017, 10, 15);
    final k = Kyureki.fromDate(date);
    expect(k.year, 2017);
    expect(k.month, 8);
    expect(k.leapMonth, 0);
    expect(k.day, 26);
  });

  test("test_rokuyou", () {
    expect(Kyureki.rokuyou, ['大安', '赤口', '先勝', '友引', '先負', '仏滅']);

    final k = Kyureki.fromYMD(2017, 10, 15);
    expect(k.rokuyouValue, '先負');
  });

  test("test_to_string", () {
    final k = Kyureki.fromYMD(2017, 10, 15);
    expect(k.toString(), '2017年8月26日');
  });

  test("test_compare", () {
    final o = Kyureki.fromYMD(2017, 10, 15);
    final ob = Kyureki.fromYMD(2017, 10, 16);
    final os = Kyureki.fromYMD(2017, 10, 14);
    final oe = Kyureki.fromYMD(2017, 10, 15);

    expect(o < ob, true);
    expect(o <= ob, true);
    expect(o == ob, false);
    expect(o != ob, true);
    expect(o > ob, false);
    expect(o >= ob, false);

    expect(o < os, false);
    expect(o <= os, false);
    expect(o == os, false);
    expect(o != os, true);
    expect(o > os, true);
    expect(o >= os, true);

    expect(o < oe, false);
    expect(o <= oe, true);
    expect(o == oe, true);
    expect(o != oe, false);
    expect(o > oe, false);
    expect(o >= oe, true);
  });

  test("test_hash_code", () {
    final o = Kyureki.fromYMD(2017, 10, 15);
    final ob = Kyureki.fromYMD(2017, 10, 16);
    final oe = Kyureki.fromYMD(2017, 10, 15);

    expect(o.hashCode != ob.hashCode, true);
    expect(o.hashCode == oe.hashCode, true);

    Map<Kyureki, int> d = {};
    d[o] = 1;
    d[ob] = 2;
    d[oe] = 3;
    expect(d.length, 2);
    expect(d[ob], 2);
    expect(d[oe], 3);
  });

  test("test_module_func", () {
    expect(rokuyouFromYmd(2017, 10, 15), "先負");
    expect(rokuyouFromDate(DateTime(2017, 10, 15)), "先負");
  });
}
