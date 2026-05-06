import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../providers/app_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final appState = context.read<AppState>();

    final success = await appState.authenticate(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appState.statusMessage ?? 'Signed in')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appState.statusMessage ?? 'Sign in failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final locale = appState.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appTitle(locale)),
        actions: [
          IconButton(
            icon: Icon(
              appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => appState.toggleTheme(),
          ),
          DropdownButton<Locale>(
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
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.signIn(locale),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: AppStrings.email(locale),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textDirection: locale.languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.enterEmail(locale);
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return AppStrings.invalidEmail(locale);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: AppStrings.password(locale),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  textDirection: locale.languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.enterPassword(locale);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(AppStrings.signIn(locale)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
