import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ATMApp());
}

class ATMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATM App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ATMHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ATMHomePage extends StatefulWidget {
  @override
  _ATMHomePageState createState() => _ATMHomePageState();
}

class _ATMHomePageState extends State<ATMHomePage> {
  static const platform = MethodChannel('atm_channel');

  final accountNumberController = TextEditingController();
  final pinController = TextEditingController();
  final amountController = TextEditingController();
  final newPinController = TextEditingController();
  String resultMessage = "";

  Future<void> performOperation(String method, {String? newPin}) async {
    try {
      final double? amount = (method == 'deposit' || method == 'withdraw') &&
          amountController.text.isNotEmpty
          ? double.tryParse(amountController.text)
          : null;

      final String result = await platform.invokeMethod(method, {
        'accountNumber': accountNumberController.text,
        'pin': pinController.text,
        'amount': amount,
        'newPin': newPin,
      });

      setState(() {
        resultMessage = result;
      });
    } catch (e) {
      setState(() {
        resultMessage = "An error occurred.";
      });
    }
  }

  Future<void> checkBalance() async {
    try {
      final String balance = await platform.invokeMethod('checkBalance', {
        'accountNumber': accountNumberController.text,
        'pin': pinController.text,
      });
      setState(() {
        resultMessage = balance;
      });
    } catch (e) {
      setState(() {
        resultMessage = "Error fetching balance.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ATM App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(controller: accountNumberController, decoration: InputDecoration(labelText: 'Account Number')),
              TextField(controller: pinController, decoration: InputDecoration(labelText: 'PIN'), obscureText: true),
              TextField(controller: amountController, decoration: InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              TextField(controller: newPinController, decoration: InputDecoration(labelText: 'New PIN'), obscureText: true),
              SizedBox(height: 20),
              ElevatedButton(onPressed: checkBalance, child: Text('Check Balance')),
              ElevatedButton(onPressed: () => performOperation('deposit'), child: Text('Deposit')),
              ElevatedButton(onPressed: () => performOperation('withdraw'), child: Text('Withdraw')),
              ElevatedButton(onPressed: () => performOperation('changePin', newPin: newPinController.text), child: Text('Change PIN')),
              SizedBox(height: 20),
              Text(resultMessage, style: TextStyle(fontSize: 16, color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
