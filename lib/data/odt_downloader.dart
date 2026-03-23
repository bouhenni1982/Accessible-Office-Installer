import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class OdtDownloader {
  // Official Microsoft URL for ODT
  static const String _odtDownloadUrl = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A5D4A77/officedeploymenttool_14326-20238.exe';

  static Future<String> downloadAndExtract({void Function(String)? onProgress}) async {
    final tempDir = await getTemporaryDirectory();
    final odtDir = Directory(path.join(tempDir.path, 'AccessibleOfficeInstaller', 'ODT'));
    
    if (!await odtDir.exists()) {
      await odtDir.create(recursive: true);
    }

    final setupExePath = path.join(odtDir.path, 'setup.exe');
    
    // If setup.exe already exists, we might not need to download it again, 
    // but for reliability let's ensure it's there.
    if (!await File(setupExePath).exists()) {
      final downloadPath = path.join(odtDir.path, 'odt_installer.exe');
      onProgress?.call('Downloading ODT from Microsoft...');
      
      // Download ODT
      final response = await http.get(Uri.parse(_odtDownloadUrl)).timeout(const Duration(minutes: 2));
      if (response.statusCode != 200) {
        throw Exception('Failed to download ODT: ${response.statusCode}');
      }
      
      final file = File(downloadPath);
      await file.writeAsBytes(response.bodyBytes);
      onProgress?.call('ODT package saved to: $downloadPath');

      // Extract ODT (ODT installer is a self-extracting executable)
      // Running it with /extract:path /quiet
      onProgress?.call('Extracting Office Deployment Tool...');
      final result = await Process.run(downloadPath, ['/extract:${odtDir.path}', '/quiet', '/norestart'], runInShell: true);
      
      if (result.exitCode != 0) {
        throw Exception('Failed to extract ODT: ${result.stderr}\n${result.stdout}');
      }
      
      // Cleanup the downloader
      if (await file.exists()) {
        await file.delete();
      }
    }

    if (!await File(setupExePath).exists()) {
      throw Exception('setup.exe was not found after extracting the Office Deployment Tool.');
    }

    return setupExePath;
  }
}
