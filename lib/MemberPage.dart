import 'package:flutter/material.dart';
import 'package:akses/main.dart'; // Import halaman login

class MemberPage extends StatelessWidget {
  final String? username; // Tambahkan username agar konsisten dengan AdminPage

  MemberPage({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Member")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello, ${username ?? 'Member'}!",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Arahkan kembali ke halaman login saat logout
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                  (Route<dynamic> route) =>
                      false, // Hapus semua halaman sebelumnya
                );
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
