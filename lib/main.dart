import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'src/app_theme.dart';
import 'src/providers/app_state.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/sign_in_screen.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Div Admin',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: appState.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: appState.isAuthenticated
                ? const HomeScreen()
                : const SignInScreen(),
          );
        },
      ),
    );
  }
}
