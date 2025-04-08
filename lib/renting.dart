import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnbclone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ListingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListingPage extends StatefulWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedPropertyType = '';
  bool _acceptTerms = false;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              color: Color(0xFF00FFD8), // Bright turquoise color from image
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
                      // Price Input
                      const Text(
                        'enter price per night',
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
                          onPressed: () {
                            // Implement submission logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00FFD8), // Bright turquoise color from image
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
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
              color: Color(0xFF00FFD8), // Bright turquoise color from image
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeGrid() {
    final propertyTypes = ['house', 'Flat', 'Barn', 'Cabin', 'Boat', 'Tree house'];

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
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              type,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}