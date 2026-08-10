import 'dart:convert';

import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/models/response/help_response.dart';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:http/http.dart' as http;

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
        print(jsonDecode(response.body));
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
          'Accept': 'application/json',
        },
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

  Future<Document?> getSingleDocument({required String id}) async {
    try {
      final url = Uri.parse(AppUrl.singleLegalApi(id: id));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Debug print to see what's coming
        print('Response Data: $jsonData');

        // Check if response has success and document
        if (jsonData['success'] == true && jsonData['document'] != null) {
          // Parse the document inside the 'document' key
          return Document.fromJson(jsonData['document']);
        } else {
          print('Document not found in response');
          return null;
        }
      } else {
        print('Failed to load document. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return null;
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Exception: $e');
      return null;
    } on FormatException catch (e) {
      print('JSON Format Exception: $e');
      return null;
    } catch (e, stackTrace) {
      print('Unexpected Error: $e');
      print(stackTrace);
      return null;
    }
  }

  Future<SubscriptionPlansResponse?> allSubscriptionPlans({
    required String name,
  }) async {
    final url = Uri.parse(AppUrl.plan(name: name));
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return SubscriptionPlansResponse.fromJson(jsonData);
    }
    return null;
  }

  // support page
}
