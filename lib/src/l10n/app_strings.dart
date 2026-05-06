import 'package:flutter/material.dart';

class AppStrings {
  static String appTitle(Locale locale) => locale.languageCode == 'ar'
      ? 'لوحة إدارة الخدمات'
      : 'Services Admin Panel';
  static String ministries(Locale locale) =>
      locale.languageCode == 'ar' ? 'الوزارات' : 'Ministries';
  static String digitalServices(Locale locale) =>
      locale.languageCode == 'ar' ? 'الخدمات الرقمية' : 'Digital Services';
  static String settings(Locale locale) =>
      locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';
  static String refresh(Locale locale) =>
      locale.languageCode == 'ar' ? 'تحديث البيانات' : 'Refresh Data';
  static String loading(Locale locale) =>
      locale.languageCode == 'ar' ? 'جاري التحميل...' : 'Loading...';
  static String saveButton(Locale locale) =>
      locale.languageCode == 'ar' ? 'حفظ' : 'Save';
  static String saveSuccess(Locale locale) =>
      locale.languageCode == 'ar' ? 'تم الحفظ بنجاح' : 'Saved successfully';
  static String saveFailed(Locale locale) =>
      locale.languageCode == 'ar' ? 'فشل الحفظ' : 'Save failed';
  static String signIn(Locale locale) =>
      locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Sign In';
  static String email(Locale locale) =>
      locale.languageCode == 'ar' ? 'البريد الإلكتروني' : 'Email';
  static String password(Locale locale) =>
      locale.languageCode == 'ar' ? 'كلمة المرور' : 'Password';
  static String enterEmail(Locale locale) => locale.languageCode == 'ar'
      ? 'يرجى إدخال البريد الإلكتروني'
      : 'Please enter email';
  static String enterPassword(Locale locale) => locale.languageCode == 'ar'
      ? 'يرجى إدخال كلمة المرور'
      : 'Please enter password';
  static String invalidEmail(Locale locale) =>
      locale.languageCode == 'ar' ? 'بريد إلكتروني غير صحيح' : 'Invalid email';
  static String logout(Locale locale) =>
      locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Logout';
  static String loggedOut(Locale locale) =>
      locale.languageCode == 'ar' ? 'تم تسجيل الخروج' : 'Logged out';
  static String enableDarkMode(Locale locale) =>
      locale.languageCode == 'ar' ? 'الوضع الداكن' : 'Dark Mode';
  static String language(Locale locale) =>
      locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  static String arabic(Locale locale) => 'العربية';
  static String english(Locale locale) => 'English';
  static String dataFile(Locale locale) =>
      locale.languageCode == 'ar' ? 'ملف البيانات' : 'Data File';
  static String servicesFile(Locale locale) =>
      locale.languageCode == 'ar' ? 'ملف الخدمات' : 'Services File';
  static String commitMessage(Locale locale) => locale.languageCode == 'ar'
      ? 'تحديث من لوحة الإدارة'
      : 'Update from admin panel';
}
