import 'package:qreki_dart/src/helpers/kyreki_from_date.dart';
import 'package:qreki_dart/src/constants/constants.dart';

class Kyureki {
  static const List<String> rokuyou = ['大安', '赤口', '先勝', '友引', '先負', '仏滅'];
  final int year;
  final int month;
  final int leapMonth;
  final int day;

  Kyureki._(this.year, this.month, this.leapMonth, this.day);

  factory Kyureki.fromYMD(
    int year,
    int month,
    int day, {
    double timeZone = kTz,
  }) {
    final date = DateTime(year, month, day);
    return Kyureki.fromDate(date, timeZone: timeZone);
  }

  factory Kyureki.fromDate(DateTime date, {double timeZone = kTz}) {
    List<int> kyureki = kyurekiFromDate(date, timeZone);
    return Kyureki._(kyureki[0], kyureki[1], kyureki[2], kyureki[3]);
  }

  String get rokuyouValue => rokuyou[(month + day) % 6];

  @override
  String toString() => '$year年${leapMonth > 0 ? '閏' : ''}$month月$day日';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Kyureki &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          leapMonth == other.leapMonth &&
          day == other.day;

  @override
  int get hashCode =>
      year.hashCode ^ month.hashCode ^ leapMonth.hashCode ^ day.hashCode;

  bool operator <(Kyureki other) =>
      year < other.year ||
      (year == other.year &&
          (month < other.month ||
              (month == other.month &&
                  (leapMonth < other.leapMonth ||
                      (leapMonth == other.leapMonth && day < other.day)))));

  bool operator <=(Kyureki other) => this < other || this == other;

  bool operator >(Kyureki other) => other < this;

  bool operator >=(Kyureki other) => other <= this;
}

// Function to get Rokuyou from year, month, day
String rokuyouFromYmd(int year, int month, int day) {
  Kyureki kyureki = Kyureki.fromYMD(year, month, day);
  return kyureki.rokuyouValue;
}

// Function to get Rokuyou from a DateTime object
String rokuyouFromDate(DateTime date) {
  Kyureki kyureki = Kyureki.fromDate(date);
  return kyureki.rokuyouValue;
}
