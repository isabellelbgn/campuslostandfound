import 'package:campuslostandfound/components/item_carousel.dart';
import 'package:campuslostandfound/components/items_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
        appBar: ItemsAppBar(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'lib/assets/icons/logo.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
          ),
          onBackButtonPressed: () => Navigator.of(context).pop(),
        ),
        body: itemData == null
            ? const Center(
                child: SpinKitChasingDots(
                  color: Color(0xFF002EB0),
                  size: 50.0,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image Carousel
                      itemData?['imageUrl'] != null
                          ? (itemData?['imageUrl'] is List
                              ? ItemCarousel(
                                  imageUrls:
                                      List<String>.from(itemData?['imageUrl']),
                                )
                              : ItemCarousel(
                                  imageUrls: [itemData?['imageUrl']],
                                ))
                          : const Text('No Image Available'),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${itemData?['name'] ?? 'No Name'}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF002EB0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // IsClaimed
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: itemData?['isClaimed'] == true
                                          ? const Color(0xFF2EB000)
                                          : const Color(0xFFB0002E),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      itemData?['isClaimed'] == true
                                          ? 'Claimed'
                                          : 'Unclaimed',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFCCD5EF),
                                    ),
                                    child: Text(
                                      '${itemData?['category'] ?? 'No Unassigned'}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF002EB0),
                                      ),
                                    ),
                                  ),
                                ]),
                            const SizedBox(height: 20),
                            const Text(
                              'Additional Description',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002EB0),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${itemData?['description'] ?? 'No Description'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF525660),
                              ),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              size: 16,
                                              color: Color(0xFF002EB0)),
                                          SizedBox(width: 4),
                                          Text(
                                            'Location',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF002EB0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${itemData?['location'] ?? 'No Location'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF525660),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 16,
                                              color: Color(0xFF002EB0)),
                                          SizedBox(width: 4),
                                          Text(
                                            'Date',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF002EB0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        itemData?['time'] != null
                                            ? DateFormat('MM/dd/yyyy').format(
                                                (itemData?['time'] as Timestamp)
                                                    .toDate())
                                            : 'No Date',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF525660),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Status
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002EB0),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              '${itemData?['status'] ?? 'No Status'}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF525660),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // Claim Button
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
              ));
  }
}
