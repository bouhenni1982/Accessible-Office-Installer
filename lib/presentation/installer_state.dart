import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../domain/models.dart';
import '../data/xml_generator.dart';
import '../data/odt_downloader.dart';
import '../data/command_runner.dart';
import '../data/installer_paths.dart';
import '../data/registry_checker.dart';
import '../l10n/app_localizations.dart';

class InstallerState extends ChangeNotifier {
  String _edition = 'O365ProPlusRetail';
  String _architecture = '64';
  String _language = 'en-us';
  String _channel = 'Current';
  bool _acceptEula = true;
  String _displayLevel = 'None';
  final Set<String> _excludeApps = {};
  Locale _appLocale = AppLocalizations.resolveDeviceLocale(
    WidgetsBinding.instance.platformDispatcher.locales,
  );

  bool _isInstalling = false;
  String _installStatus = '';
  String _logs = '';
  bool _lastOperationFailed = false;
  
  bool _isOfficeInstalled = false;

  InstallerState() {
    _installStatus = _tr('readyToInstall');
    _checkRegistry();
  }

  String get edition => _edition;
  String get architecture => _architecture;
  String get language => _language;
  String get channel => _channel;
  bool get acceptEula => _acceptEula;
  String get displayLevel => _displayLevel;
  Set<String> get excludeApps => _excludeApps;
  Locale get appLocale => _appLocale;

  bool get isInstalling => _isInstalling;
  String get installStatus => _installStatus;
  String get logs => _logs;
  bool get isOfficeInstalled => _isOfficeInstalled;
  bool get hasInstallationActivity => _logs.trim().isNotEmpty || _installStatus.trim().isNotEmpty;
  bool get lastOperationFailed => _lastOperationFailed;
  List<OfficeChannel> get availableChannelsForSelectedEdition {
    final allowedChannels = _supportedChannelsForEdition(_edition);
    return availableChannels.where((channel) => allowedChannels.contains(channel.id)).toList();
  }

  void updateEdition(String value) {
    _edition = value;
    _channel = _resolveChannelForEdition(edition: value, currentChannel: _channel);
    notifyListeners();
  }
  void updateArchitecture(String value) { _architecture = value; notifyListeners(); }
  void updateLanguage(String value) { _language = value; notifyListeners(); }
  void updateAppLocale(Locale value) {
    _appLocale = value;
    if (!_isInstalling && _logs.trim().isEmpty) {
      _installStatus = _tr('readyToInstall');
    }
    notifyListeners();
  }
  void updateChannel(String value) {
    final allowedChannels = _supportedChannelsForEdition(_edition);
    if (allowedChannels.contains(value)) {
      _channel = value;
      notifyListeners();
    }
  }
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

  String _tr(String key, {Map<String, String> params = const {}}) {
    return AppLocalizations(_appLocale).text(key, params: params);
  }

  List<String> _supportedChannelsForEdition(String edition) {
    for (final item in availableEditions) {
      if (item.id == edition) {
        return item.supportedChannels;
      }
    }

    return const ['Current', 'Broad', 'MonthlyEnterprise'];
  }

  String _resolveChannelForEdition({String? edition, String? currentChannel}) {
    final selectedEdition = edition ?? _edition;
    final selectedChannel = currentChannel ?? _channel;
    final allowedChannels = _supportedChannelsForEdition(selectedEdition);

    if (allowedChannels.contains(selectedChannel)) {
      return selectedChannel;
    }

    return allowedChannels.first;
  }

  Future<void> startInstallation() async {
    _isInstalling = true;
    _installStatus = _tr('preparingInstallation');
    _logs = '';
    _lastOperationFailed = false;
    notifyListeners();

    try {
      final effectiveChannel = _resolveChannelForEdition();
      if (effectiveChannel != _channel) {
        appendLog(
          _tr(
            'adjustedChannel',
            params: {
              'from': _channel,
              'to': effectiveChannel,
            },
          ),
        );
        _channel = effectiveChannel;
      }

      final config = OfficeConfig(
        edition: _edition,
        architecture: _architecture,
        language: _language,
        channel: effectiveChannel,
        acceptEula: _acceptEula,
        displayLevel: _displayLevel,
        excludeApps: _excludeApps.toList(),
      );

      final xmlContent = XmlGenerator.generate(config);
      appendLog(_tr('generatedConfiguration'));
      appendLog(xmlContent);

      final configurationPath = await InstallerPaths.getConfigurationXmlPath();
      appendLog('configuration.xml path: $configurationPath');

      _installStatus = _tr('downloadingOdt');
      notifyListeners();
      
      final setupPath = await OdtDownloader.downloadAndExtract(onProgress: appendLog);
      appendLog('setup.exe path: $setupPath');
      appendLog(_tr('odtExtracted', params: {'path': setupPath}));

      _installStatus = _tr('runningInstallation');
      notifyListeners();

      final exitCode = await CommandRunnerService.installOffice(setupPath, xmlContent, (logData) {
        appendLog(logData);
      });

      if (exitCode == 0) {
        _installStatus = _tr('installationCompleted');
      } else {
        _installStatus = _tr('installationFailed', params: {'code': '$exitCode'});
        _lastOperationFailed = true;
      }
    } catch (e) {
      _installStatus = _tr('installationError');
      _lastOperationFailed = true;
      appendLog(e.toString());
    } finally {
      _isInstalling = false;
      await _checkRegistry(); // Refresh status
      notifyListeners();
    }
  }
}
