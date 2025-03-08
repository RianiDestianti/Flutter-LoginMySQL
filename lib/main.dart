import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:akses/AdminPage.dart'; // Sesuaikan dengan lokasi file
import 'package:akses/MemberPage.dart'; // Sesuaikan dengan lokasi file
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login PHP MySQL',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  String msg = '';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/my_store/login.php"),
      body: {"username": user.text, "password": pass.text},
    );

    var datauser = json.decode(response.body);

    if (datauser.length == 0) {
      setState(() {
        msg = "Login Failed";
      });
    } else {
      String username = datauser[0]['username'];

      if (datauser[0]['level'] == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(username: username),
          ),
        );
      } else if (datauser[0]['level'] == 'member') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemberPage(username: username),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Username", style: TextStyle(fontSize: 18.0)),
            TextField(
              controller: user,
              decoration: InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text("Password", style: TextStyle(fontSize: 18.0)),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () async {
                await _login();
              },
            ),
            SizedBox(height: 10),
            Text(msg, style: TextStyle(fontSize: 20.0, color: Colors.red)),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("Belum punya akun? Register"),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================
//          REGISTER PAGE
// ============================
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  String level = "member"; // Default level
  String msg = '';

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/my_store/register.php"),
      body: {"username": user.text, "password": pass.text, "level": level},
    );

    var data = json.decode(response.body);

    if (data['status'] == "success") {
      setState(() {
        msg = "Registrasi Berhasil!";
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Kembali ke halaman login
      });
    } else {
      setState(() {
        msg = "Registrasi Gagal!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Username", style: TextStyle(fontSize: 18.0)),
            TextField(
              controller: user,
              decoration: InputDecoration(
                hintText: 'Masukkan Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text("Password", style: TextStyle(fontSize: 18.0)),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Masukkan Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: level == "admin",
                  onChanged: (bool? value) {
                    setState(() {
                      level = value! ? "admin" : "member";
                    });
                  },
                ),
                Text("Daftar sebagai Admin"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Register"),
              onPressed: () async {
                await _register();
              },
            ),
            Text(msg, style: TextStyle(fontSize: 20.0, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
