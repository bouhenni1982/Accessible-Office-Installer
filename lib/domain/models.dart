class OfficeConfig {
  final String edition; // e.g., O365ProPlusRetail, ProPlus2021Volume
  final String architecture; // e.g., 64, 32
  final String language; // e.g., en-us, ar-sa, fr-fr
  final String channel; // e.g., Current, Broad
  final bool acceptEula;
  final bool autoActivate;
  final bool forceDowngrade;
  final String displayLevel; // e.g., None, Full
  final List<String> excludeApps; // e.g., Access, Bing, OneDrive

  OfficeConfig({
    required this.edition,
    required this.architecture,
    required this.language,
    required this.channel,
    this.acceptEula = true,
    this.autoActivate = true,
    this.forceDowngrade = false,
    this.displayLevel = 'None',
    this.excludeApps = const [],
  });
}

class OfficeApp {
  final String id;
  final String name;

  const OfficeApp(this.id, this.name);
}

const List<OfficeApp> availableApps = [
  OfficeApp('Access', 'Access'),
  OfficeApp('Excel', 'Excel'),
  OfficeApp('Groove', 'Groove (OneDrive for Business Legacy)'),
  OfficeApp('Lync', 'Lync / Skype for Business'),
  OfficeApp('OneDrive', 'OneDrive'),
  OfficeApp('OneNote', 'OneNote'),
  OfficeApp('Outlook', 'Outlook'),
  OfficeApp('PowerPoint', 'PowerPoint'),
  OfficeApp('Publisher', 'Publisher'),
  OfficeApp('Teams', 'Teams'),
  OfficeApp('Word', 'Word'),
  OfficeApp('Bing', 'Bing Search logic'),
];
