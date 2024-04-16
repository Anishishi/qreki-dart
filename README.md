<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# qreki-dart

## Features

You can get these values.

- [六曜 (Rokuyo)](https://ja.wikipedia.org/wiki/%E5%85%AD%E6%9B%9C)
- [旧暦 (The old calendar)](https://ja.wikipedia.org/wiki/%E6%97%A7%E6%9A%A6)

## Usage

```dart
import 'package:qreki_dart/qreki_dart.dart';
import 'package:qreki_dart/src/helpers/to_ordinal.dart';

void main() {
  print(toOrdinal(DateTime(2017, 10, 17)));
  final k = Kyureki.fromYMD(2017, 10, 17);
  print(k.toString());
  // '2017年8月28日'
  print(k.rokuyouValue);
  // '大安'

  final date = DateTime(2017, 10, 21);
  final k2 = Kyureki.fromDate(date);
  print(k2.toString());
  // '2017年9月2日'
  print(k2.rokuyouValue);
  // '仏滅'
}
```

## Limitations

- Currently, JST is supported.

## Reference

This package is fully based on [qreki_py](https://github.com/fgshun/qreki_py/tree/master) 🎉.
Thank you!
