import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class ApiService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: Constants.tokenKey);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      // Token expired, clear storage and throw exception
      await _storage.deleteAll();
      throw Exception('Unauthorized');
    }
    return response;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse('${Constants.apiBaseUrl}${Constants.loginEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final handledResponse = await _handleResponse(response);

    if (handledResponse.statusCode == 200) {
      final data = jsonDecode(handledResponse.body);
      await _storage.write(
        key: Constants.tokenKey,
        value: data['access_token'],
      );
      await _storage.write(
        key: Constants.userKey,
        value: jsonEncode(data['user']),
      );
      return data;
    } else {
      throw Exception('Login failed');
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await _client.post(
      Uri.parse('${Constants.apiBaseUrl}${Constants.registerEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    final handledResponse = await _handleResponse(response);

    if (handledResponse.statusCode == 201) {
      return jsonDecode(handledResponse.body);
    } else {
      throw Exception('Registration failed');
    }
  }

  Future<List<dynamic>> getStudents({String? schoolId}) async {
    final headers = await _getHeaders();
    final url = schoolId != null
        ? '${Constants.apiBaseUrl}/schools/$schoolId${Constants.studentsEndpoint}'
        : '${Constants.apiBaseUrl}${Constants.studentsEndpoint}';

    final response = await _client.get(Uri.parse(url), headers: headers);
    final handledResponse = await _handleResponse(response);

    if (handledResponse.statusCode == 200) {
      return jsonDecode(handledResponse.body);
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<Map<String, dynamic>> getAttendance(
    String studentId,
    DateTime date,
  ) async {
    final headers = await _getHeaders();
    final response = await _client.get(
      Uri.parse(
        '${Constants.apiBaseUrl}${Constants.attendanceEndpoint}?studentId=$studentId&date=${date.toIso8601String()}',
      ),
      headers: headers,
    );

    final handledResponse = await _handleResponse(response);

    if (handledResponse.statusCode == 200) {
      return jsonDecode(handledResponse.body);
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  Future<List<dynamic>> getGrades(String studentId) async {
    final headers = await _getHeaders();
    final response = await _client.get(
      Uri.parse(
        '${Constants.apiBaseUrl}${Constants.gradesEndpoint}?studentId=$studentId',
      ),
      headers: headers,
    );

    final handledResponse = await _handleResponse(response);

    if (handledResponse.statusCode == 200) {
      return jsonDecode(handledResponse.body);
    } else {
      throw Exception('Failed to load grades');
    }
  }

  Future<List<dynamic>> getTimetable(String classId) async {
    final headers = await _getHeaders();
    final response = await _client.get(
      Uri.parse(
        '${Constants.apiBaseUrl}${Constants.timetableEndpoint}?classId=$classId',
      ),
      headers: headers,
    );

    final handledResponse = await _handleResponse(response);

    if (handledResponse.statusCode == 200) {
      return jsonDecode(handledResponse.body);
    } else {
      throw Exception('Failed to load timetable');
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
