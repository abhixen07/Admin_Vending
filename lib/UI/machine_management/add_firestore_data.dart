import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kotlin/UI/widgets/round_button.dart';
import 'package:kotlin/utils/utils.dart';
class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  final machineController = TextEditingController();
  final locationController = TextEditingController();
  final fireStore =FirebaseFirestore.instance.collection('Machines');
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey<FormState>
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00), // Set your desired color here
        title: const Text('Add New Machine'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form( // Wrap your form with Form widget
          key: _formKey, // Set key to the GlobalKey<FormState>
          child: Column(
            children: [
              const SizedBox(height: 30,),
              TextFormField(
                maxLines: 1,
                controller: machineController,
                decoration: InputDecoration(
                  labelText: 'Machine Name',
                  prefixIcon: Icon(Icons.storefront_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Machine name cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
              ),
              const SizedBox(height: 30,),
              TextFormField(
                maxLines: 1,
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on_outlined),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Location cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
              ),
              const SizedBox(height: 30,),
              RoundButton(
                title: 'ADD',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) { // Trigger form validation
                    setState(() {
                      loading = true;
                    });

                    String id = DateTime.now().millisecondsSinceEpoch.toString();

                    fireStore.doc(id).set({
                      'machineName': machineController.text.toString(),
                      'id': id,
                      'location': locationController.text.toString(),
                    }).then((value) {
                      Utils().toastMessage('Added Successfully');
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                },
                buttonColor: Color(0xFFFFCC00), // Set your desired color here
              ),
            ],
          ),
        ),
      ),
    );
  }
}
