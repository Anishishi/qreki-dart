import 'package:qreki_dart/src/helpers/longitude_of_moon.dart';
import 'package:qreki_dart/src/helpers/longitude_of_sun.dart';

double sakuFromJD(double tm, double tz) {
  // Calculate the time of the nearest new moon in Julian Days with local correction
  double tm2 = tm - tm.floor().toDouble();
  double tm1 = tm.floor().toDouble();

  // JST ==> UT (assuming correction time = 0.0 seconds)
  tm2 -= tz;

  // Iteratively compute the time of the new moon
  // (stop when the error is within ±1.0 second)
  double deltaT1 = 0.0;
  double deltaT2 = 1.0;
  for (int lc = 1; lc < 30; lc++) {
    // Calculate the longitude of the sun and the moon
    double t = (tm2 + 0.5) / 36525.0 + (tm1 - 2451545.0) / 36525.0;
    double rmSun = longitudeOfSun(t);
    double rmMoon = longitudeOfMoon(t);

    // Difference in longitude between the moon and the sun Δλ = λmoon - λsun
    double deltaRm = rmMoon - rmSun;

    if (lc == 1 && deltaRm < 0.0) {
      // Adjust the range to bring deltaRm into [0, 360) if it starts negative
      deltaRm = deltaRm % 360.0;
    } else if (rmSun >= 0.0 && rmSun <= 20.0 && rmMoon >= 300.0) {
      // Near the vernal equinox, if the moon's longitude is >= 300
      deltaRm = deltaRm % 360.0;
      deltaRm = 360.0 - deltaRm;
    } else if (deltaRm.abs() > 40.0) {
      // Adjust the range of Δλ to within ±40°
      deltaRm = deltaRm % 360.0;
    }

    // Time argument correction Δt
    double correction = deltaRm * 29.530589 / 360.0;
    deltaT2 = correction.floor().toDouble();
    deltaT1 = correction - deltaT2;

    // Adjust the time argument
    tm1 -= deltaT1;
    tm2 -= deltaT2;
    if (tm2 < 0.0) {
      tm2 += 1.0;
      tm1 -= 1.0;
    }

    if ((deltaT1 + deltaT2).abs() > 1.0 / 86400.0) {
      if (lc == 15) {
        // If the loop reaches 15 iterations, reset the initial tm to tm-26
        tm1 = tm - 26.0;
        tm2 = 0.0;
      }
    } else {
      // Calculation of the new moon time is complete
      break;
    }
  }

  // Reassemble the time argument and convert UT to JST for the return value
  return tm1 + tm2 + tz;
}
