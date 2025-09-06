import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'create_employee.dart';
import 'employee_model.dart';
import 'employee_service.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Employee> employees = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // loadJsonFromAssets();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final data = await ApiService.fetchEmployees();
      setState(() {
        employees = data;
        isLoading = false;
      });
    } catch (e) {

      setState(() {
        errorMessage = e.toString();
        print(errorMessage);
        isLoading = false;
      });
    }
  }

  // Future<List<Employee>> loadJsonFromAssets() async {
  //   final String response = await rootBundle.loadString('assets/data.json');
  //   final List<dynamic> data = jsonDecode(response);
  //
  //   // Convert each JSON object into an Employee
  //   employees = data.map((e) => Employee.fromJson(e)).toList();
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //   return employees;
  // }



//Employees active > 5 years and status = active are shown with a green background & text.
  bool isMoreThan5Years(DateTime joiningDate, String status) {
    final now = DateTime.now();
    final difference = now.difference(joiningDate).inDays ~/ 365;
    return difference > 5 && status == "active";
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee List"),actions: [
        IconButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const CreateEmployee(),
            ),
          );
          _loadEmployees();
        }, icon: Icon(Icons.add)),
      ], ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text("Error: $errorMessage"))
          : employees.isEmpty
          ? const Center(child: Text("No employees found"))
          : ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          final highlight =
          isMoreThan5Years(emp.joiningDate, emp.status);

          return Card(
            color: highlight
                ? Colors.green.shade100
                : emp.status== 'inactive'? Colors.red.shade100 : Colors.white,
            child: ListTile(
              title: Text(
                emp.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: highlight ? Colors.green : Colors.black,
                ),
              ),
              subtitle: Text(
                "${emp.position}\nJoined: ${DateFormat('yyyy-MM-dd').format(emp.joiningDate)}",
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
