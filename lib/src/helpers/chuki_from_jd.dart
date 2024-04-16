import 'package:qreki_dart/src/helpers/longitude_of_sun.dart';

(double, double) chukiFromJD(double tm, double tz) {
  // Calculate the time of the solar term (中気) from Julian Day with local correction
  double tm2 = tm - tm.floor();
  double tm1 = tm.floor().toDouble();

  // Convert JST to UT assuming no correction time is needed
  tm2 -= tz;

  // Calculate the longitude of the sun at the given time and determine the nearest previous multiple of 30
  double t = (tm2 + 0.5) / 36525.0 + (tm1 - 2451545.0) / 36525.0;
  double rmSun = longitudeOfSun(t);
  double rmSun0 = rmSun - rmSun % 30.0;

  // Iteratively calculate the time of the solar term
  // Stop when the error is within ±1.0 second
  double deltaT1 = 0.0;
  double deltaT2 = 1.0;
  do {
    t = (tm2 + 0.5) / 36525.0 + (tm1 - 2451545.0) / 36525.0;
    rmSun = longitudeOfSun(t);

    // Difference in longitude Δλ = λsun - λsun0
    double deltaRm = rmSun - rmSun0;

    // Correct the range of Δλ to within ±180°
    if (deltaRm > 180.0) {
      deltaRm -= 360.0;
    } else if (deltaRm < -180.0) {
      deltaRm += 360.0;
    }

    // Calculate the time correction Δt
    double correction = deltaRm * 365.2 / 360.0;
    deltaT2 = correction.floor().toDouble();
    deltaT1 = correction - deltaT2;

    // Correct the time argument
    tm1 -= deltaT1;
    tm2 -= deltaT2;
    if (tm2 < 0.0) {
      tm2 += 1.0;
      tm1 -= 1.0;
    }
  } while ((deltaT1 + deltaT2).abs() > 1.0 / 86400.0);

  // Combine the time argument and convert UT back to JST for the return value
  return (tm1 + tm2 + tz, rmSun0);
}
