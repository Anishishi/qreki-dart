import 'package:qreki_dart/qreki_dart.dart';
import 'package:qreki_dart/src/helpers/to_ordinal.dart';

void main() {
  print(toOrdinal(DateTime(2017, 10, 17)));
  final k = Kyureki.fromYMD(2017, 10, 17);
  print(k.toString());
  print(k.rokuyouValue);

  final date = DateTime(2017, 10, 21);
  final k2 = Kyureki.fromDate(date);
  print(k2.toString());
  print(k2.rokuyouValue);
}
