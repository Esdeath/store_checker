import 'dart:io';

void main() {
  const packageName = 'store_checker_plus';
  final failures = <String>[];

  for (final platform in ['ios', 'macos']) {
    final podspecPath = '$platform/store_checker_plus.podspec';
    final packageSwiftPath = '$platform/store_checker_plus/Package.swift';
    final podspec = File(podspecPath).readAsStringSync();
    final packageSwift = File(packageSwiftPath).readAsStringSync();

    if (!podspec.contains("s.name             = '$packageName'")) {
      failures.add('$podspecPath must declare s.name as $packageName');
    }
    if (!packageSwift.contains('name: "$packageName"')) {
      failures.add('$packageSwiftPath must declare package/target $packageName');
    }
    if (!packageSwift.contains('targets: ["$packageName"]')) {
      failures.add('$packageSwiftPath product must target $packageName');
    }
  }

  if (failures.isNotEmpty) {
    stderr.writeln(failures.join('\n'));
    exitCode = 1;
  }
}
