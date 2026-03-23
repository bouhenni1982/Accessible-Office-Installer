import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/models.dart';
import 'installer_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessible Office Installer'),
        actions: [
          Consumer<InstallerState>(
            builder: (context, state, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Semantics(
                    label: state.isOfficeInstalled 
                        ? 'Office is already installed on this machine.' 
                        : 'Office is not installed.',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(state.isOfficeInstalled ? Icons.check_circle : Icons.info, 
                             color: state.isOfficeInstalled ? Colors.green : Colors.orange),
                        const SizedBox(width: 8),
                        Text(state.isOfficeInstalled ? 'Office Installed' : 'Office Not Found'),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Installation Progress',
            style: Theme.of(context).textTheme.headlineSmall,
            semanticsLabel: 'Installation in progress.',
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
          Text(state.installStatus, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Text('Installation Logs:'),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black87,
              child: SingleChildScrollView(
                child: Text(
                  state.logs,
                  style: const TextStyle(color: Colors.greenAccent, fontFamily: 'Consolas'),
                  semanticsLabel: 'Log output: ${state.logs}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationForm(BuildContext context, InstallerState state) {
    final channelItems = state.availableChannelsForSelectedEdition;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text('Office Configuration', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          
          _buildDropdown<String>(
            label: 'Edition',
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
            tooltip: 'Select the Office Edition to install.',
          ),
          
          _buildDropdown<String>(
            label: 'Architecture',
            value: state.architecture,
            items: const [
              DropdownMenuItem(value: '64', child: Text('64-bit')),
              DropdownMenuItem(value: '32', child: Text('32-bit')),
            ],
            onChanged: (val) => state.updateArchitecture(val!),
            tooltip: 'Select the system architecture.',
          ),
          
          _buildDropdown<String>(
            label: 'Language',
            value: state.language,
            items: const [
              DropdownMenuItem(value: 'en-us', child: Text('English (US)')),
              DropdownMenuItem(value: 'ar-sa', child: Text('Arabic (Saudi Arabia)')),
              DropdownMenuItem(value: 'fr-fr', child: Text('French (France)')),
              DropdownMenuItem(value: 'es-es', child: Text('Spanish (Spain)')),
              DropdownMenuItem(value: 'de-de', child: Text('German (Germany)')),
            ],
            onChanged: (val) => state.updateLanguage(val!),
            tooltip: 'Select the primary installation language.',
          ),

          _buildDropdown<String>(
            label: 'Update Channel',
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
            tooltip: 'Select the update channel for Office.',
          ),
          
          _buildDropdown<String>(
            label: 'Installation Interface Level (Display Level)',
            value: state.displayLevel,
            items: const [
              DropdownMenuItem(value: 'None', child: Text('None (Silent/Accessibility Mode)')),
              DropdownMenuItem(value: 'Full', child: Text('Full (Show Office Installer UI)')),
            ],
            onChanged: (val) => state.updateDisplayLevel(val!),
            tooltip: 'Select whether the Microsoft Office Installer UI should be shown or hidden.',
          ),
          
          const SizedBox(height: 24),
          const Text('Exclude Applications:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Semantics(
            label: 'Application exclusion list. Check an app to exclude it from installation.',
            child: Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              children: availableApps.map((app) {
                final isExcluded = state.excludeApps.contains(app.id);
                return FilterChip(
                  label: Text(app.name),
                  selected: isExcluded,
                  onSelected: (_) => state.toggleAppExclusion(app.id),
                  tooltip: isExcluded ? 'Include ${app.name}' : 'Exclude ${app.name}',
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
          Semantics(
            button: true,
            label: 'Start Office Installation. This will require Administrator privileges.',
            child: ElevatedButton.icon(
              onPressed: state.isInstalling ? null : () => state.startInstallation(),
              icon: const Icon(Icons.download),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Install Office', style: TextStyle(fontSize: 18)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallationSummary(InstallerState state) {
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
            state.lastOperationFailed ? 'Last Installation Error' : 'Last Installation Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: summaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(state.installStatus),
          if (state.logs.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
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
