import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PurchaseHistoryPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Debug statement to print the current user details
    print('Current user UID: ${user?.uid}');
    print('Current user displayName: ${user?.displayName}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_history')
            .where('userId', isEqualTo: user?.uid) // Query by userId
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            // Print the error for debugging
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No purchase history available.'),
            );
          }

          var purchaseHistory = snapshot.data!.docs;

          return ListView.builder(
            itemCount: purchaseHistory.length,
            itemBuilder: (context, index) {
              var purchase = purchaseHistory[index];
              var items = List<Map<String, dynamic>>.from(purchase['items']);

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Purchase on ${purchase['timestamp'].toDate()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items
                        .map((item) => Text('${item['title']} - ${item['price']}'))
                        .toList(),
                  ),
                  trailing: Text('Total: RM ${purchase['totalPrice'].toStringAsFixed(2)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
