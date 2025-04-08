import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnbclone Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF00FFCF),
        scaffoldBackgroundColor: const Color(0xFFE6FFF9),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            color: const Color(0xFF00FFCF), // Turquoise/aqua color for header
            child: const Center(
              child: Text(
                'Airbnbclone',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              color: const Color(0xFFE6FFF9), // Light mint background
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                children: [
                  // Profile picture placeholder
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.person, size: 80, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Update Profile Picture'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Username field
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your username',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Identity Verification Section
                  _buildSectionHeader('Identity Verification'),
                  _buildVerificationItem(
                      'Government ID',
                      'Not verified',
                      Icons.badge,
                      Colors.red
                  ),
                  _buildVerificationItem(
                      'Email',
                      'Verified',
                      Icons.email,
                      Colors.green
                  ),
                  _buildVerificationItem(
                      'Phone number',
                      'Verified',
                      Icons.phone,
                      Colors.green
                  ),
                  _buildVerificationItem(
                      'Social media accounts',
                      'Connect accounts',
                      Icons.link,
                      Colors.blue
                  ),

                  const SizedBox(height: 30),

                  // User Preferences Section
                  _buildSectionHeader('User Preferences'),

                  // Language preference
                  _buildPreferenceDropdown(
                      'Preferred language',
                      const ['English', 'Spanish', 'French', 'German', 'Chinese'],
                      'English'
                  ),

                  const SizedBox(height: 15),

                  // Currency preference
                  _buildPreferenceDropdown(
                      'Currency preference',
                      const ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'],
                      'USD'
                  ),

                  const SizedBox(height: 15),

                  // Notification settings
                  _buildSwitchItem('Notification settings', true),

                  const SizedBox(height: 15),

                  // Communication preferences
                  _buildSwitchItem('Email communication', true),
                  _buildSwitchItem('SMS notifications', false),
                  _buildSwitchItem('Push notifications', true),

                  const SizedBox(height: 30),

                  // Payment Information Section
                  _buildSectionHeader('Payment Information'),

                  // Saved payment methods
                  _buildPaymentMethod('Visa ending in 4242', 'Expires 05/26', Icons.credit_card),
                  _buildPaymentMethod('PayPal - user@example.com', '', Icons.account_balance_wallet),

                  // Add payment method button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add payment method'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Payout methods
                  const Text(
                    'Payout methods (for hosts)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentMethod('Bank account ending in 9876', '', Icons.account_balance),

                  const SizedBox(height: 15),

                  // Transaction history
                  const Text(
                    'Transaction history',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        _buildTransactionItem('Booking #12345', 'Mar 25, 2025', '-\$120.00'),
                        const Divider(),
                        _buildTransactionItem('Booking #12344', 'Mar 10, 2025', '-\$85.50'),
                        const Divider(),
                        _buildTransactionItem('Host payout', 'Feb 28, 2025', '+\$350.00'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Save Changes Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFCF),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('SAVE CHANGES'),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            width: double.infinity,
            height: 50,
            color: const Color(0xFF00FFCF), // Same turquoise/aqua color for footer
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home),
                Icon(Icons.search),
                Icon(Icons.favorite_border),
                Icon(Icons.person),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 50,
            color: const Color(0xFF00FFCF),
          ),
        ],
      ),
    );
  }

  // Helper for verification items
  Widget _buildVerificationItem(String title, String status, IconData icon, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00FFCF)),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 5),
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // Helper for preference dropdowns
  Widget _buildPreferenceDropdown(String title, List<String> options, String defaultValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: defaultValue,
            isExpanded: true,
            underline: Container(),
            onChanged: (String? newValue) {},
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Helper for switch items
  Widget _buildSwitchItem(String title, bool defaultValue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Switch(
            value: defaultValue,
            onChanged: (value) {},
            activeColor: const Color(0xFF00FFCF),
          ),
        ],
      ),
    );
  }

  // Helper for payment methods
  Widget _buildPaymentMethod(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  // Helper for transaction history items
  Widget _buildTransactionItem(String title, String date, String amount) {
    final bool isPositive = amount.startsWith('+');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}