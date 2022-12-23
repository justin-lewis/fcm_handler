import 'package:flutter/material.dart';
import 'package:fcm_handler_example/navigation.dart';
import 'package:fcm_handler_example/screen/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Home Screen",
              style: TextStyle(fontSize: 26, color: Colors.red),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: OutlinedButton(
                child: const Text("Go to detial"),
                onPressed: () {
                  pushPage(context, const DetailScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
