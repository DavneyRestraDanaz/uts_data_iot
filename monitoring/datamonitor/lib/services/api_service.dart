import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_model.dart';

class ApiService {
  final String apiUrl = 'http://192.168.1.5:3000/api/data'; // tergantung ip pada device

  Future<DataModel> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return DataModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}
