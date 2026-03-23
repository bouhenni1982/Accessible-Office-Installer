import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'presentation/installer_state.dart';
import 'presentation/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AccessibleOfficeInstallerApp());
}

class AccessibleOfficeInstallerApp extends StatelessWidget {
  const AccessibleOfficeInstallerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InstallerState()),
      ],
      child: Consumer<InstallerState>(
        builder: (context, state, child) {
          return MaterialApp(
            title: 'Accessible Office Installer',
            debugShowCheckedModeBanner: false,
            locale: state.appLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.localizationsDelegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(fontSize: 18),
                bodyMedium: TextStyle(fontSize: 16),
                titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
              ),
            ),
            highContrastTheme: ThemeData(
              colorScheme: const ColorScheme.highContrastLight(primary: Colors.blueAccent),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
