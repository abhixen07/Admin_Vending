/*
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Trigger form validation
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
                      Navigator.pop(context); // Navigate back to previous screen
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                },
                */
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final fireStore = FirebaseFirestore.instance.collection('Machines');
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey<FormState>
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool loading = false;

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
        child: Form(
          // Wrap your form with Form widget
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


              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              const SizedBox(height: 10,),
              if (_imageFile != null)
                Text(' Image Selected Successfully')// Image.file(File(_imageFile!.path))
                else
                Text('No Image Selected Yet'),
              const SizedBox(height: 10,),


              RoundButton(
                title: 'ADD',
                loading: loading,
/*
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // Trigger form validation
                    setState(() {
                      loading = true;
                    });
                    String imageUrl = await uploadImage();
                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                    String machineName = machineController.text.trim().toUpperCase();
                    String location = locationController.text.trim().toUpperCase();

                    // Query Firestore to check if a document with the same machineName and location already exists
                    fireStore.where('machineName', isEqualTo: machineName).where('location', isEqualTo: location)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        // Document with the same machineName and location already exists
                        Utils().toastMessage('Machine with the same name and location already exists');
                        setState(() {
                          loading = false;
                        });
                      } else {
                        // No document with the same machineName and location, proceed to add new data
                        fireStore.doc(id).set({
                          'machineName': machineName,
                          'id': id,
                          'location': location,
                          'imageUrl': imageUrl,
                        }).then((value)
                        {
                          Utils().toastMessage('Added Successfully');
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context); // Navigate back to previous screen
                        })
                            .onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    })
                        .catchError((error) {
                      Utils().toastMessage('Error: $error');
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                },

 */
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_imageFile == null) {
                      // Display an error message if no image is selected
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please select an image before adding data.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return; // Stop execution if no image is selected
                    }

                    // Continue with data addition process if an image is selected
                    setState(() {
                      loading = true;
                    });
                    String imageUrl = await uploadImage();
                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                    String machineName = machineController.text.trim().toUpperCase();
                    String location = locationController.text.trim().toUpperCase();

                    // Query Firestore to check if a document with the same machineName and location already exists
                    fireStore.where('machineName', isEqualTo: machineName).where('location', isEqualTo: location)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        // Document with the same machineName and location already exists
                        Utils().toastMessage('Machine with the same name and location already exists');
                        setState(() {
                          loading = false;
                        });
                      } else {
                        // No document with the same machineName and location, proceed to add new data
                        fireStore.doc(id).set({
                          'machineName': machineName,
                          'id': id,
                          'location': location,
                          'imageUrl': imageUrl,
                        }).then((value) {
                          Utils().toastMessage('Added Successfully');
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context); // Navigate back to the previous screen
                        }).onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    }).catchError((error) {
                      Utils().toastMessage('Error: $error');
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
/*
  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }


 */
  Future<String> uploadImage() async {
    if (_imageFile != null) {
      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance.ref('images/${DateTime.now().millisecondsSinceEpoch}').putFile(File(_imageFile!.path));
        return await snapshot.ref.getDownloadURL();
      } catch (error) {
        throw error;
      }
    } else {
      throw 'No image selected';
    }
  }
  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    } else {
      // Display an error message if no image is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No image selected! Please select an image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


}




