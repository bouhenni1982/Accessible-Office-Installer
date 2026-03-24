import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'installer_paths.dart';

class OdtDownloader {
  static const String _downloadCenterDetailsUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=49117';
  static const String _fallbackOdtDownloadUrl = 'https://download.microsoft.com/download/6c1eeb25-cf8b-41d9-8d0d-cc1dbc032140/officedeploymenttool_19725-20126.exe';
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
      final downloadFile = File(downloadPath);

      onProgress?.call('ODT working directory: ${odtDir.path}');
      onProgress?.call('Downloading ODT from Microsoft...');
      onProgress?.call('Resolved Microsoft ODT package: $resolvedFileName');
      onProgress?.call('Official download URL: $latestDownloadUrl');

      await _downloadInstaller(
        url: latestDownloadUrl,
        targetFile: downloadFile,
        onProgress: onProgress,
      );
      onProgress?.call('ODT package saved to: $downloadPath');

      onProgress?.call('Extracting Office Deployment Tool...');
      final result = await Process.run(downloadPath, ['/extract:${odtDir.path}', '/quiet', '/norestart'], runInShell: true);

      if (result.exitCode != 0) {
        throw Exception('Failed to extract ODT: ${result.stderr}\n${result.stdout}');
      }

      await versionFile.writeAsString(resolvedFileName);

      if (await downloadFile.exists()) {
        await downloadFile.delete();
      }
    }

    if (!await File(setupExePath).exists()) {
      throw Exception('setup.exe was not found after extracting the Office Deployment Tool.');
    }

    return setupExePath;
  }

  static Future<String> _resolveLatestDownloadUrl({void Function(String)? onProgress}) async {
    final candidatePages = [_downloadCenterDetailsUrl];

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
          onProgress?.call('Resolved direct Microsoft download URL from details page.');
          return match.group(0)!;
        }

        onProgress?.call('No direct ODT link found in Microsoft details page HTML.');
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

  static Future<void> _downloadInstaller({
    required String url,
    required File targetFile,
    void Function(String)? onProgress,
  }) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(minutes: 5));
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      await targetFile.writeAsBytes(response.bodyBytes);
      return;
    } catch (error) {
      onProgress?.call('HTTP download failed, trying PowerShell fallback: $error');
    }

    if (!Platform.isWindows) {
      throw Exception('Failed to download ODT with HTTP and no Windows fallback is available.');
    }

    final escapedUrl = url.replaceAll("'", "''");
    final escapedPath = targetFile.path.replaceAll("'", "''");
    final powershellScript = "\$ProgressPreference = 'SilentlyContinue'; "
        "Invoke-WebRequest -Uri '$escapedUrl' -OutFile '$escapedPath' -UseBasicParsing";

    final result = await Process.run(
      'powershell',
      ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', powershellScript],
      runInShell: true,
    );

    if (result.exitCode != 0 || !await targetFile.exists()) {
      throw Exception(
        'Failed to download ODT with PowerShell fallback: ${result.stderr}\n${result.stdout}',
      );
    }
  }
}
