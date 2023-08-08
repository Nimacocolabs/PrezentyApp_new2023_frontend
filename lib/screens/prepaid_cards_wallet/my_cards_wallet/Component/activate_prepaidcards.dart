
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';


class ActivatePrepaidcards extends StatefulWidget {
  const ActivatePrepaidcards({Key? key}) : super(key: key);

  @override
  State<ActivatePrepaidcards> createState() => _ActivatePrepaidcardsState();
}

class _ActivatePrepaidcardsState extends State<ActivatePrepaidcards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: BackButton(),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child:  Icon(Icons.home_outlined),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Activate My Cards",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                child: Image(
                  image: const AssetImage(
                      "assets/cards/horizontal_with_logo.png"),
                  width: screenWidth,
                ),
              ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CircleAvatar(
          //       radius: 18,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(18),
          //         child: CachedNetworkImage(
          //           width: 36,
          //           height: 36,
          //           fit: BoxFit.cover,
          //           imageUrl: '',
          //           //${User.userImageUrlValueNotifier.value},
          //           placeholder: (context, url) => Center(
          //             child: CircularProgressIndicator(),
          //           ),
          //           errorWidget: (context, url, error) => Container(
          //             margin: EdgeInsets.all(5),
          //             child: Image(
          //               image: AssetImage('assets/images/ic_avatar.png'),
          //               height: double.infinity,
          //               width: double.infinity,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: screenWidth,
                height: 50,
                child: TextButton(
                    onPressed: (){},
                    child:Text("Activate",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                    ),
                    ),
                  style: TextButton.styleFrom(
                    backgroundColor: secondaryColor,
                  ),

                ),
              ),
        ],),

      ),


    ),);
  }
}
