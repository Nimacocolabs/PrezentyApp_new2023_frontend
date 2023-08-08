import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';


class ContactInformation extends StatefulWidget {
  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const BackButton(),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child:  Icon(Icons.home_outlined),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: screenWidth,
        height: 30,
        color: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              SizedBox(height: 10),
              Text(
                "Contact Information",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting.orem Ipsum is simply dummy text of the printing and typesetting.orem Ipsum is simply dummy text of the printing and typesetting.",
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Send a Mail",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(
                height: 30,
              ),
             _textField(textController: nameController,hint: "Name",),
              SizedBox(
                height: 20,
              ),
              _textField(textController: emailController,hint:  "Email"),
              SizedBox(
                height: 20,
              ),
              _textField(textController: messageController,hint:  "Message",line: 5),
              SizedBox(
                height: 20,
              ),


              SizedBox(
                width: screenWidth,
                child: TextButton(
                    onPressed:(){
                      print("send");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: secondaryColor,
                    ),
                    child: Text("Send",
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                ),
              )
              ),

            ],

          ),
        ),
      ),
    );
  }

  _textField({TextEditingController? textController, String? hint,int line=1}){
    return  TextField(
      keyboardType: TextInputType.text,
      controller: textController,
      maxLines: line,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

  }
}
