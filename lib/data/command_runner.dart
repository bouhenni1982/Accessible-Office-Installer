import 'dart:convert';
import 'dart:io';

import 'installer_paths.dart';

class CommandRunnerService {
  static Future<int> installOffice(String setupExePath, String configurationXmlContent, Function(String) onProgress) async {
    final odtDir = await InstallerPaths.getBaseDirectory();
    final configPath = await InstallerPaths.getConfigurationXmlPath();
    final configFile = File(configPath);
    await configFile.writeAsString(configurationXmlContent);
    if (!await File(setupExePath).exists()) {
      throw Exception('setup.exe not found at: $setupExePath');
    }

    onProgress('Working directory: ${odtDir.path}');
    onProgress('Using setup.exe: $setupExePath');
    onProgress('Using configuration: $configPath');

    onProgress('Running setup.exe /configure...');
    
    final process = await Process.start(
      setupExePath,
      ['/configure', configPath],
      runInShell: true,
      workingDirectory: odtDir.path,
    );

    process.stdout.transform(utf8.decoder).listen((data) {
      onProgress(data);
    });

    process.stderr.transform(utf8.decoder).listen((data) {
      onProgress('ERROR: $data');
    });

    final exitCode = await process.exitCode;
    onProgress('setup.exe finished with exit code $exitCode');
    return exitCode;
  }
}
