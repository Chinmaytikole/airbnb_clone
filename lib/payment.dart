import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PaymentScreen extends StatefulWidget {
  // Add these parameters
  final int? price;
  final int? nights;
  final int? cleaningFee;
  final double? serviceFeePercent;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int? guestCount;
  final int? totalAmount;

  // Update constructor
  PaymentScreen({
    this.price,
    this.nights,
    this.cleaningFee,
    this.serviceFeePercent,
    this.checkInDate,
    this.checkOutDate,
    this.guestCount,
    this.totalAmount,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _rememberCard = true;
  bool _sendReceipt = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Calculate amount based on passed parameters, or use default
    String amountText = '₹34';
    if (widget.totalAmount != null) {
      amountText = '₹${widget.totalAmount}';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'airbnb',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C4B4),
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.language, color: Color(0xFF00C4B4)),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),

                      // Payment Title
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Add booking summary if details are available
                      if (widget.checkInDate != null && widget.checkOutDate != null)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booking Summary',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Luxury Beach Villa, Malibu',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${DateFormat('MMM dd, yyyy').format(widget.checkInDate!)} - ${DateFormat('MMM dd, yyyy').format(widget.checkOutDate!)}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${widget.guestCount} Guest${widget.guestCount! > 1 ? 's' : ''}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 20),

                      // Card Input Fields
                      Text(
                        'Cardholder Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your full name',
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person_outline, color: Color(0xFF00C4B4)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Card Number
                      Text(
                        'Card Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'XXXX XXXX XXXX XXXX',
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.credit_card, color: Color(0xFF00C4B4)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Expiry Date and CVV in a Row
                      Row(
                        children: [
                          // Expiry Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'MM/YY',
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF00C4B4), size: 20),
                                    ),
                                    keyboardType: TextInputType.datetime,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          // CVV
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CVV',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: '***',
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.security, color: Color(0xFF00C4B4), size: 20),
                                    ),
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Divider
                      Divider(color: Colors.black12, thickness: 1),
                      SizedBox(height: 16),

                      // Toggle Switches with better styling
                      Row(
                        children: [
                          Switch(
                            value: _rememberCard,
                            onChanged: (value) {
                              setState(() {
                                _rememberCard = value;
                              });
                            },
                            activeColor: Color(0xFF00C4B4),
                            activeTrackColor: Color(0xFFD2F5F2),
                          ),
                          Text(
                            'Remember this card',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Switch(
                            value: _sendReceipt,
                            onChanged: (value) {
                              setState(() {
                                _sendReceipt = value;
                              });
                            },
                            activeColor: Color(0xFF00C4B4),
                            activeTrackColor: Color(0xFFD2F5F2),
                          ),
                          Text(
                            'Send receipt to my email',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Divider
                      Divider(color: Colors.black12, thickness: 1),
                      SizedBox(height: 16),

                      // Amount Payable - Use the value from booking details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Payable',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            amountText,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Pay Now Button with Airbnb styling
                      Container(
                        width: screenSize.width,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00C4B4),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Payment successful! Booking confirmed.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Navigate back to home after payment
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            });
                          },
                          child: Text(
                            'Pay Now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Cancel button
                      Container(
                        width: screenSize.width,
                        height: 54,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFF00C4B4), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00C4B4),
                            ),
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
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copyright, size: 14, color: Colors.black54),
                  SizedBox(width: 4),
                  Text(
                    '2025 Airbnb, Inc.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
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