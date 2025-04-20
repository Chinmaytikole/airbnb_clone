import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // For ByteData

class ListingPage extends StatefulWidget {
  final String uid;

  const ListingPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedPropertyType = '';
  bool _acceptTerms = false;
  File? _image;
  bool _isLoading = false;
  String? userId;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Amenities
  Map<String, bool> amenities = {
    'Free WiFi': false,
    'Free Parking': false,
    'Gym': false,
    'Pet Friendly': false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = ModalRoute.of(context)?.settings.arguments as String? ?? widget.uid;
    print('ListingPage - User ID: $userId');

    // Initialize the Firestore document structure for this user
    _initializeUserDocument();
  }

  Future<void> _initializeUserDocument() async {
    try {
      // Check if a document with the userId already exists
      final querySnapshot = await _firestore
          .collection('rented_place')
          .where('user_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Create a new document with a random ID
        await _firestore.collection('rented_place').add({
          'user_id': userId,
          'HasRented': false,
          'SignIn_date': FieldValue.serverTimestamp(),
          'RentedPlace': {
            'Location': '',
            'title': '',
            'availability': {
              'start_date': '',
              'end_date': '',
            },
            'amenities': ['', '', '', ''],
            'images': ['', '', ''],
            'pricePerNight': 0,
            'description': '',
          },
          'bookings': {
            'amountpaid': '',
            'duration': '',
            'location': '',
            'placeid': '',
            'title': ''
          }
        });
      }
    } catch (e) {
      print('Error initializing user document: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Rent Your Place',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              color: const Color(0xFF00FFD9), // Bright turquoise color from image
              child: const Text(
                'Airbnbclone',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Input
                      const Text(
                        'Title',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter a descriptive title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Location Input
                      const Text(
                        'Location',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: 'Enter city, country',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Price Input
                      const Text(
                        'Enter price per night',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 16),

                      // Address Input
                      const Text(
                        'Enter address',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      // Amenities Section
                      const Text(
                        'Amenities',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Column(
                        children: amenities.keys.map((String key) {
                          return CheckboxListTile(
                            title: Text(key),
                            value: amenities[key],
                            onChanged: (bool? value) {
                              setState(() {
                                amenities[key] = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Photos
                      const Text(
                        'Add Photos',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Camera icon
                            IconButton(
                              icon: const Icon(Icons.camera_alt, size: 30),
                              onPressed: () => _getImage(ImageSource.camera),
                            ),
                            const SizedBox(width: 40),
                            // Upload icon
                            IconButton(
                              icon: const Icon(Icons.upload_outlined, size: 30),
                              onPressed: () => _getImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                      ),

                      // Show the selected image preview
                      if (_image != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Stack(
                              children: [
                                Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Property Type
                      const Text(
                        'What best describes your place',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      _buildPropertyTypeGrid(),

                      const SizedBox(height: 16),

                      // Terms and Conditions
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Do you accept '),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'terms and conditions',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Rent Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitListing,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FFD9),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                            'Rent this place',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              height: 20,
              color: const Color(0xFF00FFD9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeGrid() {
    final propertyTypes = ['House', 'Flat', 'Barn', 'Cabin', 'Beach', 'Pool'];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 2.0,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      children: propertyTypes.map((type) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPropertyType = type;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedPropertyType == type
                    ? const Color(0xFF00FFD9)
                    : Colors.grey.shade300,
                width: _selectedPropertyType == type ? 2 : 1,
              ),
              color: _selectedPropertyType == type
                  ? const Color(0xFFE6FFFC)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              type,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: _selectedPropertyType == type
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800, // Limit image size to reduce storage issues
      maxHeight: 800,
      imageQuality: 70, // Compress the image to reduce storage size
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to convert image to base64
  Future<String?> _getBase64Image() async {
    if (_image == null) return null;

    try {
      // Read the image file as bytes
      List<int> imageBytes = await _image!.readAsBytes();

      // Convert bytes to base64 encoded string
      String base64Image = base64Encode(imageBytes);

      return base64Image;
    } catch (e) {
      print('Error encoding image: $e');
      return null;
    }
  }

  // Method to submit listing to Firestore
  Future<void> _submitListing() async {
    final effectiveUserId = userId ?? widget.uid;

    if (effectiveUserId.isEmpty) {
      _showErrorDialog('User ID not available. Please log in again.');
      return;
    }

    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedPropertyType.isEmpty ||
        !_acceptTerms) {
      _showErrorDialog('Please fill in all required fields and accept terms and conditions.');
      return;
    }

    if (_image == null) {
      _showErrorDialog('Please select an image for your listing.');
      return;
    }

    int? pricePerNight;
    try {
      pricePerNight = int.parse(_priceController.text);
    } catch (e) {
      _showErrorDialog('Please enter a valid price.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String? base64Image = await _getBase64Image();

      if (base64Image == null || base64Image.isEmpty) {
        throw Exception('Failed to encode image');
      }

      if (base64Image.length > 500000) {
        _showErrorDialog('Image is too large. Please select a smaller image or reduce the quality.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      List<String> selectedAmenities = amenities.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Update the existing document with the listing information

        await _firestore.collection('rented_place').add({
          'user_id': effectiveUserId,
          'HasRented': true,
          'RentedPlace': {
            'title': _titleController.text,
            'Location': _locationController.text,
            'pricePerNight': pricePerNight,
            'description': _selectedPropertyType,
            'amenities': selectedAmenities,
            'images': [base64Image],
            'availability': {
              'start_date': DateTime.now().toIso8601String(),
              'end_date': DateTime.now().add(Duration(days: 365)).toIso8601String(),
            },
          }
        });


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your place is now listed!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error adding listing: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}