import 'package:flutter/material.dart';
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
        isLoading = false;
      });
    }
  }

  //Employees active > 5 years and status = active are shown with a green background
  bool isMoreThan5Years(DateTime joiningDate, String status) {
    final now = DateTime.now();
    final difference = now.difference(joiningDate).inDays ~/ 365;
    return difference > 5 && status == "active";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text("Employee List"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 6,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        // ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const CreateEmployee(),
                ),
              );
              _loadEmployees();
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : errorMessage != null
          ? Center(
        child: Text(
          "Error: $errorMessage",
          style: const TextStyle(color: Colors.red),
        ),
      )
          : employees.isEmpty
          ? const Center(
        child: Text(
          "No employees found",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          final highlight =
          isMoreThan5Years(emp.joiningDate, emp.status);

          return Card(
            elevation: 4,
            shadowColor: Colors.purple.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: highlight
                ? Colors.green.shade100
                : emp.status == 'inactive'
                ? Colors.red.shade100
                : Colors.white,
            margin: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 4),
            child: ListTile(
              // contentPadding: const EdgeInsets.all(16),
              title: Text(
                emp.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: highlight
                      ? Colors.green.shade800
                      : Colors.purple.shade800,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "${emp.position}\nJoined: ${DateFormat('yyyy-MM-dd').format(emp.joiningDate)}",
                  style: const TextStyle(height: 1.3),
                ),
              ),
              // isThreeLine: true,

              ),
          );
        },
      ),
    );
  }
}
