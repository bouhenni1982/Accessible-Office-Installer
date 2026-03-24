import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class InstallerPaths {
  static Future<Directory> getBaseDirectory() async {
    if (Platform.isWindows) {
      final localAppData = Platform.environment['LOCALAPPDATA'];
      if (localAppData != null && localAppData.trim().isNotEmpty) {
        final directory = Directory(
          path.join(localAppData, 'AccessibleOfficeInstaller', 'OfficeDeploymentTool'),
        );
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory;
      }
    }

    final tempDir = await getTemporaryDirectory();
    final directory = Directory(
      path.join(tempDir.path, 'AccessibleOfficeInstaller', 'OfficeDeploymentTool'),
    );
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static Future<String> getConfigurationXmlPath() async {
    final baseDir = await getBaseDirectory();
    return path.join(baseDir.path, 'configuration.xml');
  }

  static Future<String> getSetupExePath() async {
    final baseDir = await getBaseDirectory();
    return path.join(baseDir.path, 'setup.exe');
  }

  static Future<String> getDownloadedInstallerPath() async {
    final baseDir = await getBaseDirectory();
    return path.join(baseDir.path, 'odt_installer.exe');
  }

  static Future<String> getDownloadedVersionPath() async {
    final baseDir = await getBaseDirectory();
    return path.join(baseDir.path, 'odt_version.txt');
  }
}
