import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/order_number_provider.dart';
import 'package:restaurant/screens/order_num_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OrderNumberProvider()),
    ],
    child: const MyApp(),
  ));
  

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant',
      theme: ThemeData(

        primarySwatch: Colors.lightGreen,
      ),
      home: const OrderNumScreen(),
    );
  }
}

