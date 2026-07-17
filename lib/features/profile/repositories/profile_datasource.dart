import 'dart:convert';

import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/models/response/help_response.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/storage_service.dart';

class ProfileDatasource {
  Future<HelpResponse?> allHelp() async {
    try {
      final url = Uri.parse(AppUrl.helpApi);

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return HelpResponse.fromJson(jsonData);
      } else {
        print('API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in allHelp(): $e');
      return null;
    }
  }

  Future<DocumentModel?> getDocument() async {
    try {

      final url = Uri.parse(AppUrl.legalApi);

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',}
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return DocumentModel.fromJson(jsonData);
      } else {
        print('Failed to fetch documents');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getDocument(): $e');
      return null;
    }
  }
  
}
