import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'employee_model.dart';
import 'employee_service.dart';

class CreateEmployee extends StatefulWidget {
  const CreateEmployee({super.key});

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _name = TextEditingController();
  final _position = TextEditingController();
  String _status = 'active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text("Add Employee"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Employee Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _id,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        prefixIcon: Icon(Icons.badge, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter ID' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _position,
                      decoration: InputDecoration(
                        labelText: 'Position',
                        prefixIcon: Icon(Icons.work, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter position' : null,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(
                        labelText: "Status",
                        prefixIcon:
                        Icon(Icons.toggle_on, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ["active", "inactive"]
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String formattedDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());

                            Employee employee = Employee(
                              id: int.parse(_id.text),
                              name: _name.text,
                              position: _position.text,
                              joiningDate: DateTime.parse(formattedDate),
                              status: _status,
                            );

                            final emp =
                            await ApiService.createEmployee(employee);
                            print("Employee linked: ${emp.name}");

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          "Add Employee",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
