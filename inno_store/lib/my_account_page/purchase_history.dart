import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PurchaseHistoryPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  PurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_history')
            .where('userId', isEqualTo: user?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
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
              var data = purchase.data() as Map<String, dynamic>?; // Cast the data to Map<String, dynamic>
              var items = List<Map<String, dynamic>>.from(data?['items'] ?? []);
              double totalPrice = data?['totalPrice'] ?? 0.0;
              var discounts = data != null && data.containsKey('discounts')
                  ? data['discounts'] as List<dynamic>
                  : []; // Default to empty list if null

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Purchase on ${data?['timestamp']?.toDate()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (discounts.isNotEmpty)
                        ...discounts.map((discount) {
                          return Text(
                            'Discount Applied: ${discount['voucher']} - Saved RM ${discount['amount'].toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.green),
                          );
                        }).toList(),
                      ...items.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> item = entry.value;
                        return Text('${index + 1}) ${item['title']} - RM ${item['price'].replaceAll('RM ', '')} x ${item['quantity']}');
                      }).toList(),
                    ],
                  ),
                  trailing: Text('Total: RM ${totalPrice.toStringAsFixed(2)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
