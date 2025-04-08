import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'main.dart';
import 'Start.dart';
import 'renting.dart';
import 'product.dart'; // Import the product.dart file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AirbnbClone());
}
class AirbnbClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00FFD9),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/main': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/product': (context) => ProductPage(), // This now references the ProductPage from product.dart
        '/rent': (context) => ListingPage(), // Updated to use ListingPage from renting.dart
      },
    );
  }
}

// Added RentYourPlacePage class
class RentYourPlacePage extends StatefulWidget {
  @override
  _RentYourPlacePageState createState() => _RentYourPlacePageState();
}

class _RentYourPlacePageState extends State<RentYourPlacePage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedPropertyType = '';
  bool _acceptTerms = false;

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
        color: Color(0xFF00FFD9).withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: const Text(
                    'Airbnbclone',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Price Input
                const Text(
                  'enter price per night',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                // Address Input
                const Text(
                  'Enter address',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // Photos
                const Text(
                  'Add Photos',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Camera icon
                      IconButton(
                        icon: const Icon(Icons.camera_alt, size: 40),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 40),
                      // Upload icon
                      IconButton(
                        icon: const Icon(Icons.upload, size: 40),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Property Type
                const Text(
                  'What best describes your place',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildPropertyTypeGrid(),

                const SizedBox(height: 16),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      activeColor: Color(0xFF00FFD9),
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),
                    const Text('Do you accept '),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'terms and conditions',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Rent Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement submission logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00FFD9),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Rent this place',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeGrid() {
    final propertyTypes = ['house', 'Flat', 'Barn', 'Cabin', 'Boat', 'Tree house'];

    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 2.5,
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
                border: Border.all(color: Colors.grey),
                color: _selectedPropertyType == type ? Color(0xFF00FFD9).withOpacity(0.2) : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                type,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: _selectedPropertyType == type ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  // Sample data for listings
  final List<Map<String, dynamic>> listings = [
    {
      'image': 'https://a0.muscache.com/im/pictures/miso/Hosting-1048815644102116679/original/05101663-7894-48d0-bfbe-61f923f7dfaf.jpeg?im_w=720',
      'price': '\$120/night',
      'place': 'Beachfront Villa',
      'location': 'Malibu, CA',
      'rating': 4.8,
    },
    {
      'image': 'https://a0.muscache.com/im/pictures/miso/Hosting-1048815644102116679/original/05101663-7894-48d0-bfbe-61f923f7dfaf.jpeg?im_w=720',
      'price': '\$85/night',
      'place': 'Cozy Apartment',
      'location': 'Manhattan, NY',
      'rating': 4.6,
    },
    {
      'image': 'https://a0.muscache.com/im/pictures/miso/Hosting-1048815644102116679/original/05101663-7894-48d0-bfbe-61f923f7dfaf.jpeg?im_w=720',
      'price': '\$200/night',
      'place': 'Mountain Cabin',
      'location': 'Aspen, CO',
      'rating': 4.9,
    },
    {
      'image': 'https://a0.muscache.com/im/pictures/miso/Hosting-1048815644102116679/original/05101663-7894-48d0-bfbe-61f923f7dfaf.jpeg?im_w=720',
      'price': '\$150/night',
      'place': 'Lakeside Cottage',
      'location': 'Lake Tahoe, NV',
      'rating': 4.7,
    },
    {
      'image': 'https://a0.muscache.com/im/pictures/miso/Hosting-1048815644102116679/original/05101663-7894-48d0-bfbe-61f923f7dfaf.jpeg?im_w=720',
      'price': '\$95/night',
      'place': 'Urban Loft',
      'location': 'Chicago, IL',
      'rating': 4.5,
    },
    {
      'image': 'https://a0.muscache.com/im/pictures/miso/Hosting-1048815644102116679/original/05101663-7894-48d0-bfbe-61f923f7dfaf.jpeg?im_w=720',
      'price': '\$175/night',
      'place': 'Seaside Bungalow',
      'location': 'Miami, FL',
      'rating': 4.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.network(
              'https://cdn.icon-icons.com/icons2/2699/PNG/512/airbnb_logo_icon_170605.png',
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'airbnb',
              style: TextStyle(
                color: Color(0xFF00FFD9),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF00FFD9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FFD9),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // ADDED RENT YOUR PLACE OPTION HERE
            ListTile(
              leading: Icon(Icons.add_home, color: Color(0xFF00FFD9)),
              title: Text('Rent Your Place'),
              onTap: () {
                Navigator.of(context).pushNamed('/rent');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Color(0xFF00FFD9)),
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.house, color: Color(0xFF00FFD9)),
              title: Text('My Bookings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Color(0xFF00FFD9)),
              title: Text('Wishlist'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.grey),
              title: Text('Help Center'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Where do you want to stay?',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF00FFD9)),
                    suffixIcon: Icon(Icons.tune, color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Categories
              Container(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryItem(Icons.house, 'Houses'),
                    _buildCategoryItem(Icons.apartment, 'Apartments'),
                    _buildCategoryItem(Icons.cabin, 'Cabins'),
                    _buildCategoryItem(Icons.beach_access, 'Beach'),
                    _buildCategoryItem(Icons.pool, 'Pools'),
                    _buildCategoryItem(Icons.landscape, 'Countryside'),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Featured section
              Text(
                'Featured Places',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 310, // Increased height to accommodate the button
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildFeaturedItem(context, listings[index]);
                  },
                ),
              ),
              SizedBox(height: 20),

              // All listings section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Places',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF00FFD9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.45, // Adjusted to accommodate the button
                ),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  return _buildListingCard(context, listings[index]);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF00FFD9),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String title) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Color(0xFF00FFD9), size: 30),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedItem(BuildContext context, Map<String, dynamic> listing) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/product',
          arguments: listing,
        );
      },
      child: Container(
        width: 280,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage(listing['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text(
                        '${listing['rating']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    listing['place'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    listing['location'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    listing['price'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF00FFD9),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Added View Details Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/product',
                          arguments: listing,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00FFD9),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(BuildContext context, Map<String, dynamic> listing) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with stack for favorite icon
          Container(
            height: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(listing['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Color(0xFF00FFD9),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '${listing['rating']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  listing['place'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  listing['location'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Text(
                  listing['price'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF00FFD9),
                  ),
                ),
                SizedBox(height: 10),
                // Added View Details Button to listing card
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/product',
                        arguments: listing,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00FFD9),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}