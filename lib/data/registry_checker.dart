import 'dart:io';

class RegistryChecker {
  static Future<bool> isOfficeInstalled() async {
    if (!Platform.isWindows) return false;

    // Check common Office registry keys
    const keys = [
      r'HKLM\SOFTWARE\Microsoft\Office\ClickToRun',
      r'HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun',
      r'HKLM\SOFTWARE\Microsoft\Office\16.0\Common\InstallRoot',
      r'HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\16.0\Common\InstallRoot',
    ];

    for (final key in keys) {
      try {
        final result = await Process.run('reg', ['query', key], runInShell: true);
        if (result.exitCode == 0) {
          return true;
        }
      } catch (e) {
        // Ignore error and continue to next key
      }
    }

    return false;
  }
}
