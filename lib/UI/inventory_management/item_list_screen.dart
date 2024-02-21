/*
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

*/

/*
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

  bool isSelecting = false;
  List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00),
        automaticallyImplyLeading: true,
        title: Text(isSelecting ? 'Select Items' : 'Items List'),
        centerTitle: true,
        actions: [
          if (!isSelecting) // Conditionally render select icon based on state
            IconButton(
              onPressed: () {
                setState(() {
                  isSelecting = true;
                });
              },
              icon: Icon(Icons.select_all),
            ),
          if (isSelecting) // Conditionally render close icon based on state
            IconButton(
              onPressed: () {
                setState(() {
                  isSelecting = false;
                  selectedIds.clear();
                });
              },
              icon: Icon(Icons.close),
            ),
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
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
      floatingActionButton: !isSelecting
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItem(machineId: widget.machineId),
            ),
          );
        },
            backgroundColor: Color(0xFFFFCC00),
            child: Icon(Icons.add),
      )
          : null, // Hide FloatingActionButton when selecting items
      bottomNavigationBar: isSelecting
          ? BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                deleteSelectedItems();
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      )
          : null, // Hide BottomAppBar when not selecting items
    );
  }

  void toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  Future<void> deleteSelectedItems() async {
    // Iterate over selectedIds and delete each item
    for (String id in selectedIds) {
      await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .delete();
    }
    setState(() {
      selectedIds.clear();
      isSelecting = false;
    });
  }

  List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String id = doc.id;
        String itemName = data['itemName'];
        String price = data['price'];
        String quantity = data['quantity'];
        bool isSelected = selectedIds.contains(id);

        return ListTile(
          onTap: () {
            if (isSelecting) {
              toggleSelection(id);
            }
          },
          title: Text(itemName),
          subtitle: Text('Price: $price, Quantity: $quantity'),
          trailing: isSelecting
              ? Checkbox(
            value: isSelected,
            onChanged: (_) {
              toggleSelection(id);
            },
          )
              : PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    showMyDialog(itemName, id, price, quantity);
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
                        .doc(id)
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
        return SizedBox();
      }
    }).toList();
  }

// showMyDialog() function remains the same as in your original code
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
}
*/

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

  bool isSelecting = false;
  List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00),
        automaticallyImplyLeading: true,
        title: Text(isSelecting ? 'Select Items' : 'Items List'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSelecting = !isSelecting; // Toggle isSelecting state
                selectedIds.clear(); // Clear selectedIds when toggling
              });
            },
            icon: Icon(isSelecting ? Icons.close : Icons.select_all),
          ),
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
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
           // return Center(child: CircularProgressIndicator());
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

      bottomNavigationBar: !isSelecting ? BottomAppBar(
        elevation: 0, // Decrease the elevation to remove shadow
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox( // Add SizedBox to control the size of FloatingActionButton
              width: 56, // Set width to adjust size
              height: 56, // Set height to adjust size
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem(machineId: widget.machineId)));
                },
                backgroundColor: Color(0xFFFFCC00),
                child: Icon(Icons.add),
                elevation: 0, // Decrease the elevation to remove shadow
                mini: true, // Set mini to true to decrease size
              ),
            ),
          ],
        ),
      ) : BottomAppBar(
        elevation: 0, // Decrease the elevation to remove shadow
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                deleteSelectedItems();
              },
              icon: Icon(Icons.delete),
              iconSize: 24, // Adjust the size of the icon
            ),
          ],
        ),
      ),
    );
  }

  void toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  Future<void> deleteSelectedItems() async {
    // Iterate over selectedIds and delete each item
    for (String id in selectedIds) {
      await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .delete().then((value) {
        Utils().toastMessage('Deleted Successfully');
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
      });
    }
    setState(() {
      selectedIds.clear();
      isSelecting = false;
    });
  }
