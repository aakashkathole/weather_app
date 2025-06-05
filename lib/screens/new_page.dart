import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _CheckUserPageState();
}

class _CheckUserPageState extends State<NewPage> {
  final TextEditingController _mobileController = TextEditingController();

  Future<void> checkUserByMobile(String mobileNumber) async {
    final Uri url = Uri.parse('http://203.192.224.67/Meetify-og/Api/otpVerified');

    const String apiKey = '4co0g804gcggwo088g4ko6j76d8u9lf7s9h2vkg58kis';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-api-key': apiKey,
        },
        body: {
          'mobile': mobileNumber,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        print('✅ Success: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Response: $responseData')),
        );
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ${response.statusCode}: ${response.body}')),
        );
      }
    } catch (e) {
      print('⚠️ Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check User")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: "Mobile Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final mobile = _mobileController.text.trim();
                if (mobile.isNotEmpty) {
                  checkUserByMobile(mobile);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter mobile number")),
                  );
                }
              },
              child: const Text("Check"),
            ),
          ],
        ),
      ),
    );
  }
}
