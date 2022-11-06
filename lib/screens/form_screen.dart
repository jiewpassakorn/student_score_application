import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/student.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  //controller
  final fnameController = TextEditingController(); //รับค่าชื่อ
  final lnameController = TextEditingController(); //รับค่านาสกุล
  final emailController = TextEditingController(); //รับค่า e-mail
  final scoreController = TextEditingController(); //รับค่าคะแนน

  CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection("students");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
            ),
            body: Center(child: Text("${snapshot.error}")),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Form"),
              backgroundColor: Colors.green,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration:
                            new InputDecoration(labelText: "First Name"),
                        controller: fnameController,
                        validator: RequiredValidator(
                            errorText: "Please enter your first name"),
                      ),
                      TextFormField(
                        decoration: new InputDecoration(labelText: "Last Name"),
                        controller: lnameController,
                        validator: RequiredValidator(
                            errorText: "Please enter your last name"),
                      ),
                      TextFormField(
                        decoration: new InputDecoration(labelText: "E-mail"),
                        controller: emailController,
                        validator: MultiValidator([
                          EmailValidator(
                              errorText: "Please fill the e-mail fommat"),
                          RequiredValidator(
                              errorText: "Please enter your email"),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        decoration: new InputDecoration(labelText: "Score"),
                        controller: scoreController,
                        validator: RequiredValidator(
                            errorText: "Please enter your score"),
                        keyboardType: TextInputType.number,
                      ),
                      ElevatedButton(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text("Comfirm"),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              var fname = fnameController.text;
                              var lname = lnameController.text;
                              var email = emailController.text;
                              var score = scoreController.text;

                              Student statement = Student(
                                  fname: fname,
                                  lname: lname,
                                  email: email,
                                  score: score);

                              print(statement.fname);
                              print(statement.lname);
                              print(statement.email);
                              print(statement.score);
                              await _studentCollection.add({
                                "fname": statement.fname,
                                "lname": statement.lname,
                                "email": statement.email,
                                "score": statement.score,
                              });
                              formKey.currentState!.reset();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
