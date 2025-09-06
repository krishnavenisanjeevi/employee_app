import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee_model.dart';

class ApiService {
  static const String baseUrl = "http://10.252.151.111:8000";
  // http://localhost:8000


  static Future<List<Employee>> fetchEmployees() async {
    final url = Uri.parse("$baseUrl/employee/all");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load employees");
    }
  }

  static Future<Employee> createEmployee(Employee employee) async {
    final url = Uri.parse("$baseUrl/employee/create");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "name": employee.name,
        "position": employee.position,
        "status": employee.status,
        "joining_date": employee.joiningDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Employee.fromJson(data);
    } else {
      throw Exception("Failed to create employee: ${response.body}");
    }
  }




}
