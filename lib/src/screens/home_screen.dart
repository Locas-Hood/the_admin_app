import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../providers/app_state.dart';
import 'digital_services_editor_screen.dart';
import 'ministry_editor_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      if (appState.hasCredentials &&
          (appState.dataFile == null || appState.servicesFile == null)) {
        appState.loadAll();
      }
    });
  }

  static const List<Widget> _screens = <Widget>[
    MinistryEditorScreen(),
    DigitalServicesEditorScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final locale = appState.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appTitle(locale)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: appState.hasCredentials
                ? () => appState.loadAll()
                : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (appState.statusMessage != null)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary.withAlpha(31),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    appState.statusMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(child: _screens[_selectedIndex]),
            ],
          ),
          if (appState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance),
            label: AppStrings.ministries(locale),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_customize),
            label: AppStrings.digitalServices(locale),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppStrings.settings(locale),
          ),
        ],
      ),
    );
  }
}
