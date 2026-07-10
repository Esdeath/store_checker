import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_checker_plus/store_checker_plus.dart';

void main() {
  const MethodChannel channel = MethodChannel('store_checker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getSource', () async {
    expect(await StoreChecker.getSource, Source.UNKNOWN);
  });

  test('Darwin native module names match the Flutter package name', () {
    const packageName = 'store_checker_plus';

    for (final platform in ['ios', 'macos']) {
      final podspec =
          File('$platform/store_checker_plus.podspec').readAsStringSync();
      final packageSwift =
          File('$platform/store_checker_plus/Package.swift').readAsStringSync();

      expect(podspec, contains("s.name             = '$packageName'"));
      expect(packageSwift, contains('name: "$packageName"'));
      expect(packageSwift, contains('targets: ["$packageName"]'));
    }
  });
}
