import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'feedback_form_widget.dart';
import 'payment.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _currentIndex = 0;
  DateTime? checkin;
  DateTime? checkout;
  int guests = 1;
  bool termsAccepted = false;

  // Store the listing data
  Map<String, dynamic>? listingData;
  late List<dynamic> propertyImages;

  // Extract price as number from price string
  int getPriceValue() {
    if (listingData == null) return 0;

    String priceStr = listingData!['price'] ?? listingData!['pricePerNight'] ?? '0';
    // Extract numbers from the price string
    RegExp regExp = RegExp(r'(\d+)');
    Match? match = regExp.firstMatch(priceStr);
    if (match != null) {
      return int.tryParse(match.group(0) ?? '0') ?? 0;
    }
    return 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the listing data passed from HomePage
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (routeArgs != null) {
      // Store the full listing data
      listingData = routeArgs;

      // Initialize property images
      propertyImages = [];

      // Handle images data - could be a string or a list
      if (routeArgs['images'] != null) {
        if (routeArgs['images'] is String) {
          // Single image string
          propertyImages.add(routeArgs['images']);
        } else if (routeArgs['images'] is List) {
          // List of images
          propertyImages.addAll(routeArgs['images']);
        }
      }

      // Add placeholder images if we don't have any images
      if (propertyImages.isEmpty) {
        propertyImages.addAll([
          'https://via.placeholder.com/600x400?text=Beautiful+Apartment',
          'https://via.placeholder.com/600x400?text=Cozy+Living+Room',
          'https://via.placeholder.com/600x400?text=Modern+Kitchen',
          'https://via.placeholder.com/600x400?text=Spacious+Bedroom',
        ]);
      }
    } else {
      // Default if no data is passed
      propertyImages = [
        'https://via.placeholder.com/600x400?text=Beautiful+Apartment',
        'https://via.placeholder.com/600x400?text=Cozy+Living+Room',
        'https://via.placeholder.com/600x400?text=Modern+Kitchen',
        'https://via.placeholder.com/600x400?text=Spacious+Bedroom',
      ];
    }
  }

  // Widget to display image from various sources
  Widget _buildPropertyImage(dynamic imageSource, int index) {
    try {
      if (imageSource is String) {
        if (imageSource.startsWith('data:image')) {
          // Handle data URI format
          final parts = imageSource.split(',');
          if (parts.length == 2) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode(parts[1])),
                ),
              ),
            );
          }
        } else if (imageSource.startsWith('http')) {
          // Handle URL images
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageSource),
              ),
            ),
          );
        } else {
          // Try to decode as base64 directly
          try {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode(imageSource)),
                ),
              ),
            );
          } catch (e) {
            print('Error decoding base64: $e');
            // If not base64, fallback to placeholder
            return _buildPlaceholderImage();
          }
        }
      }

      // Fallback to placeholder
      return _buildPlaceholderImage();
    } catch (e) {
      print('Error displaying image: $e');
      return _buildBrokenImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade300,
      ),
      child: Center(
        child: Icon(Icons.image, size: 50, color: Colors.grey.shade700),
      ),
    );
  }

  Widget _buildBrokenImage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade300,
      ),
      child: Center(
        child: Icon(Icons.broken_image, size: 50, color: Colors.grey.shade700),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCheckin) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = isCheckin ? now : (checkin ?? now).add(Duration(days: 1));
    final DateTime firstDate = isCheckin ? now : (checkin ?? now);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF00FFD9),
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckin) {
          checkin = picked;
          if (checkout != null && checkout!.isBefore(picked)) {
            checkout = null;
          }
        } else {
          checkout = picked;
        }
      });
    }
  }

  void _showFeedbackForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: FeedbackFormWidget(
            onSubmit: (rating, feedback) {
              print('Rating: $rating, Feedback: $feedback');
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get property details with fallbacks
    final String propertyName = listingData?['place'] ?? listingData?['title'] ?? 'Beautiful Property';
    final String location = listingData?['Location'] ?? 'Location not specified';
    final String price = listingData?['price'] ?? '\$${listingData?['pricePerNight'] ?? '0'}/night';
    final double rating = double.tryParse('${listingData?['rating'] ?? listingData?['Rating'] ?? '4.5'}') ?? 4.5;
    final String description = listingData?['description'] ??
        "This stunning property offers breathtaking views and modern amenities. Perfect for a relaxing getaway.";

    // Get price value for calculations
    final int priceValue = getPriceValue();

    // Prepare amenities based on listing data if available
    List<Map<String, dynamic>> amenities = [];

    if (listingData != null && listingData!['amenities'] is List) {
      for (var amenity in listingData!['amenities']) {
        amenities.add({
          'icon': Icons.check_circle,
          'label': amenity.toString(),
        });
      }
    } else {
      // Default amenities
      amenities = [
        {'icon': Icons.wifi, 'label': 'Free WiFi'},
        {'icon': Icons.local_parking, 'label': 'Free Parking'},
        {'icon': Icons.pool, 'label': 'Pool'},
        {'icon': Icons.fitness_center, 'label': 'Gym'},
        {'icon': Icons.pets, 'label': 'Pet Friendly'},
      ];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Airbnb', style: TextStyle(color: Color(0xFF00FFD9), fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.feedback, color: Colors.black87),
            onPressed: _showFeedbackForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            Container(
              height: 280,
              child: PageView.builder(
                itemCount: propertyImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPropertyImage(propertyImages[index], index);
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  propertyImages.length,
                      (index) => Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Color(0xFF00FFD9)
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),

            // Property details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          propertyName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFF00FFD9), size: 18),
                          SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Divider(height: 32),

                  // Amenities
                  Text(
                    "Amenities",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: amenities.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(amenities[index]['icon'], color: Color(0xFF00FFD9)),
                              SizedBox(height: 8),
                              Text(
                                amenities[index]['label'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Divider(height: 32),

                  // Booking section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Book your stay",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context, true),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "CHECK-IN",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          checkin != null
                                              ? DateFormat('MMM dd, yyyy').format(checkin!)
                                              : "Add date",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: checkin != null
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context, false),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "CHECK-OUT",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          checkout != null
                                              ? DateFormat('MMM dd, yyyy').format(checkout!)
                                              : "Add date",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: checkout != null
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Select number of guests",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      ...List.generate(
                                        5,
                                            (index) => ListTile(
                                          title: Text("${index + 1} Guest${index > 0 ? 's' : ''}"),
                                          trailing: guests == index + 1
                                              ? Icon(Icons.check, color: Color(0xFF00FFD9))
                                              : null,
                                          onTap: () {
                                            setState(() {
                                              guests = index + 1;
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "GUESTS",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "$guests Guest${guests > 1 ? 's' : ''}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),

                          // Price calculation
                          if (checkin != null && checkout != null)
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("$price × ${checkout!.difference(checkin!).inDays} nights"),
                                      Text("\$${priceValue * checkout!.difference(checkin!).inDays}"),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Cleaning fee"),
                                      Text("\$50"),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Service fee"),
                                      Text("\$${(priceValue * checkout!.difference(checkin!).inDays * 0.12).round()}"),
                                    ],
                                  ),
                                  Divider(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "\$${priceValue * checkout!.difference(checkin!).inDays + 50 + (priceValue * checkout!.difference(checkin!).inDays * 0.12).round()}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Color(0xFF00FFD9),
                                value: termsAccepted,
                                onChanged: (value) {
                                  setState(() {
                                    termsAccepted = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "I agree to the ",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: "terms and conditions",
                                        style: TextStyle(
                                          color: Color(0xFF00FFD9),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00FFD9),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: (termsAccepted && checkin != null && checkout != null)
                                  ? () {
                                // Calculate the total amount
                                final int subtotal = priceValue * checkout!.difference(checkin!).inDays;
                                final int cleaningFee = 50;
                                final int serviceFee = (subtotal * 0.12).round();
                                final int totalAmount = subtotal + cleaningFee + serviceFee;

                                // Navigate to payment.dart when Reserve button is pressed
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      price: priceValue,
                                      nights: checkout!.difference(checkin!).inDays,
                                      cleaningFee: 50,
                                      serviceFeePercent: 0.12,
                                      checkInDate: checkin,
                                      checkOutDate: checkout,
                                      guestCount: guests,
                                      totalAmount: totalAmount,
                                    ),
                                  ),
                                );
                              }
                                  : null,
                              child: Text(
                                "Reserve",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Property description
                  Text(
                    "About this place",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.star_border, color: Color(0xFF00FFD9)),
                      label: Text(
                        "Rate & Review",
                        style: TextStyle(
                          color: Color(0xFF00FFD9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF00FFD9)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _showFeedbackForm,
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Use 0 instead of _currentIndex to avoid conflict with image carousel
        onTap: (index) {
          // Handle navigation bar taps
        },
        selectedItemColor: Color(0xFF00FFD9),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Wishlists"),
          BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: "Trips"),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}