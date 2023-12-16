

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardUrlScreen extends StatefulWidget {
   CardUrlScreen({Key? key,required this.url}) : super(key: key);
final String url;
  @override
  State<CardUrlScreen> createState() => _CardUrlScreenState();
}

class _CardUrlScreenState extends State<CardUrlScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold( appBar: AppBar(
      leading: BackButton(
        onPressed: () {
          //Get.offAll(() => MainScreen());
        },
      ),
    ),
      body:
      Scaffold(
        body: CachedNetworkImage(
          imageUrl: "${widget.url}",
          placeholder: (context, url) => CircularProgressIndicator(), // Placeholder widget while loading
          errorWidget: (context, url, error) => Icon(Icons.error), // Error widget when image fails to load
        ),
      ),
    );
  }
}
