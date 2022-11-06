import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/models/student.dart';

class StudentProvider with ChangeNotifier {
  List<Student> Students = [];

  List<Student> getStudent() => Students;
}
