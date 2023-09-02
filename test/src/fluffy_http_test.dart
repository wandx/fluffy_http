// ignore_for_file: prefer_const_constructors

import 'package:fluffy_http/fluffy_http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FluffyHttp', () {
    test('can be instantiated', () {
      expect(FluffyHttp.instance, isNotNull);
    });
  });
}
