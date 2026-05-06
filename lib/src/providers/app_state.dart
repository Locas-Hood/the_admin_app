import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../models/service_models.dart';
import '../models/email_model.dart';
import '../services/github_api_service.dart';

class AppState extends ChangeNotifier {
  final String _owner = 'Locas-Hood';
  final String _repo = 'div_admin';
  final String _dataPath = 'data.json';
  final String _servicesPath = 'services.json';
  final String _emailPath = 'email.json';
  final String _branch = 'main';

  // Hardcoded GitHub Personal Access Token
  final String githubToken =
      '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';

  Locale locale = const Locale('ar');
  bool isDarkMode = false;
  bool isLoading = false;
  String? statusMessage;

  DataDocument? dataFile;
  ServicesFile? servicesFile;
  EmailData? emailData;

  bool get hasCredentials => githubToken.trim().isNotEmpty;
  bool get isAuthenticated => _authenticatedEmail != null;
  String? _authenticatedEmail;

  GithubApiService get _gitHubService {
    return GithubApiService(
      owner: _owner,
      repo: _repo,
      token: githubToken,
      branch: _branch,
    );
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void setLocale(Locale newLocale) {
    locale = newLocale;
    notifyListeners();
  }

  Future<void> loadAll() async {
    isLoading = true;
    statusMessage = null;
    notifyListeners();
    try {
      await fetchDataFile();
      await fetchServicesFile();
      statusMessage = 'Content synchronized successfully';
    } catch (error) {
      statusMessage = 'Synchronization failed: ${error.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDataFile() async {
    final file = await _gitHubService.fetchFile(_dataPath);
    final json = jsonDecode(file.content);
    dataFile = DataDocument.fromJson(json);
  }

  Future<void> fetchServicesFile() async {
    final file = await _gitHubService.fetchFile(_servicesPath);
    final json = jsonDecode(file.content) as Map<String, dynamic>;
    servicesFile = ServicesFile.fromJson(json);
  }

  Future<void> saveDataFile() async {
    if (dataFile == null) {
      throw Exception('No data loaded to save.');
    }
    isLoading = true;
    notifyListeners();
    try {
      final existing = await _gitHubService.fetchFile(_dataPath);
      final content = jsonEncode(dataFile!.toJson());
      await _gitHubService.updateFile(
        path: _dataPath,
        content: content,
        sha: existing.sha,
        commitMessage: 'Update data.json from admin panel',
      );
      statusMessage = 'Data JSON updated successfully.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveServicesFile() async {
    if (servicesFile == null) {
      throw Exception('No services loaded to save.');
    }
    isLoading = true;
    notifyListeners();
    try {
      final existing = await _gitHubService.fetchFile(_servicesPath);
      final content = jsonEncode(servicesFile!.toJson());
      await _gitHubService.updateFile(
        path: _servicesPath,
        content: content,
        sha: existing.sha,
        commitMessage: 'Update services.json from admin panel',
      );
      statusMessage = 'Services JSON updated successfully.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEmailData() async {
    final file = await _gitHubService.fetchFile(_emailPath);
    final json = jsonDecode(file.content) as Map<String, dynamic>;
    emailData = EmailData.fromJson(json);
  }

  Future<bool> authenticate(String email, String password) async {
    if (!hasCredentials) {
      statusMessage = 'GitHub token not configured';
      notifyListeners();
      return false;
    }

    if (emailData == null) {
      try {
        await fetchEmailData();
      } catch (error) {
        statusMessage = 'Failed to load email data: $error';
        notifyListeners();
        return false;
      }
    }

    final credential = emailData!.adminCredentials.firstWhere(
      (cred) =>
          cred.email.trim().toLowerCase() == email.trim().toLowerCase() &&
          cred.password == password,
      orElse: () => AdminCredential(email: '', password: ''),
    );

    if (credential.email.isNotEmpty) {
      _authenticatedEmail = email.trim().toLowerCase();
      statusMessage = 'Authentication successful';
      notifyListeners();
      try {
        await loadAll();
      } catch (_) {
        // loadAll handles its own error reporting
      }
      return true;
    } else {
      statusMessage = 'Invalid email or password';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _authenticatedEmail = null;
    statusMessage = null;
    notifyListeners();
  }

  void setStatus(String? message) {
    statusMessage = message;
    notifyListeners();
  }
}
