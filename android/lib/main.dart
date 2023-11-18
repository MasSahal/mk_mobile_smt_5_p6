import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[400],
        hintColor: Colors.green[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Latihan Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _visible = false;
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future userLogin() async {
    String url = "http://localhost/kuliah/mk_mobile_smt_5/server_p6/auth.php";
    setState(() {
      _visible = true;
    });

    var data = {
      'username': userController.text,
      'password': passController.text,
    };

    try {
      var response = await http.post(Uri.parse(url), body: json.encode(data));

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.body);
        if (msg['loginStatus'] == true) {
          setState(() {
            _visible = false;
          });

          var userInfo = msg['userInfo'];
          if (userInfo != null) {
            var userName = userInfo['full_name'];

            Future.delayed(Duration.zero, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(fullName: userName),
                ),
              );
            });
          } else {
            showMessage("Invalid user information");
          }
        } else {
          setState(() {
            _visible = false;
            showMessage(msg["message"]);
          });
        }
      } else {
        setState(() {
          _visible = false;
          showMessage(
              "Error during connecting to Server. Status Code: ${response.statusCode}");
        });
      }
    } catch (e) {
      print('Error: $e'); // Print the error for debugging
      setState(() {
        _visible = false;
        showMessage("Error during connecting to Server: $e");
      });
    }
  }

  Future<dynamic> showMessage(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: _visible,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: const LinearProgressIndicator(),
                ),
              ),
              Container(
                height: 100.0,
              ),
              Icon(
                Icons.group,
                color: Theme.of(context).primaryColor,
                size: 80.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Login Here',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Theme(
                        data: ThemeData(
                          primaryColor: const Color.fromRGBO(84, 87, 90, 0.5),
                          primaryColorDark:
                              const Color.fromRGBO(84, 87, 90, 0.5),
                          hintColor: const Color.fromRGBO(
                              84, 87, 90, 0.5), //placeholdercolor
                        ),
                        child: TextFormField(
                          controller: userController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                                style: BorderStyle.solid,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                                style: BorderStyle.solid,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            labelText: 'Enter User Name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                                style: BorderStyle.solid,
                              ),
                            ),
                            hintText: 'User Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter User Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: const Color.fromRGBO(84, 87, 90, 0.5),
                          primaryColorDark:
                              const Color.fromRGBO(84, 87, 90, 0.5),
                          hintColor: const Color.fromRGBO(
                              84, 87, 90, 0.5), //placeholdercolor
                        ),
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                                style: BorderStyle.solid,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                                style: BorderStyle.solid,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(84, 87, 90, 0.5),
                                style: BorderStyle.solid,
                              ),
                            ),
                            labelText: 'Enter Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                            ),
                            hintText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              userLogin();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
