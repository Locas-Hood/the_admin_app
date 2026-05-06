import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final locale = appState.locale;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.settings(locale),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Text(AppStrings.enableDarkMode(locale)),
            value: appState.isDarkMode,
            onChanged: (_) => appState.toggleTheme(),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: Text(AppStrings.language(locale)),
            subtitle: Text(
              appState.locale.languageCode == 'ar'
                  ? AppStrings.arabic(locale)
                  : AppStrings.english(locale),
            ),
            trailing: DropdownButton<Locale>(
              value: appState.locale,
              items: const [
                DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                  appState.setLocale(value);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.sync),
            label: Text(AppStrings.refresh(locale)),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await appState.loadAll();
              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    appState.statusMessage ?? AppStrings.loading(locale),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(AppStrings.logout(locale)),
            onPressed: () {
              appState.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.loggedOut(locale))),
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.dataFile(locale),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appState.dataFile != null
                        ? appState.dataFile!.sections
                              .map((section) => section.lastUpdate)
                              .join(' | ')
                        : '-',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.servicesFile(locale),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(appState.servicesFile != null ? 'Loaded' : 'Not loaded'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
