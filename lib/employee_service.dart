import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee_model.dart';

class ApiService {
  static const String baseUrl = "http://10.252.151.111:8000";
  // http://localhost:8000


  static Future<List<Employee>> fetchEmployees() async {
    final url = Uri.parse("$baseUrl/employee/all");
    // final response = await http.get(url);
    // print(response.body);

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
    });
    print(response.body);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load employees");
    }
  }


}
