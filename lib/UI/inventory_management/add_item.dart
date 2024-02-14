import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  bool loading=false;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffcc00), // Set your desired color here
        title: const Text('Add New Item'),
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
              const SizedBox(height: 30,),
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
              ),const SizedBox(height: 30,),
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
              const SizedBox(height: 30,),
              RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) { // Trigger form validation
                    setState(() {
                      loading = true;
                    });



                    // fireStore.doc(i_id).set({

                    addSubCollection( widget.machineId);

                   //addDataToSubCollection();
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
  String i_id = DateTime.now().millisecondsSinceEpoch.toString();
  Future<void> addDataToSubCollection() {
    return subCollection.add({
      'itemName': itemController.text.toString(),
      'i_id': i_id,
      'quantity': quantityController.text.toString(),
      'price': priceController.text.toString(),

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
    }); }
*/
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
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }



}

