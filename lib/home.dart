import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'main.dart';
import 'Start.dart';
import 'renting.dart';
import 'product.dart';
import 'profile.dart';

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
        '/product': (context) => ProductPage(),
        '/rent': (context) => ListingPage(uid: ''),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  String userName = "Loading...";
  String userEmail = "Loading...";
  String userInitials = "...";
  bool isLoading = true;
  List<Map<String, dynamic>> listings = [];
  bool isLoadingListings = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = ModalRoute.of(context)?.settings.arguments as String?;
    if (userId != null) {
      _fetchUserData();
      _fetchAllListings();
    }
  }

  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        setState(() {
          userName = currentUser.displayName ?? "User";
          userEmail = currentUser.email ?? "No email";
          userInitials = _getInitials(userName);
          isLoading = false;
        });
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data()!;
          setState(() {
            userName = userData['name'] ?? userData['fullName'] ?? "User";
            userEmail = userData['email'] ?? "No email";
            userInitials = _getInitials(userName);
            isLoading = false;
          });
        } else {
          setState(() {
            userName = "User";
            userEmail = "user@example.com";
            userInitials = "U";
            isLoading = false;
          });
        }
      }

      print('User ID: $userId');
      print('Username: $userName');
      print('Email: $userEmail');

    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        userName = "User";
        userEmail = "Error loading data";
        userInitials = "U";
        isLoading = false;
      });
    }
  }

  Future<void> _fetchAllListings() async {
    setState(() {
      isLoadingListings = true;
    });

    try {
      final QuerySnapshot rentedPlacesSnapshot = await FirebaseFirestore.instance
          .collection('rented_place')
          .where('HasRented', isEqualTo: true) // Only get places that are rented
          .get();

      List<Map<String, dynamic>> fetchedListings = [];

      for (var doc in rentedPlacesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Skip if RentedPlace data doesn't exist or isn't properly formatted
        if (data.containsKey('RentedPlace') &&
            data['RentedPlace'] is Map<String, dynamic>) {

          final rentalData = Map<String, dynamic>.from(data['RentedPlace']);
          rentalData['userId'] = doc.id; // Store the document ID as userId

          // Handle images - we're now storing them as an array in the new structure
          if (rentalData.containsKey('images') &&
              rentalData['images'] is List &&
              (rentalData['images'] as List).isNotEmpty) {
            // Use the first image if available
            rentalData['image'] = rentalData['images'][0];
          } else {
            // Fallback to a placeholder image
            rentalData['image'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';
          }

          // Add other fields for display
          rentalData['place'] = rentalData['title'] ?? 'Unnamed Place';
          rentalData['price'] = '\$${rentalData['pricePerNight'] ?? '0'}/night';
          rentalData['location'] = rentalData['Location'] ?? 'No location specified';

          fetchedListings.add(rentalData);
        }
      }

      setState(() {
        listings = fetchedListings;
        isLoadingListings = false;
      });

      print('Fetched ${listings.length} listings from rented_place collection');

    } catch (e) {
      print('Error fetching listings: $e');
      setState(() {
        isLoadingListings = false;
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "U";

    List<String> nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    }

    return name.substring(0, 1).toUpperCase();
  }

  // Widget to display base64 image
  Widget _buildBase64Image(String base64String) {
    try {
      if (base64String.startsWith('data:image')) {
        // Handle data URI format
        final parts = base64String.split(',');
        if (parts.length == 2) {
          return Image.memory(
            base64Decode(parts[1]),
            fit: BoxFit.cover,
          );
        }
      }
      // Handle raw base64 string
      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Container(
        color: Colors.grey,
        child: Center(child: Icon(Icons.broken_image, color: Colors.white)),
      );
    }
  }

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
                      isLoading ? "..." : userInitials,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FFD9),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isLoading ? "Loading..." : userName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isLoading ? "Loading..." : userEmail,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_home, color: Color(0xFF00FFD9)),
              title: Text('Rent Your Place'),
              onTap: () {
                Navigator.of(context).pushNamed('/rent', arguments: userId);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Color(0xFF00FFD9)),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).pushNamed('/profile', arguments: userId);
              },
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
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
      body: isLoadingListings
          ? Center(child: CircularProgressIndicator(color: Color(0xFF00FFD9)))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Text(
                'Featured Places',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 340,
                child: listings.isEmpty
                    ? Center(child: Text('No listings available'))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listings.length > 3 ? 3 : listings.length,
                  itemBuilder: (context, index) {
                    return _buildFeaturedItem(context, listings[index]);
                  },
                ),
              ),
              SizedBox(height: 20),

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
                    onPressed: () {
                      _fetchAllListings();
                    },
                    child: Text(
                      'Refresh',
                      style: TextStyle(
                        color: Color(0xFF00FFD9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              listings.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.home_work_outlined, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'No places available yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/rent', arguments: userId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00FFD9),
                          foregroundColor: Colors.black,
                        ),
                        child: Text('List Your Place'),
                      ),
                    ],
                  ),
                ),
              )
                  : GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.45,
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
        onTap: (index) {
          if (index == 3) {
            Navigator.of(context).pushNamed('/profile', arguments: userId);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchAllListings();
        },
        backgroundColor: Color(0xFF00FFD9),
        child: Icon(Icons.refresh, color: Colors.black),
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
        width: 230,
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
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: _buildBase64Image(listing['image']),
              ),
            ),
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
                        '${4.5}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    listing['place'] ?? listing['title'] ?? 'Unnamed Place',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    listing['location'] ?? 'No location specified',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    listing['price'] ?? '\$${listing['pricePerNight'] ?? '0'}/night',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF00FFD9),
                    ),
                  ),
                  SizedBox(height: 10),
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/product',
          arguments: listing,
        );
      },
      child: Container(
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
            Container(
              height: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: _buildBase64Image(listing['image']),
              ),
            ),
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
                        '${4.5}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    listing['place'] ?? listing['title'] ?? 'Unnamed Place',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    listing['location'] ?? 'No location specified',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    listing['price'] ?? '\$${listing['pricePerNight'] ?? '0'}/night',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF00FFD9),
                    ),
                  ),
                  SizedBox(height: 10),
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
      ),
    );
  }
}