import 'package:qreki_dart/src/helpers/kyreki_from_date.dart';
import 'package:qreki_dart/src/constants/constants.dart';

/// Represents a Kyureki (traditional Japanese lunisolar calendar) date.
class Kyureki {
  /// Ordered labels for rokuyou (six-day fortune cycle).
  static const List<String> rokuyou = ['大安', '赤口', '先勝', '友引', '先負', '仏滅'];

  /// Kyureki year.
  final int year;

  /// Kyureki month (1-12).
  final int month;

  /// Leap month flag (0 for normal month, 1 for leap month).
  final int leapMonth;

  /// Day within the Kyureki month.
  final int day;

  Kyureki._(this.year, this.month, this.leapMonth, this.day);

  /// Builds a Kyureki from a Gregorian Y/M/D.
  factory Kyureki.fromYMD(
    int year,
    int month,
    int day, {
    double timeZone = kTz,
  }) {
    final date = DateTime(year, month, day);
    return Kyureki.fromDate(date, timeZone: timeZone);
  }

  /// Builds a Kyureki from a Gregorian [DateTime].
  factory Kyureki.fromDate(DateTime date, {double timeZone = kTz}) {
    List<int> kyureki = kyurekiFromDate(date, timeZone);
    return Kyureki._(kyureki[0], kyureki[1], kyureki[2], kyureki[3]);
  }

  /// Returns the rokuyou label for this Kyureki date.
  String get rokuyouValue => rokuyou[(month + day) % 6];

  /// Formats the Kyureki as a readable Japanese date string.
  @override
  String toString() => '$year年${leapMonth > 0 ? '閏' : ''}$month月$day日';

  /// Compares Kyureki values by year, month, leap month, and day.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Kyureki &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          leapMonth == other.leapMonth &&
          day == other.day;

  /// Hash code based on year, month, leap month, and day.
  @override
  int get hashCode =>
      year.hashCode ^ month.hashCode ^ leapMonth.hashCode ^ day.hashCode;

  /// Returns true when this date is strictly before [other].
  bool operator <(Kyureki other) =>
      year < other.year ||
      (year == other.year &&
          (month < other.month ||
              (month == other.month &&
                  (leapMonth < other.leapMonth ||
                      (leapMonth == other.leapMonth && day < other.day)))));

  /// Returns true when this date is before or equal to [other].
  bool operator <=(Kyureki other) => this < other || this == other;

  /// Returns true when this date is strictly after [other].
  bool operator >(Kyureki other) => other < this;

  /// Returns true when this date is after or equal to [other].
  bool operator >=(Kyureki other) => other <= this;
}

/// Returns the rokuyou label from a Gregorian Y/M/D.
String rokuyouFromYmd(int year, int month, int day) {
  Kyureki kyureki = Kyureki.fromYMD(year, month, day);
  return kyureki.rokuyouValue;
}

/// Returns the rokuyou label from a Gregorian [DateTime].
String rokuyouFromDate(DateTime date) {
  Kyureki kyureki = Kyureki.fromDate(date);
  return kyureki.rokuyouValue;
}
