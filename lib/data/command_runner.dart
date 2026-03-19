import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CommandRunnerService {
  static Future<int> installOffice(String setupExePath, String configurationXmlContent, Function(String) onProgress) async {
    final tempDir = await getTemporaryDirectory();
    final odtDir = Directory(path.join(tempDir.path, 'AccessibleOfficeInstaller', 'ODT'));
    
    if (!await odtDir.exists()) {
      await odtDir.create(recursive: true);
    }

    final configPath = path.join(odtDir.path, 'configuration.xml');
    final configFile = File(configPath);
    await configFile.writeAsString(configurationXmlContent);

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
    return exitCode;
  }
}
