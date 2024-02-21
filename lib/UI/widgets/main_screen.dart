import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kotlin/UI/auth/login_screen.dart';
import 'package:kotlin/UI/inventory_management/select_machine_for_item.dart';
import 'package:kotlin/UI/machine_management/firestore_list_screen.dart';
import 'package:kotlin/utils/utils.dart';

class ManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final auth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: Color(0xfE7E7E7FF),
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00), // Set your desired color here
        automaticallyImplyLeading: false,
        title: Text('Management Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 10,),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
            onPressed: () {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FireStoreScreen()),
      );
      },
              style: ElevatedButton.styleFrom(
                primary: Color(0xffffcc00),
                //textStyle: TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set to zero for a rectangle
                ),
              ),
        child: Text(
          'MANAGE MACHINES',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => selectMachineForItems()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xffffcc00),
                //textStyle: TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set to zero for a rectangle
                ),
              ),
              child: Text(
                'MANAGE INVENTORY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
