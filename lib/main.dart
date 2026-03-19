import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/installer_state.dart';
import 'presentation/home_page.dart';

void main() {
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
      child: MaterialApp(
        title: 'Accessible Office Installer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          // Enhanced accessibility: larger default typography
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
        // High Contrast theme mode support mapping
        highContrastTheme: ThemeData(
          colorScheme: const ColorScheme.highContrastLight(primary: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
