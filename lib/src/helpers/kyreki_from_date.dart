import 'package:qreki_dart/src/helpers/before_nibun_from_jd.dart';
import 'package:qreki_dart/src/helpers/to_ordinal.dart';
import 'package:qreki_dart/src/helpers/chuki_from_jd.dart';
import 'package:qreki_dart/src/helpers/saku_from_jd.dart';

List<int> kyurekiFromDate(DateTime date, double tz) {
  // Calculate the Julian Day with local correction
  final int tm0 = toOrdinal(date) +
      1721424; // This method needs to be implemented to convert DateTime to Julian Day
  final double tm = tm0.toDouble();

  // Calculate the time of the last solstice before the given time
  List<(double, double)> chu = [beforeNibunFromJD(tm, tz)];

  // Calculate the times of the following solar terms
  for (int i = 1; i < 4; i++) {
    chu.add(chukiFromJD(chu[i - 1].$1 + 32.0, tz));
  }

  // Calculate the time of the new moon before the last solstice
  List<double> saku = [sakuFromJD(chu[0].$1, tz)];

  // Calculate subsequent new moon times
  for (int i = 1; i < 5; i++) {
    saku.add(sakuFromJD(saku[i - 1] + 30.0, tz));
    if ((saku[i - 1] - saku[i]).abs() <= 26) {
      saku[i] = sakuFromJD(saku[i - 1] + 35.0, tz);
    }
  }

  // Adjust saku times if needed
  if (saku[1] <= chu[0].$1) {
    for (int i = 0; i < 4; i++) {
      saku[i] = saku[i + 1];
    }
    saku[4] = sakuFromJD(saku[3] + 35.0, tz);
  } else if (saku[0] > chu[0].$1) {
    for (int i = 4; i > 0; i--) {
      saku[i] = saku[i - 1];
    }
    saku[0] = sakuFromJD(saku[0] - 27.0, tz);
  }

  // Search for leap months
  bool leap = saku[4] <= chu[3].$1;

  // Create lunar month array
  List<List<int>> m = List.generate(5, (_) => List.filled(3, 0));
  m[0][0] = (chu[0].$2 / 30.0).floor() + 2;
  m[0][2] = saku[0].floor();

  for (int i = 1; i < 5; i++) {
    if (leap && i != 1) {
      if (chu[i - 1].$1 <= saku[i - 1] || chu[i - 1].$1 >= saku[i]) {
        m[i - 1][0] = m[i - 2][0];
        m[i - 1][1] = 1;
        m[i - 1][2] = saku[i - 1].floor();
        leap = false;
      }
    }
    m[i][0] = m[i - 1][0] + 1;
    if (m[i][0] > 12) {
      m[i][0] -= 12;
    }
    m[i][2] = saku[i].floor();
  }

  // Determine the current lunar date
  int state = 0, i;
  for (i = 0; i < 5; i++) {
    if (tm0 < m[i][2]) {
      state = 1;
      break;
    } else if (tm0 == m[i][2]) {
      state = 2;
      break;
    }
  }

  if (state == 0 || state == 1) {
    i--;
  }

  int kyurekiYear = date.year;
  int kyurekiMonth = m[i][0];
  int kyurekiLeap = m[i][1];
  int kyurekiDay = tm0 - m[i][2] + 1;

  // Adjust the lunar year if necessary
  if (kyurekiMonth > 9 && kyurekiMonth > date.month) {
    kyurekiYear--;
  }

  return [kyurekiYear, kyurekiMonth, kyurekiLeap, kyurekiDay];
}
