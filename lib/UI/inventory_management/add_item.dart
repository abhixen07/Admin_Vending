/*
  void addSubCollection(String machineId) {
    String subDocId = DateTime.now().millisecondsSinceEpoch.toString(); // Generate timestamp-based document ID

    FirebaseFirestore.instance
        .collection('Machines') // Parent collection
        .doc(machineId) // Reference to the specific document (machine)
        .collection('items') // Sub-collection name
        .doc(subDocId) // Document ID within sub-collection
        .set({
      // Data to be added to the sub-collection document
      'itemName': itemController.text.toString(),

      'quantity': quantityController.text.toString(),
      'price': priceController.text.toString(),

      // Add other fields as needed
      'id': subDocId, // Store document ID as a field
    })
        .then((value) {
      Utils().toastMessage('Added Successfully');
      setState(() {
        loading = false;

      });
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
 */
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotlin/UI/widgets/round_button.dart';
import 'package:kotlin/utils/utils.dart';


class AddItem extends StatefulWidget {
  final String machineId;
  const AddItem({Key? key, required this.machineId}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  final itemController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final fireStore =FirebaseFirestore.instance.collection('Machines');
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey<FormState>
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool loading=false;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00), // Set your desired color here
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form( // Wrap your form with Form widget
          key: _formKey, // Set key to the GlobalKey<FormState>
          child: Column(
            children: [
              const SizedBox(height: 30,),
              TextFormField(
                maxLines: 1,
                controller: itemController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: Icon(Icons.receipt),
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
                    return 'Item name cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: InputDecoration(
                labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money_outlined),

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
                    return 'Price cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  prefixIcon: Icon(Icons.format_list_numbered),
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
                    return 'Quantity cannot be empty';
                  }
                  return null; // Return null if the validation passes
                },
              ),
              const SizedBox(height: 18,),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              const SizedBox(height: 8,),
              if (_imageFile != null)
                Text(' Image Selected Successfully')// Image.file(File(_imageFile!.path))
              else
                Text('No Image Selected Yet'),
              const SizedBox(height: 8,),
              RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) { // Trigger form validation
                    setState(() {
                      loading = true;
                    });
                    addSubCollection( widget.machineId);

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
  void addSubCollection(String machineId) {
    String itemName = itemController.text.trim().toUpperCase();
    String price = priceController.text.trim();

    // Query Firestore to check if any document with the same itemName and price already exists
    FirebaseFirestore.instance
        .collection('Machines')
        .doc(machineId)
        .collection('items')
        .where('itemName', isEqualTo: itemName)
        .where('price', isEqualTo: price)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Document with the same itemName and price already exists
        Utils().toastMessage('Item with the same name and price already exists');
        setState(() {
          loading = false;
        });
      } else {
        // No document with the same itemName and price, proceed to add data
        String subDocId = DateTime.now().millisecondsSinceEpoch.toString();

        FirebaseFirestore.instance
            .collection('Machines') // Parent collection
            .doc(machineId) // Reference to the specific document (machine)
            .collection('items') // Sub-collection name
            .doc(subDocId) // Document ID within sub-collection
            .set({
          // Data to be added to the sub-collection document
          'itemName': itemName,
          'quantity': quantityController.text.trim(),
          'price': price,
          // Add other fields as needed
          'id': subDocId, // Store document ID as a field
        })
            .then((value) {
          Utils().toastMessage('Added Successfully');
          setState(() {
            loading = false;
          });
          Navigator.pop(context);
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

 */
  //2nd
/*
  void addSubCollection(String machineId) async {
    if (_imageFile == null) {
      setState(() {
        loading = false;
      });
      // Utils().toastMessage('Please select an image');
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


      return;
    }

    try {
      setState(() {
        loading = true;
      });

      String itemName = itemController.text.trim().toUpperCase();
      String price = priceController.text.trim();
      String quantity = quantityController.text.trim();

      // Upload image to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('images/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(File(_imageFile!.path));

      // Get download URL of the uploaded image
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Add item data to Firestore subcollection
      String subDocId = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance
          .collection('Machines')
          .doc(machineId)
          .collection('items')
          .doc(subDocId)
          .set({
        'itemName': itemName,
        'quantity': quantity,
        'price': price,
        'imageUrl': imageUrl, // Store image URL
        'id': subDocId,
      });

      Utils().toastMessage('Added Successfully');
      Navigator.pop(context);
    } catch (error) {
      Utils().toastMessage(error.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

 */
//3rd
  void addSubCollection(String machineId) async {
    String itemName = itemController.text.trim().toUpperCase();
    String price = priceController.text.trim();

    // try {
    //   // Validate image selection
    //   if (_imageFile == null) {
    //     throw 'Please select an image';
    //   }
    if (_imageFile == null) {
      setState(() {
        loading = false;
      });
      // Utils().toastMessage('Please select an image');
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


      return;
    }

    try {
      setState(() {
        loading = true;
      });

      // Upload image to Firebase Storage
      String imageUrl = await uploadImage();

      // Check if an item with the same name and price already exists
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(machineId)
          .collection('items')
          .where('itemName', isEqualTo: itemName)
          .where('price', isEqualTo: price)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Utils().toastMessage('Item with the same name and price already exists');
        setState(() {
          loading = false;
        });
      } else {
        // No duplicate item found, proceed to add data
        String subDocId = DateTime.now().millisecondsSinceEpoch.toString();

        // Add item data to Firestore
        await FirebaseFirestore.instance
            .collection('Machines')
            .doc(machineId)
            .collection('items')
            .doc(subDocId)
            .set({
          'itemName': itemName,
          'quantity': quantityController.text.trim(),
          'price': price,
          'imageUrl': imageUrl, // Add imageUrl to item data
          'id': subDocId,
        });

        Utils().toastMessage('Added Successfully');
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      }
    } catch (error) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    }
  }

  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }
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
}


