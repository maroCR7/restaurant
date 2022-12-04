import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/order_number_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Stream<DocumentSnapshot> orderDocument;

  @override
  void initState() {
    super.initState();
    orderDocument = FirebaseFirestore.instance
        .collection("Orders")
        .doc(context.read<OrderNumberProvider>().orderNumber)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Order Details")),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: orderDocument,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data?.data() != null) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return DetailsWidget(
                        image: data["image_name"],
                        status: data["status"],
                        comments: data["comments"]);
                  } else {
                    return const Center(
                        child: Text(
                      "There is no order with this number",
                      style: TextStyle(color: Colors.green, fontSize: 22),
                    ));
                  }
              }
            }),
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final String image;
  final String status;
  final List comments;
  const DetailsWidget(
      {Key? key,
      required this.image,
      required this.status,
      required this.comments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const Text("The process :",style: TextStyle(color: Colors.green, fontSize: 22)), Text(status,
                    style: const TextStyle(color: Colors.green, fontSize: 22)),
              ],
            ),
            Lottie.asset("assets/lottie/$image"),
            CommentsWidget(comments: comments)
          ],
        ),
      ),
    );
  }
}

class CommentsWidget extends StatelessWidget {
  final List comments;
  CommentsWidget({Key? key, required this.comments}) : super(key: key);
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: comments.isEmpty
              ? const Center(
                  child: Text("No comments yet"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Text(comments[index]);
                  }),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Comment...",
                    hintStyle: TextStyle(color: Colors.grey.shade500)),
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    comments.add(commentController.text);
                    await FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(context.read<OrderNumberProvider>().orderNumber)
                        .update({"comments": comments});
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.greenAccent,
                ))
          ],
        ),
      ],
    );
  }
}
