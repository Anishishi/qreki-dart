# qreki-dart

![Pub Version](https://img.shields.io/pub/v/qreki_dart?color=blue)
![GitHub](https://img.shields.io/github/license/Anishishi/qreki-dart)
![pub points](https://img.shields.io/pub/points/qreki_dart?logo=dart)
![GitHub last commit](https://img.shields.io/github/last-commit/Anishishi/qreki-dart?color=purple)

A Dart package for accessing Rokuyo and the old Japanese calendar, '旧暦', enabling easy integration of traditional timekeeping into contemporary apps.

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

  // 閏月
  final k3 = Kyureki.fromYMD(2020, 6, 14);
  // '2020年4月23日'
  print(k3.toString());
  // '友引'
  print(k3.rokuyouValue);
}
```

## Limitations

- Currently, JST is supported.

## Reference

This program is a dart port of Hideaki Takano's QREKI.AWK.

The original qreki.awk and qreki.doc, which formed the basis for this program, are included in the src/qrsamp11 directory. Additionally, this project greatly benefited from the Python port by Shunsuke Ito, known as qreki_py 🎉. Thank you!

For more information on qreki.awk, please visit

- QRSAMP

  - [sources](https://www.vector.co.jp/soft/dos/personal/se016093.html)
  - original files: ./QRSAMP

- [qreki_py](https://github.com/fgshun/qreki_py/tree/master)
