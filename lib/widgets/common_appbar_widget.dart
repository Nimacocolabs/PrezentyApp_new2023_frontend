import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/screens/profile/profile_details_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppBarWidget extends StatefulWidget  implements PreferredSizeWidget{
  final String? title;
  final onPressedFunction;
  final String? image;
  
  const CommonAppBarWidget({this.title,this.onPressedFunction,this.image});

  @override
  State<CommonAppBarWidget> createState() => _CommonAppBarWidgetState();
 @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(65);
}

class _CommonAppBarWidgetState extends State<CommonAppBarWidget> {
  ProfileBloc _profileBloc = ProfileBloc();
  UserSignUpResponse? userData;
@override
 void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
  getUserDetails();
  }
 Future getUserDetails() async {
    userData = await _profileBloc.getProfileInfo();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
     color: primaryColor,
     child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      Padding(
            padding: const EdgeInsets.only(left: 10,top:30),
            child: IconButton(
              iconSize: 25,
              icon: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.white,
              ),
              onPressed: widget.onPressedFunction,
            ),
          ),
Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 30),
                alignment: FractionalOffset.centerLeft,
                child: Center(
                  child: Text("${widget.title ?? "" }",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600)),
                )),
            flex: 1,
          ),

          Padding(
            padding: const EdgeInsets.only(right: 20,top: 35,bottom: 5),
            child: InkWell(
              onTap: (){
                Get.to(() => ProfileDetailsScreen());
              },
              child: CircleAvatar(
                            backgroundColor: Colors.black87,
                            radius: 25,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:'${widget.image}',
                                 // '${userData?.baseUrl}${userData?.userDetails?.imageUrl}',
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/ic_avatar.png',
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
            ),
          ),

          

     ],),
    );
  }
}