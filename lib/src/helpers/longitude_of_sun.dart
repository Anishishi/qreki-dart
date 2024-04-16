import 'dart:math' as math;

import 'package:qreki_dart/src/constants/constants.dart';

double longitudeOfSun(double t) {
  // Calculates the longitude of the sun

  // Calculation of perturbation terms
  double th = 0.0;
  double ang;
  for (var entry in [
    [31557.0, 161.0, 0.0004],
    [29930.0, 48.0, 0.0004],
    [2281.0, 221.0, 0.0005],
    [155.0, 118.0, 0.0005],
    [33718.0, 316.0, 0.0006],
    [9038.0, 64.0, 0.0007],
    [3035.0, 110.0, 0.0007],
    [65929.0, 45.0, 0.0007],
    [22519.0, 352.0, 0.0013],
    [45038.0, 254.0, 0.0015],
    [445267.0, 208.0, 0.0018],
    [19.0, 159.0, 0.0018],
    [32964.0, 158.0, 0.0020],
    [71998.1, 265.1, 0.0200],
  ]) {
    ang = (entry[0] * t + entry[1]) % 360.0;
    th += entry[2] * math.cos(kDegToRad * ang);
  }

  // Additional perturbation term with time dependency
  ang = (35999.05 * t + 267.52) % 360.0;
  th -= 0.0048 * t * math.cos(kDegToRad * ang);
  th += 1.9147 * math.cos(kDegToRad * ang);

  // Calculation of proportional term
  ang = (36000.7695 * t) % 360.0;
  ang = (ang + 280.4659) % 360.0;
  th = (th + ang) % 360.0;

  return th;
}
