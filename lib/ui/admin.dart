import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmployeeList(),
    );
  }
}

class Employee {
  final String name;
  final int age;
  final String imageUrl;

  Employee({required this.name, required this.age, required this.imageUrl});
}

class EmployeeList extends StatelessWidget {
  final List<Employee> employees = [
    Employee(name: 'Nguyễn Văn A', age: 25, imageUrl: 'https://via.placeholder.com/150'),
    Employee(name: 'Trần Thị B', age: 30, imageUrl: 'https://via.placeholder.com/150'),
    Employee(name: 'Lê Minh C', age: 28, imageUrl: 'https://via.placeholder.com/150'),
    // Thêm các nhân viên khác vào đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách nhân viên')),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(employee.imageUrl),
            ),
            title: Text(employee.name),
            subtitle: Text('Tuổi: ${employee.age}'),
          );
        },
      ),
    );
  }
}
