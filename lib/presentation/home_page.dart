import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models.dart';
import '../l10n/app_localizations.dart';
import 'installer_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.text('appTitle')),
        actions: [
          Consumer<InstallerState>(
            builder: (context, state, child) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 12.0),
                child: _buildLanguageSelector(state, l10n),
              );
            },
          ),
          Consumer<InstallerState>(
            builder: (context, state, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Semantics(
                    label: state.isOfficeInstalled
                        ? l10n.text('officeInstalledSemantics')
                        : l10n.text('officeNotInstalledSemantics'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.isOfficeInstalled ? Icons.check_circle : Icons.info,
                          color: state.isOfficeInstalled ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          state.isOfficeInstalled
                              ? l10n.text('officeInstalled')
                              : l10n.text('officeNotFound'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: Consumer<InstallerState>(
        builder: (context, state, child) {
          if (state.isInstalling) {
            return const SizedBox.shrink();
          }
          return _buildInstallActionBar(state);
        },
      ),
      body: Consumer<InstallerState>(
        builder: (context, state, child) {
          if (state.isInstalling) {
            return _buildInstallingView(context, state);
          }
          return _buildConfigurationForm(context, state);
        },
      ),
    );
  }

  Widget _buildInstallingView(BuildContext context, InstallerState state) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.text('installationProgress'),
            style: Theme.of(context).textTheme.headlineSmall,
            semanticsLabel: l10n.text('installationInProgressSemantics'),
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
          Text(state.installStatus, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Text(l10n.text('installationLogs')),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black87,
              child: SingleChildScrollView(
                child: Text(
                  state.logs,
                  style: const TextStyle(color: Colors.greenAccent, fontFamily: 'Consolas'),
                  semanticsLabel: '${l10n.text('logOutputSemantics')}: ${state.logs}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationForm(BuildContext context, InstallerState state) {
    final l10n = AppLocalizations.of(context);
    final channelItems = state.availableChannelsForSelectedEdition;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 120.0),
        children: [
          Text(l10n.text('officeConfiguration'), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          
          _buildDropdown<String>(
            label: l10n.text('edition'),
            value: state.edition,
            items: availableEditions
                .map(
                  (edition) => DropdownMenuItem<String>(
                    value: edition.id,
                    child: Text(edition.name),
                  ),
                )
                .toList(),
            onChanged: (val) => state.updateEdition(val!),
            tooltip: l10n.text('editionTooltip'),
          ),
          
          _buildDropdown<String>(
            label: l10n.text('architecture'),
            value: state.architecture,
            items: const [
              DropdownMenuItem(value: '64', child: Text('64-bit')),
              DropdownMenuItem(value: '32', child: Text('32-bit')),
            ],
            onChanged: (val) => state.updateArchitecture(val!),
            tooltip: l10n.text('architectureTooltip'),
          ),
          
          _buildDropdown<String>(
            label: l10n.text('language'),
            value: state.language,
            items: const [
              DropdownMenuItem(value: 'en-us', child: Text('English (US)')),
              DropdownMenuItem(value: 'ar-sa', child: Text('Arabic (Saudi Arabia)')),
              DropdownMenuItem(value: 'fr-fr', child: Text('French (France)')),
              DropdownMenuItem(value: 'es-es', child: Text('Spanish (Spain)')),
              DropdownMenuItem(value: 'de-de', child: Text('German (Germany)')),
            ],
            onChanged: (val) => state.updateLanguage(val!),
            tooltip: l10n.text('languageTooltip'),
          ),

          _buildDropdown<String>(
            label: l10n.text('updateChannel'),
            value: state.channel,
            items: channelItems
                .map(
                  (channel) => DropdownMenuItem<String>(
                    value: channel.id,
                    child: Text(channel.name),
                  ),
                )
                .toList(),
            onChanged: (val) => state.updateChannel(val!),
            tooltip: l10n.text('updateChannelTooltip'),
          ),
          
          _buildDropdown<String>(
            label: l10n.text('displayLevel'),
            value: state.displayLevel,
            items: const [
              DropdownMenuItem(value: 'None', child: Text('None (Silent/Accessibility Mode)')),
              DropdownMenuItem(value: 'Full', child: Text('Full (Show Office Installer UI)')),
            ],
            onChanged: (val) => state.updateDisplayLevel(val!),
            tooltip: l10n.text('displayLevelTooltip'),
          ),
          
          const SizedBox(height: 24),
          Text(l10n.text('excludeApplications'), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Semantics(
            label: l10n.text('excludeApplicationsTooltip'),
            child: Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              children: availableApps.map((app) {
                final isExcluded = state.excludeApps.contains(app.id);
                return FilterChip(
                  label: Text(app.name),
                  selected: isExcluded,
                  onSelected: (_) => state.toggleAppExclusion(app.id),
                  tooltip: isExcluded
                      ? l10n.text('includeApp', params: {'app': app.name})
                      : l10n.text('excludeApp', params: {'app': app.name}),
                  selectedColor: Colors.red[100],
                  checkmarkColor: Colors.red,
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 32),
          if (state.hasInstallationActivity) ...[
            _buildInstallationSummary(state),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildInstallActionBar(InstallerState state) {
    final l10n = AppLocalizations(AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == state.appLocale.languageCode,
      orElse: () => const Locale('en'),
    ));

    return SafeArea(
      top: false,
      child: Material(
        elevation: 12,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.text('installActionHelp'),
              ),
              const SizedBox(height: 12),
              Semantics(
                button: true,
                label: l10n.text('installButtonSemantics'),
                hint: l10n.text('installButtonHint'),
                child: ElevatedButton.icon(
                  onPressed: () => state.startInstallation(),
                  icon: const Icon(Icons.download),
                  label: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l10n.text('installButton'), style: const TextStyle(fontSize: 18)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstallationSummary(InstallerState state) {
    final l10n = AppLocalizations(AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == state.appLocale.languageCode,
      orElse: () => const Locale('en'),
    ));
    final summaryColor = state.lastOperationFailed ? Colors.red : Colors.blue;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: summaryColor.withValues(alpha: 0.08),
        border: Border.all(color: summaryColor.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.lastOperationFailed
                ? l10n.text('lastInstallationError')
                : l10n.text('lastInstallationStatus'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: summaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(state.installStatus),
          if (state.logs.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l10n.text('logs'), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              color: Colors.black87,
              child: SelectableText(
                state.logs,
                style: const TextStyle(color: Colors.greenAccent, fontFamily: 'Consolas'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    InstallerState state,
    AppLocalizations l10n,
  ) {
    return Semantics(
      label: l10n.text('languageSection'),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.appLocale.languageCode,
          icon: const Icon(Icons.language),
          onChanged: (value) {
            if (value != null) {
              state.updateAppLocale(Locale(value));
            }
          },
          items: [
            DropdownMenuItem<String>(
              value: 'ar',
              child: Text(l10n.text('languageArabic')),
            ),
            DropdownMenuItem<String>(
              value: 'fr',
              child: Text(l10n.text('languageFrench')),
            ),
            DropdownMenuItem<String>(
              value: 'en',
              child: Text(l10n.text('languageEnglish')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Semantics(
        label: tooltip,
        tooltip: tooltip,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: value,
                  items: items,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
