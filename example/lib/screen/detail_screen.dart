import 'package:flutter/material.dart';
import 'package:fcm_handler_example/navigation.dart';

class DetailScreen extends StatefulWidget {
  final int notificationId;
  const DetailScreen({Key? key, this.notificationId = 0}) : super(key: key);

  @override
  DetailScreenState createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {
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
        backgroundColor: Colors.amberAccent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Detail Screen ${widget.notificationId}",
              style: const TextStyle(fontSize: 26, color: Colors.red),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: OutlinedButton(
                child: const Text("Back to Home"),
                onPressed: () {
                  popSinglePage(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
