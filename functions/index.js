// functions/index.js

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.deleteSubcollectionOnDelete = functions.firestore
  .document('Machines/{machineId}')
  .onDelete(async (snap, context) => {
    const machineId = context.params.machineId;

    // Delete subcollection documents
    const subcollectionRef = admin.firestore().collection(`Machines/${machineId}/subcollection`);
    const subcollectionSnapshot = await subcollectionRef.get();
    const deletePromises = [];
    subcollectionSnapshot.forEach(doc => {
      deletePromises.push(doc.ref.delete());
    });

    // Wait for all deletions to complete
    await Promise.all(deletePromises);

    console.log('Subcollection documents deleted successfully.');
    return null;
  });
