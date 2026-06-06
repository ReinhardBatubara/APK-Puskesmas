import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static const String _keyLoginSession = 'login_session';
  static const String _keyOnboarding = 'onboarding_done';
  static const String _keyQueues = 'queues_data';
  static const String _keyConsultations = 'consultations_data';
  static const String _keyFeedbacks = 'feedbacks_data';
  static const String _keyRegisteredUsers = 'registered_users';

  // Login Session
  static Future<void> saveLoginSession(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLoginSession, jsonEncode(userData));
    } catch (_) {}
  }

  static Future<Map<String, dynamic>?> getLoginSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyLoginSession);
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearLoginSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLoginSession);
    } catch (_) {}
  }

  // Onboarding
  static Future<void> saveOnboardingStatus(bool done) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyOnboarding, done);
    } catch (_) {}
  }

  static Future<bool> getOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyOnboarding) ?? false;
    } catch (_) {
      return false;
    }
  }

  // Queues
  static Future<void> saveQueues(List<Map<String, dynamic>> queues) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyQueues, jsonEncode(queues));
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getQueues() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyQueues);
      if (data == null) return [];
      final list = jsonDecode(data) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      return [];
    }
  }

  // Consultations
  static Future<void> saveConsultations(
      List<Map<String, dynamic>> consultations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyConsultations, jsonEncode(consultations));
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getConsultations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyConsultations);
      if (data == null) return [];
      final list = jsonDecode(data) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      return [];
    }
  }

  // Feedback
  static Future<void> saveFeedback(
      List<Map<String, dynamic>> feedbacks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyFeedbacks, jsonEncode(feedbacks));
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getFeedback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyFeedbacks);
      if (data == null) return [];
      final list = jsonDecode(data) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      return [];
    }
  }

  // Registered Users
  static Future<void> saveRegisteredUsers(
      List<Map<String, dynamic>> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyRegisteredUsers, jsonEncode(users));
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyRegisteredUsers);
      if (data == null) return [];
      final list = jsonDecode(data) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      return [];
    }
  }
}
