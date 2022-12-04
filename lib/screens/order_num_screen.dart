import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/order_number_provider.dart';
import 'package:restaurant/screens/order_details_screen.dart';

class OrderNumScreen extends StatefulWidget {
  const OrderNumScreen({Key? key}) : super(key: key);

  @override
  State<OrderNumScreen> createState() => _OrderNumScreenState();
}

class _OrderNumScreenState extends State<OrderNumScreen> {
  TextEditingController orderNumController = TextEditingController();
  @override
  void dispose() {
    orderNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text("Welcome",style: TextStyle(color: Colors.green, fontSize: 28)),
            ),

            Expanded(
                flex: 3,
                child: Lottie.asset("assets/lottie/cooking-preloader.json")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: orderNumController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: "Enter your order number"),
              ),
            ),
            TextButton(onPressed: () {
              if(orderNumController.text.isNotEmpty){
                FocusScope.of(context).unfocus();
               context.read<OrderNumberProvider>().setOrderNumber(orderNumController.text);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderDetailsScreen()));
              }

            }, child: const Text("Continue")),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
