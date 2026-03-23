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

class OfficeEdition {
  final String id;
  final String name;
  final List<String> supportedChannels;

  const OfficeEdition(this.id, this.name, this.supportedChannels);
}

class OfficeChannel {
  final String id;
  final String name;

  const OfficeChannel(this.id, this.name);
}

class OfficeApp {
  final String id;
  final String name;

  const OfficeApp(this.id, this.name);
}

const List<OfficeChannel> availableChannels = [
  OfficeChannel('Current', 'Current Channel'),
  OfficeChannel('Broad', 'Semi-Annual Enterprise Channel'),
  OfficeChannel('MonthlyEnterprise', 'Monthly Enterprise Channel'),
  OfficeChannel('PerpetualVL2021', 'Office LTSC 2021 Perpetual Enterprise'),
  OfficeChannel('PerpetualVL2024', 'Office LTSC 2024 Perpetual Enterprise'),
];

const List<OfficeEdition> availableEditions = [
  OfficeEdition(
    'O365ProPlusRetail',
    'Microsoft 365 Apps for Enterprise',
    ['Current', 'Broad', 'MonthlyEnterprise'],
  ),
  OfficeEdition(
    'O365BusinessRetail',
    'Microsoft 365 Apps for Business',
    ['Current', 'Broad', 'MonthlyEnterprise'],
  ),
  OfficeEdition(
    'ProPlus2021Volume',
    'Office LTSC Professional Plus 2021',
    ['PerpetualVL2021'],
  ),
  OfficeEdition(
    'ProPlus2024Volume',
    'Office LTSC Professional Plus 2024',
    ['PerpetualVL2024'],
  ),
  OfficeEdition(
    'Standard2024Volume',
    'Office LTSC Standard 2024',
    ['PerpetualVL2024'],
  ),
  OfficeEdition(
    'Home2024Retail',
    'Office Home 2024',
    ['Current', 'Broad', 'MonthlyEnterprise'],
  ),
];

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
