import 'package:campuslostandfound/components/auth_google_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:blobs/blobs.dart' as blobs;

typedef FirestoreBlob = Blob;

class ItemDetailPage extends StatefulWidget {
  final String itemId;

  const ItemDetailPage({super.key, required this.itemId});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? itemData;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection("items").doc(widget.itemId).get();
      setState(() {
        itemData = docSnapshot.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double blobSize = screenHeight * 0.3;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Stack(
          children: [
            Positioned(
              top: -140,
              left: -60,
              child: blobs.Blob.fromID(
                id: ['18-6-103'],
                size: blobSize,
                styles: blobs.BlobStyles(
                  color: const Color(0xFFE0E6F6),
                ),
              ),
            ),
            Positioned(
              bottom: -160,
              left: screenWidth * 0.6,
              child: blobs.Blob.fromID(
                id: ['18-6-103'],
                size: blobSize,
                styles: blobs.BlobStyles(
                  color: const Color(0xFF002EB0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'lib/assets/icons/logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      body: itemData == null
          ? const Center(
              child: SpinKitChasingDots(
                color: Color(0xFF002EB0),
                size: 50.0,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  itemData?['imageUrl'] != null
                      ? (itemData?['imageUrl'] is List
                          ? Column(
                              children: (itemData?['imageUrl'] as List<dynamic>)
                                  .map(
                                    (url) => Image.network(
                                      url,
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const Center(
                                            child: SpinKitChasingDots(
                                              color: Color(0xFF002EB0),
                                              size: 50.0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                  .toList(),
                            )
                          : Image.network(
                              itemData?['imageUrl'],
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const Center(
                                    child: SpinKitChasingDots(
                                      color: Color(0xFF002EB0),
                                      size: 50.0,
                                    ),
                                  );
                                }
                              },
                            ))
                      : const Text('No Image Available'),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${itemData?['name'] ?? 'No Name'}',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF002EB0),
                                fontWeight: FontWeight.w600)),
                        Text(
                          '${itemData?['description'] ?? 'No Description'}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        RichText(
                          text: TextSpan(
                            text: 'Category: ',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002EB0),
                              fontFamily: 'Montserrat',
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${itemData?['category'] ?? 'No Category'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF002EB0),
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Location
                        RichText(
                          text: TextSpan(
                            text: 'Location: ',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002EB0),
                              fontFamily: 'Montserrat',
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${itemData?['location'] ?? 'No Location'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF002EB0),
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Time
                        RichText(
                          text: TextSpan(
                            text: 'Time: ',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002EB0),
                              fontFamily: 'Montserrat',
                            ),
                            children: [
                              TextSpan(
                                text: itemData?['time'] != null
                                    ? DateFormat('MM/dd/yyyy').format(
                                        (itemData?['time'] as Timestamp)
                                            .toDate())
                                    : 'No Date',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF002EB0),
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Is Claimed
                        RichText(
                          text: TextSpan(
                            text: 'Is Claimed: ',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002EB0),
                              fontFamily: 'Montserrat',
                            ),
                            children: [
                              TextSpan(
                                text: itemData?['isClaimed'] == true
                                    ? 'Claimed'
                                    : 'Not Claimed',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF002EB0),
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Status
                        RichText(
                          text: TextSpan(
                            text: 'Status: ',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002EB0),
                              fontFamily: 'Montserrat',
                            ),
                            children: [
                              TextSpan(
                                text: '${itemData?['status'] ?? 'No Status'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF002EB0),
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // Claim Button Section
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF002EB0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Claim",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