/*
  List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String id = doc.id;
        String itemName = data['itemName'];
        String price = data['price'];
        String quantity = data['quantity'];
        bool isSelected = selectedIds.contains(id);

        return ListTile(
          onTap: () {
            if (isSelecting) {
              setState(() {
                if (isSelected) {
                  selectedIds.remove(id);
                } else {
                  selectedIds.add(id);
                }
              });
              //toggleSelection(id);
            }
          },
          title: Text(itemName),
          subtitle: Text('Price: $price, Quantity: $quantity'),
          trailing: isSelecting
              ? Checkbox(
            value: isSelected,
           // onChanged: (_) {
           //   toggleSelection(id);
           // },
            onChanged: (_) {
              setState(() {
                if (isSelected) {
                  selectedIds.remove(id);
                } else {
                  selectedIds.add(id);
                }
              });
            },
          )
              : PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    showMyDialog(itemName, id, price, quantity);
                  },
                  leading: Icon(Icons.edit),
                  title: Text('Update'),
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
                        .doc(id)
                        .delete().then((value) {
                      Utils().toastMessage('Deleted Successfully');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });;
                  },
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              )
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    }).toList();
  }
 */
  List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      // if (data != null) {
      //   String id = doc.id;
      //   String itemName = data['itemName'];
      //   String price = data['price'];
      //   String quantity = data['quantity'];
      //   String imageUrl = data['imageUrl']; // Added line to get image URL
      //   bool isSelected = selectedIds.contains(id);
      if (data != null) {
        String id = doc.id;
        String itemName = data['itemName'] ?? ''; // Add null check and default value
        String price = data['price'] ?? ''; // Add null check and default value
        String quantity = data['quantity'] ?? ''; // Add null check and default value
        String imageUrl = data['imageUrl']?? '';
        bool isSelected = selectedIds.contains(id);
        return ListTile(
          onTap: () {
            if (isSelecting) {
              setState(() {
                if (isSelected) {
                  selectedIds.remove(id);
                } else {
                  selectedIds.add(id);
                }
              });
              //toggleSelection(id);
            }
          },
          leading: imageUrl != null ? Image.network(imageUrl) : SizedBox(), // Added leading widget for image
          title: Text(itemName),
          subtitle: Text('Price: $price, Quantity: $quantity'),
          trailing: isSelecting
              ? Checkbox(
            value: isSelected,
            onChanged: (_) {
              setState(() {
                if (isSelected) {
                  selectedIds.remove(id);
                } else {
                  selectedIds.add(id);
                }
              });
            },
          )
              : PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    showMyDialog(itemName, id, price, quantity);
                  },
                  leading: Icon(Icons.edit),
                  title: Text('Update'),
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
                        .doc(id)
                        .delete().then((value) {
                      Utils().toastMessage('Deleted Successfully');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });;
                  },
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              )
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    }).toList();
  }

  // showMyDialog() function remains the same as in your original code

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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Edit Item Name'),
                    onChanged: (value) {
                      newTitle = value; // Update newTitle when the user changes the text
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) { // Trim leading and trailing whitespace
                        return 'Item name cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Edit Price'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) { // Trim leading and trailing whitespace
                        return 'Price cannot be empty';
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Edit Quantity'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) { // Trim leading and trailing whitespace
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
                 // Navigator.pop(context);
                  checkAndUpdateItem(id);
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void checkAndUpdateItem(String id) async {
    // Query Firestore to check if any document with the same itemName and price already exists
    var querySnapshot = await FirebaseFirestore.instance
        .collection('Machines')
        .doc(widget.machineId)
        .collection('items')
        .where('itemName', isEqualTo: nameController.text.trim().toUpperCase()) // Trim and convert to uppercase
        .where('price', isEqualTo: priceController.text.trim())
        .where('quantity', isEqualTo: quantityController.text.trim())// Trim price
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Utils().toastMessage('Item with the same name and price already exists');
    } else {

      // No document with the same itemName and price, proceed to update data
      FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .update({
        'itemName': nameController.text.trim().toUpperCase(), // Trim and convert to uppercase
        'price': priceController.text.trim(), // Trim price
        'quantity': quantityController.text.trim(),
      }).then((value) {
        Utils().toastMessage('Item Updated');
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
      });
      Navigator.pop(context);
    }
  }

}
/*
      floatingActionButton: !isSelecting ? FloatingActionButton(
             onPressed: () {
             Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItem(machineId: widget.machineId),
            ),
          );
        },
        backgroundColor: Color(0xFFFFCC00),
             child: Icon(Icons.add),
      ) : null, // Hide FloatingActionButton when selecting items
      bottomNavigationBar: isSelecting ? BottomAppBar(
               color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                   onPressed: () {
                   deleteSelectedItems();
              },
                    icon: Icon(Icons.delete),
            ),
          ],
        ),
      ) : null, // Hide BottomAppBar when not selecting items
       */
/*
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
                    'itemName': newTitle.trim().toUpperCase(),
                    'price': priceController.text.trim(),
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


   */