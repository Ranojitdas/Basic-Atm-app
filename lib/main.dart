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
      appBar: AppBar(title: Text('ATM App'),
      backgroundColor: Colors.lightBlueAccent,),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(image:
          AssetImage('assets/a.jpg'),
            fit: BoxFit.cover,

          )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 12,),
              TextField(controller: accountNumberController, decoration: InputDecoration(labelText: 'Account Number',border: OutlineInputBorder())),
              SizedBox(height: 8,),
              TextField(controller: pinController, decoration: InputDecoration(labelText: 'PIN',border:OutlineInputBorder()), obscureText: true),
              SizedBox(height: 8,),
              TextField(controller: amountController, decoration: InputDecoration(labelText: 'Amount',border: OutlineInputBorder()), keyboardType: TextInputType.number),
              SizedBox(height: 8,),
              TextField(controller: newPinController, decoration: InputDecoration(labelText: 'New PIN',border: OutlineInputBorder()), obscureText: true),
              SizedBox(height: 30),
              ElevatedButton(onPressed: checkBalance, child: Text('Check Balance',style: TextStyle(fontSize: 17),)),
              ElevatedButton(onPressed: () => performOperation('deposit'), child: Text('Deposit',style: TextStyle(fontSize: 17,color: Colors.green)),),
              ElevatedButton(onPressed: () => performOperation('withdraw'), child: Text('Withdraw',style: TextStyle(fontSize: 17,color: Colors.red))),
              ElevatedButton(onPressed: () => performOperation('changePin', newPin: newPinController.text), child: Text('Change PIN',style: TextStyle(fontSize: 17))),
              SizedBox(height: 20),
              Text(resultMessage, style: TextStyle(fontSize: 20, color: Colors.black54,fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
