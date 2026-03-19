import 'package:flutter/material.dart';
import '../domain/models.dart';
import '../data/xml_generator.dart';
import '../data/odt_downloader.dart';
import '../data/command_runner.dart';
import '../data/registry_checker.dart';

class InstallerState extends ChangeNotifier {
  String _edition = 'O365ProPlusRetail';
  String _architecture = '64';
  String _language = 'en-us';
  String _channel = 'Current';
  bool _acceptEula = true;
  String _displayLevel = 'None';
  final Set<String> _excludeApps = {};

  bool _isInstalling = false;
  String _installStatus = 'Ready to install';
  String _logs = '';
  
  bool _isOfficeInstalled = false;

  InstallerState() {
    _checkRegistry();
  }

  String get edition => _edition;
  String get architecture => _architecture;
  String get language => _language;
  String get channel => _channel;
  bool get acceptEula => _acceptEula;
  String get displayLevel => _displayLevel;
  Set<String> get excludeApps => _excludeApps;

  bool get isInstalling => _isInstalling;
  String get installStatus => _installStatus;
  String get logs => _logs;
  bool get isOfficeInstalled => _isOfficeInstalled;

  void updateEdition(String value) { _edition = value; notifyListeners(); }
  void updateArchitecture(String value) { _architecture = value; notifyListeners(); }
  void updateLanguage(String value) { _language = value; notifyListeners(); }
  void updateChannel(String value) { _channel = value; notifyListeners(); }
  void updateAcceptEula(bool value) { _acceptEula = value; notifyListeners(); }
  void updateDisplayLevel(String value) { _displayLevel = value; notifyListeners(); }
  
  void toggleAppExclusion(String appId) {
    if (_excludeApps.contains(appId)) {
      _excludeApps.remove(appId);
    } else {
      _excludeApps.add(appId);
    }
    notifyListeners();
  }

  Future<void> _checkRegistry() async {
    _isOfficeInstalled = await RegistryChecker.isOfficeInstalled();
    notifyListeners();
  }

  void appendLog(String message) {
    _logs += '$message\n';
    notifyListeners();
  }

  Future<void> startInstallation() async {
    _isInstalling = true;
    _installStatus = 'Preparing installation...';
    _logs = '';
    notifyListeners();

    try {
      final config = OfficeConfig(
        edition: _edition,
        architecture: _architecture,
        language: _language,
        channel: _channel,
        acceptEula: _acceptEula,
        displayLevel: _displayLevel,
        excludeApps: _excludeApps.toList(),
      );

      final xmlContent = XmlGenerator.generate(config);
      appendLog('Generated configuration.xml');
      appendLog(xmlContent);

      _installStatus = 'Downloading Office Deployment Tool...';
      notifyListeners();
      
      final setupPath = await OdtDownloader.downloadAndExtract();
      appendLog('ODT extracted to: $setupPath');

      _installStatus = 'Running installation...';
      notifyListeners();

      final exitCode = await CommandRunnerService.installOffice(setupPath, xmlContent, (logData) {
        appendLog(logData);
      });

      if (exitCode == 0) {
        _installStatus = 'Installation completed successfully.';
      } else {
        _installStatus = 'Installation failed with exit code $exitCode.';
      }
    } catch (e) {
      _installStatus = 'Error occurred during installation.';
      appendLog(e.toString());
    } finally {
      _isInstalling = false;
      await _checkRegistry(); // Refresh status
      notifyListeners();
    }
  }
}
