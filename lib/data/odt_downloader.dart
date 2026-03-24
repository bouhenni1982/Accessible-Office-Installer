import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'installer_paths.dart';

class OdtDownloader {
  static const String _downloadCenterDetailsUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=49117';
  static const String _downloadCenterConfirmationUrl = 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=49117';
  static const String _fallbackOdtDownloadUrl = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A5D4A77/officedeploymenttool_14326-20238.exe';
  static final RegExp _officialDownloadUrlPattern = RegExp(
    r'''https://download\.microsoft\.com/[^\s"'<>]+/officedeploymenttool_[^"'<>]+\.exe''',
    caseSensitive: false,
  );

  static Future<String> downloadAndExtract({void Function(String)? onProgress}) async {
    final odtDir = await InstallerPaths.getBaseDirectory();
    final setupExePath = await InstallerPaths.getSetupExePath();
    final latestDownloadUrl = await _resolveLatestDownloadUrl(onProgress: onProgress);
    final resolvedFileName = path.basename(Uri.parse(latestDownloadUrl).path);
    final versionFile = File(await InstallerPaths.getDownloadedVersionPath());

    if (await _isCachedSetupCurrent(
      setupExePath: setupExePath,
      versionFile: versionFile,
      resolvedFileName: resolvedFileName,
    )) {
      onProgress?.call('Reusing cached ODT setup for package: $resolvedFileName');
    } else {
      final downloadPath = await InstallerPaths.getDownloadedInstallerPath();

      onProgress?.call('ODT working directory: ${odtDir.path}');
      onProgress?.call('Downloading ODT from Microsoft...');
      onProgress?.call('Resolved Microsoft ODT package: $resolvedFileName');
      onProgress?.call('Official download URL: $latestDownloadUrl');

      final response = await http.get(Uri.parse(latestDownloadUrl)).timeout(const Duration(minutes: 5));
      if (response.statusCode != 200) {
        throw Exception('Failed to download ODT: ${response.statusCode}');
      }

      final file = File(downloadPath);
      await file.writeAsBytes(response.bodyBytes);
      onProgress?.call('ODT package saved to: $downloadPath');

      onProgress?.call('Extracting Office Deployment Tool...');
      final result = await Process.run(downloadPath, ['/extract:${odtDir.path}', '/quiet', '/norestart'], runInShell: true);

      if (result.exitCode != 0) {
        throw Exception('Failed to extract ODT: ${result.stderr}\n${result.stdout}');
      }

      await versionFile.writeAsString(resolvedFileName);

      if (await file.exists()) {
        await file.delete();
      }
    }

    if (!await File(setupExePath).exists()) {
      throw Exception('setup.exe was not found after extracting the Office Deployment Tool.');
    }

    return setupExePath;
  }

  static Future<String> _resolveLatestDownloadUrl({void Function(String)? onProgress}) async {
    final candidatePages = [
      _downloadCenterConfirmationUrl,
      _downloadCenterDetailsUrl,
    ];

    for (final candidatePage in candidatePages) {
      try {
        onProgress?.call('Checking Microsoft Download Center: $candidatePage');
        final response = await http.get(Uri.parse(candidatePage)).timeout(const Duration(minutes: 1));
        if (response.statusCode != 200) {
          onProgress?.call('Microsoft page returned status ${response.statusCode}: $candidatePage');
          continue;
        }

        final match = _officialDownloadUrlPattern.firstMatch(response.body);
        if (match != null) {
          return match.group(0)!;
        }
      } catch (error) {
        onProgress?.call('Could not inspect Microsoft page $candidatePage: $error');
      }
    }

    onProgress?.call('Falling back to bundled ODT URL: $_fallbackOdtDownloadUrl');
    return _fallbackOdtDownloadUrl;
  }

  static Future<bool> _isCachedSetupCurrent({
    required String setupExePath,
    required File versionFile,
    required String resolvedFileName,
  }) async {
    final setupExists = await File(setupExePath).exists();
    final versionExists = await versionFile.exists();
    if (!setupExists || !versionExists) {
      return false;
    }

    final cachedVersion = (await versionFile.readAsString()).trim();
    return cachedVersion == resolvedFileName;
  }
}
