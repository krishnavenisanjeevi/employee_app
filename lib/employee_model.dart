class Employee {
  final int id;
  final String name;
  final String position;
  final DateTime joiningDate;
  final String status;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.joiningDate,
    required this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      joiningDate: DateTime.parse(json['joining_date']),
      status: json['status'],
    );
  }
}
