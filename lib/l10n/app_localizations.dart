import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static const localizationsDelegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'AppLocalizations not found in context');
    return localizations!;
  }

  static Locale resolveDeviceLocale(Iterable<Locale> deviceLocales) {
    for (final locale in deviceLocales) {
      for (final supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return supportedLocale;
        }
      }
    }

    return const Locale('en');
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Accessible Office Installer',
      'languageSection': 'Interface Language',
      'languageEnglish': 'English',
      'languageFrench': 'Français',
      'languageArabic': 'العربية',
      'officeInstalled': 'Office Installed',
      'officeNotFound': 'Office Not Found',
      'officeInstalledSemantics': 'Office is already installed on this machine.',
      'officeNotInstalledSemantics': 'Office is not installed.',
      'installationProgress': 'Installation Progress',
      'installationInProgressSemantics': 'Installation in progress.',
      'installationLogs': 'Installation Logs:',
      'logOutputSemantics': 'Log output',
      'officeConfiguration': 'Office Configuration',
      'edition': 'Edition',
      'editionTooltip': 'Select the Office edition to install.',
      'architecture': 'Architecture',
      'architectureTooltip': 'Select the system architecture.',
      'language': 'Language',
      'languageTooltip': 'Select the primary installation language.',
      'updateChannel': 'Update Channel',
      'updateChannelTooltip': 'Select the update channel for Office.',
      'displayLevel': 'Installation Interface Level (Display Level)',
      'displayLevelTooltip': 'Select whether the Microsoft Office installer interface should be shown or hidden.',
      'excludeApplications': 'Exclude Applications:',
      'excludeApplicationsTooltip': 'Application exclusion list. Check an app to exclude it from installation.',
      'includeApp': 'Include {app}',
      'excludeApp': 'Exclude {app}',
      'lastInstallationError': 'Last Installation Error',
      'lastInstallationStatus': 'Last Installation Status',
      'logs': 'Logs:',
      'installActionHelp': 'After choosing the required options, activate the button below to start installation.',
      'installButton': 'Install Office',
      'installButtonSemantics': 'Install Office now. This button starts the selected Office installation and requires administrator privileges.',
      'installButtonHint': 'Activates the Office installation using the selected options.',
      'readyToInstall': 'Ready to install',
      'preparingInstallation': 'Preparing installation...',
      'generatedConfiguration': 'Generated configuration.xml',
      'adjustedChannel': 'Adjusted update channel from {from} to {to} for the selected Office edition.',
      'downloadingOdt': 'Downloading Office Deployment Tool...',
      'odtExtracted': 'ODT extracted to: {path}',
      'runningInstallation': 'Running installation...',
      'installationCompleted': 'Installation completed successfully.',
      'installationFailed': 'Installation failed with exit code {code}.',
      'installationError': 'Error occurred during installation.',
    },
    'fr': {
      'appTitle': 'Installateur Office accessible',
      'languageSection': 'Langue de l\'interface',
      'languageEnglish': 'English',
      'languageFrench': 'Français',
      'languageArabic': 'العربية',
      'officeInstalled': 'Office installe',
      'officeNotFound': 'Office introuvable',
      'officeInstalledSemantics': 'Office est deja installe sur cette machine.',
      'officeNotInstalledSemantics': 'Office n\'est pas installe.',
      'installationProgress': 'Progression de l\'installation',
      'installationInProgressSemantics': 'Installation en cours.',
      'installationLogs': 'Journaux d\'installation :',
      'logOutputSemantics': 'Sortie du journal',
      'officeConfiguration': 'Configuration d\'Office',
      'edition': 'Edition',
      'editionTooltip': 'Selectionnez l\'edition Office a installer.',
      'architecture': 'Architecture',
      'architectureTooltip': 'Selectionnez l\'architecture du systeme.',
      'language': 'Langue',
      'languageTooltip': 'Selectionnez la langue principale de l\'installation.',
      'updateChannel': 'Canal de mise a jour',
      'updateChannelTooltip': 'Selectionnez le canal de mise a jour pour Office.',
      'displayLevel': 'Niveau d\'interface d\'installation',
      'displayLevelTooltip': 'Choisissez si l\'interface de l\'installateur Office doit etre visible ou masquee.',
      'excludeApplications': 'Exclure des applications :',
      'excludeApplicationsTooltip': 'Liste d\'exclusion des applications. Cochez une application pour l\'exclure de l\'installation.',
      'includeApp': 'Inclure {app}',
      'excludeApp': 'Exclure {app}',
      'lastInstallationError': 'Derniere erreur d\'installation',
      'lastInstallationStatus': 'Dernier etat d\'installation',
      'logs': 'Journaux :',
      'installActionHelp': 'Apres avoir choisi les options requises, activez le bouton ci-dessous pour lancer l\'installation.',
      'installButton': 'Installer Office',
      'installButtonSemantics': 'Installer Office maintenant. Ce bouton lance l\'installation Office selectionnee et necessite les droits administrateur.',
      'installButtonHint': 'Lance l\'installation Office avec les options selectionnees.',
      'readyToInstall': 'Pret a installer',
      'preparingInstallation': 'Preparation de l\'installation...',
      'generatedConfiguration': 'configuration.xml genere',
      'adjustedChannel': 'Canal de mise a jour ajuste de {from} vers {to} pour l\'edition Office selectionnee.',
      'downloadingOdt': 'Telechargement de l\'Office Deployment Tool...',
      'odtExtracted': 'ODT extrait vers : {path}',
      'runningInstallation': 'Execution de l\'installation...',
      'installationCompleted': 'Installation terminee avec succes.',
      'installationFailed': 'L\'installation a echoue avec le code de sortie {code}.',
      'installationError': 'Une erreur s\'est produite pendant l\'installation.',
    },
    'ar': {
      'appTitle': 'مثبت أوفيس الميسر',
      'languageSection': 'لغة الواجهة',
      'languageEnglish': 'English',
      'languageFrench': 'Français',
      'languageArabic': 'العربية',
      'officeInstalled': 'تم العثور على أوفيس',
      'officeNotFound': 'لم يتم العثور على أوفيس',
      'officeInstalledSemantics': 'أوفيس مثبت بالفعل على هذا الجهاز.',
      'officeNotInstalledSemantics': 'أوفيس غير مثبت.',
      'installationProgress': 'تقدم التثبيت',
      'installationInProgressSemantics': 'التثبيت جار الآن.',
      'installationLogs': 'سجل التثبيت:',
      'logOutputSemantics': 'مخرجات السجل',
      'officeConfiguration': 'إعدادات أوفيس',
      'edition': 'الإصدار',
      'editionTooltip': 'اختر إصدار أوفيس المراد تثبيته.',
      'architecture': 'المعمارية',
      'architectureTooltip': 'اختر معمارية النظام.',
      'language': 'اللغة',
      'languageTooltip': 'اختر اللغة الأساسية للتثبيت.',
      'updateChannel': 'قناة التحديث',
      'updateChannelTooltip': 'اختر قناة تحديث أوفيس.',
      'displayLevel': 'مستوى واجهة التثبيت',
      'displayLevelTooltip': 'اختر ما إذا كانت واجهة مثبت أوفيس ستظهر أو ستبقى مخفية.',
      'excludeApplications': 'استبعاد التطبيقات:',
      'excludeApplicationsTooltip': 'قائمة استبعاد التطبيقات. حدد التطبيق لاستبعاده من التثبيت.',
      'includeApp': 'تضمين {app}',
      'excludeApp': 'استبعاد {app}',
      'lastInstallationError': 'آخر خطأ في التثبيت',
      'lastInstallationStatus': 'آخر حالة للتثبيت',
      'logs': 'السجل:',
      'installActionHelp': 'بعد اختيار الإعدادات المطلوبة، فعّل الزر التالي لبدء التثبيت.',
      'installButton': 'تثبيت أوفيس',
      'installButtonSemantics': 'ثبّت أوفيس الآن. هذا الزر يبدأ تثبيت أوفيس بالإعدادات المحددة ويتطلب صلاحيات المسؤول.',
      'installButtonHint': 'يبدأ تثبيت أوفيس باستخدام الإعدادات المحددة.',
      'readyToInstall': 'جاهز للتثبيت',
      'preparingInstallation': 'جار تحضير التثبيت...',
      'generatedConfiguration': 'تم إنشاء ملف configuration.xml',
      'adjustedChannel': 'تم تعديل قناة التحديث من {from} إلى {to} لتناسب إصدار أوفيس المحدد.',
      'downloadingOdt': 'جار تنزيل أداة Office Deployment Tool...',
      'odtExtracted': 'تم استخراج ODT إلى: {path}',
      'runningInstallation': 'جار تشغيل التثبيت...',
      'installationCompleted': 'اكتمل التثبيت بنجاح.',
      'installationFailed': 'فشل التثبيت مع رمز الخروج {code}.',
      'installationError': 'حدث خطأ أثناء التثبيت.',
    },
  };

  String text(String key, {Map<String, String> params = const {}}) {
    final languageCode = locale.languageCode;
    var value =
        _localizedValues[languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;

    params.forEach((paramKey, paramValue) {
      value = value.replaceAll('{$paramKey}', paramValue);
    });

    return value;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
