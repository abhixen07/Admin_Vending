import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kotlin/UI/auth/login_screen.dart';
import 'package:kotlin/UI/machine_management/add_firestore_data.dart';
import 'package:kotlin/utils/utils.dart';

class fireStoreScreen extends StatefulWidget {
  const fireStoreScreen({Key? key});

  @override
  State<fireStoreScreen> createState() => _fireStoreScreenState();
}

class _fireStoreScreenState extends State<fireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final locationController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Machines').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Machines');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00), // Set your desired color here
        automaticallyImplyLeading: true,
        title: const Text('Machines Management'),
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
      body: Column(
        children: [
          const SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data found'));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index) {
                    String machineName = snapshot.data!.docs[index]['machineName'].toString();
                    String location = snapshot.data!.docs[index]['location'].toString();
                    String id = snapshot.data!.docs[index]['id'].toString();
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['machineName'].toString()),
                      subtitle: Text('location:${snapshot.data!.docs[index]['location'].toString()}'),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value:1,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(machineName, id, location);
                              },
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          PopupMenuItem(
                            value:1,
                            child: ListTile(
                              onTap: () async {
                                Navigator.pop(context);
                                await deleteDocumentAndSubcollection(id);
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddFirestoreDataScreen()));
        },
        backgroundColor: Color(0xFFFFCC00), // Set the background color here
        child: Icon(Icons.add),
      ),

    );
  }

  Future<void> showMyDialog(String title, String id, String loc) async {
    editController.text = title;
    locationController.text = loc;
    String newTitle = title;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                    controller: editController,
                    decoration: InputDecoration(hintText: 'Edit Machine Name'),
                    onChanged: (value) {
                      newTitle = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Machine name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(hintText: 'Edit Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Location cannot be empty';
                      }
                      return null;
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
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ref.doc(id).update({
                    'machineName': newTitle.toLowerCase(),
                    'location': locationController.text,
                  }).then((value) {
                    Utils().toastMessage('Updated Successfully');
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

  Future<void> deleteDocumentAndSubcollection(String documentId) async {
    // Delete subcollection documents
    await FirebaseFirestore.instance
        .collection('Machines')
        .doc(documentId)
        .collection('subcollection')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    });

    // Delete parent document
    await FirebaseFirestore.instance.collection('Machines').doc(documentId).delete();
  }
}