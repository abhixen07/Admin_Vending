import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kotlin/UI/auth/login_screen.dart';
import 'package:kotlin/UI/inventory_management/add_item.dart';
import 'package:kotlin/utils/utils.dart';

class itemListScreen extends StatefulWidget {
  final String machineId;
  itemListScreen({required this.machineId});

  @override
  State<itemListScreen> createState() => _itemListScreenState();
}

class _itemListScreenState extends State<itemListScreen> {

  final auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00), // Set your desired color here
        automaticallyImplyLeading: true,
        title: const Text('Items List'),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Machines')
            .doc(widget.machineId)
            .collection('items')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
          return ListView(
            children: buildListTilesFromSubcollection(snapshot.data!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItem(machineId: widget.machineId),
            ),
          );
        },
        backgroundColor: Color(0xFFFFCC00), // Set the background color here
        child: Icon(Icons.add),
      ),
    );
  }
 /*
  Future<void> showMyDialog(String name, String id, String price,String quantity) async {
    nameController.text = name;
    priceController.text = price;
    quantityController.text = quantity;
    String newTitle = name; // Initialize newTitle with the current title
    GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add GlobalKey<FormState> for form validation
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: Form( // Wrap the content with a Form widget
              key: formKey, // Set the key to the GlobalKey<FormState>
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Edit Item Name'),
                    onChanged: (value) {
                      newTitle = value; // Update newTitle when the user changes the text
                    },
                    validator: (value) { // Add validator for machine name
                      if (value == null || value.isEmpty) {
                        return 'Item name cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(hintText: 'Edit Price'),
                    validator: (value) { // Add validator for location
                      if (value == null || value.isEmpty) {
                        return 'Price cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(hintText: 'Edit Quantity'),
                    validator: (value) { // Add validator for location
                      if (value == null || value.isEmpty) {
                        return 'Quantity cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) { // Trigger form validation
                  Navigator.pop(context);

                  ref.doc(id).update({
                    'itemName': newTitle.toLowerCase(),
                    'price': priceController.text,
                    'quantity': quantityController.text,

                  }).then((value) {
                    Utils().toastMessage('Post Updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  */
  Future<void> showMyDialog(String name, String id, String price, String quantity) async {
    nameController.text = name;
    priceController.text = price;
    quantityController.text = quantity;
    String newTitle = name; // Initialize newTitle with the current title
    GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add GlobalKey<FormState> for form validation
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: Form( // Wrap the content with a Form widget
              key: formKey, // Set the key to the GlobalKey<FormState>
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Edit Item Name'),
                    onChanged: (value) {
                      newTitle = value; // Update newTitle when the user changes the text
                    },
                    validator: (value) { // Add validator for machine name
                      if (value == null || value.isEmpty) {
                        return 'Item name cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  TextFormField(
                    controller: priceController,

                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Edit Price'),
                    validator: (value) { // Add validator for location
                      if (value == null || value.isEmpty) {
                        return 'Price cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  TextFormField(
                    controller: quantityController,

                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Edit Quantity'),
                    validator: (value) { // Add validator for location
                      if (value == null || value.isEmpty) {
                        return 'Quantity cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) { // Trigger form validation
                  Navigator.pop(context);

                  FirebaseFirestore.instance
                      .collection('Machines')
                      .doc(widget.machineId)
                      .collection('items')
                      .doc(id)
                      .update({
                    'itemName': newTitle.toLowerCase(),
                    'price': priceController.text,
                    'quantity': quantityController.text,
                  }).then((value) {
                    Utils().toastMessage('Item Updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String itemName = data['itemName'];
        String price = data['price'];
        String quantity = data['quantity'];

        return ListTile(
          title: Text(itemName),
          subtitle: Text('Price: $price, Quantity: $quantity'),
          trailing: PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    showMyDialog(itemName, doc.id, price,quantity); // Pass item details to the dialog
                  },
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    FirebaseFirestore.instance
                        .collection('Machines')
                        .doc(widget.machineId)
                        .collection('items')
                        .doc(doc.id)
                        .delete();
                  },
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              )
            ],
          ),
        );
      } else {
        return SizedBox(); // Return an empty SizedBox if data is null
      }
    }).toList();
  }
}
