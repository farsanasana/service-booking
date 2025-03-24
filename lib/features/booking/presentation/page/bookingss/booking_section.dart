import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailedPage extends StatefulWidget {
  final Map<String, dynamic> booking;
  
  const DetailedPage({Key? key, required this.booking}) : super(key: key);
  
  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  TextEditingController reviewController = TextEditingController();
  double rating = 5.0;
  String username = 'Unknown';
  String imageUrl = 'default_image_url';
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Get current authenticated user
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser != null) {
        // If displayName is available directly, use it
        if (currentUser.displayName != null) {
          username = currentUser.displayName!;
          imageUrl = currentUser.photoURL ?? 'default_image_url';
        } else {
          // Otherwise fetch user data from Firestore users collection
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
          
          if (userDoc.exists) {
            final userData = userDoc.data();
            username = userData?['displayName'] ?? userData?['username'] ?? 'Unknown';
            imageUrl = userData?['photoURL'] ?? userData?['imageUrl'] ?? 'default_image_url';
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.booking['serviceName'] ?? "Unknown Service",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Service Provider: ${widget.booking['serviceProviderName'] ?? 'N/A'}"),
                  Text("Booking Date: ${widget.booking['bookingDate'] ?? 'Unknown'}"),
                  Text("Status: ${widget.booking['bookingStatus'] ?? 'Pending'}"),
                  const SizedBox(height: 20),
                  const Text("Add a Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Posting as: $username", style: TextStyle(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your review here...",
                    ),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (newRating) {
                      rating = newRating;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (reviewController.text.isNotEmpty) {
                        try {
                          // Get current user ID
                          String? userId = FirebaseAuth.instance.currentUser?.uid;
                          
                          // Create review document
                          await FirebaseFirestore.instance.collection('reviews').add({
                            'bookingId': widget.booking['id'],
                            'userId': userId,
                            'username': username,
                            'imageUrl': imageUrl,
                            'review': reviewController.text,
                            'rating': rating,
                            'serviceProviderName': widget.booking['serviceProviderName'],
                            'timestamp': Timestamp.now(),
                            'date': Timestamp.now(),
                          });
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Review Submitted!")),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error submitting review: $e")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please write a review before submitting")),
                        );
                      }
                    },
                    child: const Text("Submit Review"),
                  ),
                ],
              ),
            ),
    );
  }
}