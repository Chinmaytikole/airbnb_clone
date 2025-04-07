import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'feedback_form_widget.dart';
import 'payment.dart';

void main() {
  runApp(AirbnbCloneApp());
}

class AirbnbCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00C4B4),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF00C4B4),
          secondary: Color(0xFF00A699),
        ),
        fontFamily: 'Circular',
      ),
      home: AirbnbCloneScreen(),
    );
  }
}

class AirbnbCloneScreen extends StatefulWidget {
  @override
  _AirbnbCloneScreenState createState() => _AirbnbCloneScreenState();
}

class _AirbnbCloneScreenState extends State<AirbnbCloneScreen> {
  int _currentIndex = 0;
  DateTime? checkin;
  DateTime? checkout;
  int guests = 1;
  bool termsAccepted = false;

  List<String> propertyImages = [
    'https://via.placeholder.com/600x400?text=Beautiful+Apartment',
    'https://via.placeholder.com/600x400?text=Cozy+Living+Room',
    'https://via.placeholder.com/600x400?text=Modern+Kitchen',
    'https://via.placeholder.com/600x400?text=Spacious+Bedroom',
  ];

  final List<Map<String, dynamic>> amenities = [
    {'icon': Icons.wifi, 'label': 'Free WiFi'},
    {'icon': Icons.local_parking, 'label': 'Free Parking'},
    {'icon': Icons.pool, 'label': 'Pool'},
    {'icon': Icons.fitness_center, 'label': 'Gym'},
    {'icon': Icons.pets, 'label': 'Pet Friendly'},
  ];

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
              primary: Color(0xFF00C4B4),
              onPrimary: Colors.white,
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
          // If checkout is before new checkin, reset checkout
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
              // Here you would typically send this data to your backend
              print('Rating: $rating, Feedback: $feedback');
              // Close the modal after a short delay
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Airbnb', style: TextStyle(color: Color(0xFF00C4B4), fontWeight: FontWeight.bold)),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black87),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF00C4B4)),
                accountName: Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text("john.doe@example.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFF00C4B4)),
                ),
              ),
              ListTile(leading: Icon(Icons.home), title: Text("Explore"), onTap: () {}),
              ListTile(leading: Icon(Icons.favorite), title: Text("Wishlists"), onTap: () {}),
              ListTile(leading: Icon(Icons.flight), title: Text("Trips"), onTap: () {}),
              ListTile(leading: Icon(Icons.message), title: Text("Messages"), onTap: () {}),
              Divider(),
              ListTile(leading: Icon(Icons.add_home), title: Text("Host your home"), onTap: () {}),
              ListTile(leading: Icon(Icons.settings), title: Text("Settings"), onTap: () {}),
              ListTile(leading: Icon(Icons.help), title: Text("Help Center"), onTap: () {}),
              ListTile(leading: Icon(Icons.exit_to_app), title: Text("Logout"), onTap: () {}),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: "Where are you going?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xFF00C4B4)),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // Image carousel
        Container(
          height: 280,
          child: PageView.builder(
            itemCount: propertyImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(propertyImages[index]),
                  ),
                ),
              );
            },
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
    Text(
    "Luxury Beach Villa",
    style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    ),
    ),
    Row(
    children: [
    Icon(Icons.star, color: Color(0xFF00C4B4), size: 18),
    SizedBox(width: 4),
    Text(
    "4.95",
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
    "Malibu, California",
    style: TextStyle(
    fontSize: 16,
    color: Colors.grey.shade700,
    ),
    ),
    SizedBox(height: 16),
    Text(
    "₹20,000/night",
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
    Icon(amenities[index]['icon'], color: Color(0xFF00C4B4)),
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
    checkin != null ? DateFormat('MMM dd, yyyy').format(checkin!) : "Add date",
    style: TextStyle(
    fontSize: 14,
    fontWeight: checkin != null ? FontWeight.bold : FontWeight.normal,
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
    checkout != null ? DateFormat('MMM dd, yyyy').format(checkout!) : "Add date",
    style: TextStyle(
    fontSize: 14,
    fontWeight: checkout != null ? FontWeight.bold : FontWeight.normal,
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
    ? Icon(Icons.check, color: Color(0xFF00C4B4))
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
                  Text("₹20,000 × ${checkout!.difference(checkin!).inDays} nights"),
                  Text("₹${20000 * checkout!.difference(checkin!).inDays}"),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cleaning fee"),
                  Text("₹2,500"),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Service fee"),
                  Text("₹${(20000 * checkout!.difference(checkin!).inDays * 0.12).round()}"),
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
                    "₹${20000 * checkout!.difference(checkin!).inDays + 2500 + (20000 * checkout!.difference(checkin!).inDays * 0.12).round()}",
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
            activeColor: Color(0xFF00C4B4),
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
                      color: Color(0xFF00C4B4),
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
            backgroundColor: Color(0xFF00C4B4),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          onPressed: (termsAccepted && checkin != null && checkout != null)
              ? () {
            // Calculate the total amount
            final int subtotal = 20000 * checkout!.difference(checkin!).inDays;
            final int cleaningFee = 2500;
            final int serviceFee = (subtotal * 0.12).round();
            final int totalAmount = subtotal + cleaningFee + serviceFee;

            // Navigate to payment.dart when Reserve button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  price: 20000,
                  nights: checkout!.difference(checkin!).inDays,
                  cleaningFee: 2500,
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
        "This stunning beachfront villa offers breathtaking ocean views and modern amenities. Enjoy the private infinity pool, gourmet kitchen, and outdoor dining area. Just steps away from the beach, this property is perfect for a relaxing getaway.",
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
          icon: Icon(Icons.star_border, color: Color(0xFF00C4B4)),
          label: Text(
            "Rate & Review",
            style: TextStyle(
              color: Color(0xFF00C4B4),
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Color(0xFF00C4B4)),
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF00C4B4),
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