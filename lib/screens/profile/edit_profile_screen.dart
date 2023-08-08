import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/models/user_details.dart';
import 'package:event_app/models/profile_update_response.dart';
import 'package:event_app/screens/login/select_country_dialog_screen.dart';
import 'package:event_app/screens/splash_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/app_text_box.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:event_app/util/string_validator.dart';

import '../../widgets/common_bottom_navigation_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final bool isCompleteProfile;
  final String baseUrl;
  final UserDetails userDetails;
  EditProfileScreen({required this.userDetails,required this.baseUrl, this.isCompleteProfile=false});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextFieldControl _textFieldControlEmail = TextFieldControl();
  TextFieldControl _textFieldControlFirstName = TextFieldControl();
  TextFieldControl _textFieldControlLastName = TextFieldControl();
  TextFieldControl _textFieldControlPhoneNumber = TextFieldControl();
  TextFieldControl _textFieldControlAddress = TextFieldControl();

  String _countryCode= '91';

  ProfileBloc _bloc = ProfileBloc();

  // List<dynamic> idProof = ["PAN Card", "Lisence", "ID Card", "Aadhar Card"];

  File? _image;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(widget.isCompleteProfile){
          toastMessage('Please complete your profile to continue');
        }
        return !widget.isCompleteProfile;
      },
      child: Scaffold(
        // appBar: AppBar(
        //     title:Text(widget.isCompleteProfile?'Profile':'')
        // ),
          appBar:CommonAppBarWidget(
            title:"${widget.isCompleteProfile?'Profile':''}",
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
        bottomNavigationBar: CommonBottomNavigationWidget(),
        body:  SafeArea(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            TitleWithSeeAllButton(title: widget.isCompleteProfile?'Complete your profile':'Update Profile'),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(12),
                children: [
                  if(!widget.isCompleteProfile)
                    _buildImageSection(),
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  // AppTextBox(
                  //   textFieldControl: _textFieldControlName,
                  //   hintText: '',
                  //   keyboardType: TextInputType.name,
                  // ),

                  AppTextBox(
                    textFieldControl: _textFieldControlFirstName,
                    hintText: 'First name',
                    keyboardType: TextInputType.name,
                  ),
                  AppTextBox(
                    textFieldControl: _textFieldControlLastName,
                    hintText: 'Last name',
                    keyboardType: TextInputType.name,
                  ),


                  SizedBox(
                    height: 8,
                  ),

                  Text(
                    'Email address',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  AppTextBox(
                    textFieldControl: _textFieldControlEmail,
                    hintText: '',
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  AppTextBox(
                    enabled: (widget.userDetails.phoneNumber??'').isEmpty,
                    textFieldControl: _textFieldControlPhoneNumber,
                    hintText: '',
                    keyboardType: TextInputType.number,

                    prefixIcon: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12,),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+$_countryCode -',
                              style:
                              TextStyle(fontSize: 16),
                            ),
                            // Icon(Icons .keyboard_arrow_down_rounded)
                          ],
                        ),
                      ),
                      onTap: true?null:() async {
                        Country? country = await Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (_, __, ___) => SelectCountryDialogScreen()));
                        if(country!=null){
                          setState(() {
                            _countryCode='${country.phoneCode}';
                          });
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Once updated, you can't change the mobile number later.",style:TextStyle(color: Colors.red.shade300))),
                      IconButton(
                        onPressed: (){
                          AppDialogs.message("On creating an event, a virtual account will be created for you to receive gift amount. It will be linked with your mobile number. And it can't be changed later.");
                        },
                        icon: Icon(Icons.info_outline_rounded),
                      ),
                    ],
                  ),
                  // Focus(
                  //   onFocusChange:(hasFocus){
                  //     setState(() { });
                  //   },
                  //   child: Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: _textFieldControlPhoneNumber.focusNode.hasFocus
                  //             ? primaryColor
                  //             : Colors.black26),
                  //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                  //       ),
                  //       margin: EdgeInsets.symmetric(vertical: 8),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.max,
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           // Container(
                  //           //     padding: EdgeInsets.fromLTRB(14, 0, 2, 0),
                  //           //     child: Text('+')),
                  //           // Container(
                  //           //   constraints: BoxConstraints(
                  //           //     minWidth: 30,
                  //           //     minHeight: 50,
                  //           //     maxWidth: 100,
                  //           //   ),
                  //           //   child: IntrinsicWidth(
                  //           //     child: TextFormField(
                  //           //         controller: _textFieldControlCountryCode,
                  //           //         keyboardType: TextInputType.number,
                  //           //         maxLines: 1,
                  //           //         maxLength: 5,
                  //           //         textAlign: TextAlign.center,
                  //           //         scrollPhysics: BouncingScrollPhysics(),
                  //           //         decoration: InputDecoration(
                  //           //           counterText: '',
                  //           //           border: InputBorder.none,
                  //           //           disabledBorder: InputBorder.none,
                  //           //           enabledBorder: InputBorder.none,
                  //           //           errorBorder: InputBorder.none,
                  //           //           focusedBorder: InputBorder.none,
                  //           //           focusedErrorBorder: InputBorder.none,
                  //           //           hintText: '',
                  //           //           hintStyle: TextStyle(fontSize: 14),
                  //           //           contentPadding: EdgeInsets.symmetric(
                  //           //               vertical: 14, horizontal: 0),
                  //           //         ),
                  //           //         validator: (val) {}),
                  //           //   ),
                  //           // ),
                  //           // Container(
                  //           //     padding: EdgeInsets.symmetric(horizontal: 8),
                  //           //     child: Text('-',style: TextStyle(fontSize: 18),)),
                  //           Expanded(
                  //             child: Container(
                  //               // width: 200,
                  //               height: 50,
                  //               child: TextFormField(
                  //                 enabled: (widget.userDetails.phoneNumber??'').isEmpty,
                  //                   controller: _textFieldControlPhoneNumber.controller,
                  //                   focusNode: _textFieldControlPhoneNumber.focusNode,
                  //                   keyboardType: TextInputType.number,
                  //                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //                   maxLines: 1,
                  //                   maxLength: 15,
                  //                   scrollPhysics: BouncingScrollPhysics(),
                  //                   decoration: InputDecoration(
                  //                     counterText: '',
                  //                     hintText: '',
                  //                     hintStyle: TextStyle(fontSize: 14),
                  //                     contentPadding: EdgeInsets.symmetric(
                  //                         vertical: 14, horizontal: 0),
                  //
                  //                     border: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.all(Radius.circular(7)),
                  //                         borderSide: BorderSide(color: Colors.grey)),
                  //                     disabledBorder: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.all(Radius.circular(7)),
                  //                         borderSide: BorderSide(color: Colors.black12)),
                  //                     enabledBorder: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.all(Radius.circular(7)),
                  //                         borderSide: BorderSide(color: Colors.grey)),
                  //                     errorBorder: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.all(Radius.circular(7)),
                  //                         borderSide: BorderSide(color: Colors.grey)),
                  //                     focusedBorder: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.all(Radius.circular(7)),
                  //                         borderSide: BorderSide(color: primaryColor)),
                  //                     focusedErrorBorder: OutlineInputBorder(
                  //                         borderRadius: BorderRadius.all(Radius.circular(7)),
                  //                         borderSide: BorderSide(color: primaryColor)),
                  //
                  //                     // border: InputBorder.none,
                  //                     // disabledBorder: InputBorder.none,
                  //                     // enabledBorder: InputBorder.none,
                  //                     // errorBorder: InputBorder.none,
                  //                     // focusedBorder: InputBorder.none,
                  //                     // focusedErrorBorder: InputBorder.none,
                  //                   ),
                  //                   validator: (val) {}),
                  //             ),
                  //           )
                  //         ],
                  //       )
                  //
                  //       // child: Row(
                  //       //   mainAxisSize: MainAxisSize.max,
                  //       //   children: [
                  //
                  //       //   ],)
                  //       ),
                  // ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  AppTextBox(
                    textFieldControl: _textFieldControlAddress,
                    hintText: '',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: secondaryColor,
                        child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: _validate),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

_validate (){
  String firstName = _textFieldControlFirstName.controller.text.trim();
  String lastName = _textFieldControlLastName.controller.text.trim();

  // var checkNameTyped = _textFieldControlName.controller.text.trim().isValidName();
  // var checkPhoneNumberTyped = (_textFieldControlCountryCode.text.trim()+_textFieldControlPhoneNumber.text.trim()).isValidMobileNumber();
  // var checkPhoneNumberTyped = '${_textFieldControlPhoneNumber.controller.text.trim()}'.isValidMobileNumber();

  if (firstName.isEmpty) {
    toastMessage('Please provide your first name');
  } else if (!firstName.isAlphabetOnly) {
    toastMessage('First name should contain only alphabets');
  } else if (lastName.isEmpty) {
    toastMessage('Please provide your last name');
  } else if (!lastName.isAlphabetOnly) {
    toastMessage('Last name should contain only alphabets');
  } else if(_countryCode.isEmpty){
    Fluttertoast.showToast(msg: "Please provide country code");
  } else if(!_textFieldControlPhoneNumber.controller.text.trim().isValidMobileNumber()){
    Fluttertoast.showToast(msg: "Please provide a valid phone number");
  } else if(_textFieldControlEmail.controller.text.trim()==''){
    Fluttertoast.showToast(msg: "Please provide an email");
  } else if (!_textFieldControlEmail.controller.text.trim().isValidEmail()) {
    Fluttertoast.showToast(msg: "Please provide a valid email");
  } else {
    callApiToEditProfile();
  }
}

  fetchInitialData() {

    String name = widget.userDetails.name??'';

    List names =[];
    if(name.contains('  ')){
      names = name.split('  ');
      _textFieldControlFirstName.controller.text = names[0];
      _textFieldControlLastName.controller.text = names[1];
    }else if(name. contains(' ')){
      names = name.split(' ');
      _textFieldControlFirstName.controller.text = names[0];
      _textFieldControlLastName.controller.text = names[1];
    }else {
      _textFieldControlFirstName.controller.text = name;
    }



    _textFieldControlEmail.controller.text = widget.userDetails.email??'';
    // _textFieldControlCountryCode.text = '${widget.userDetails.countryCode??'91'}';
    _countryCode = '${widget.userDetails.countryCode??'91'}';
    _textFieldControlPhoneNumber.controller.text = widget.userDetails.phoneNumber??'';
    _textFieldControlAddress.controller.text = widget.userDetails.address??'';
  }

  getImageToPass() {
    if (_image != null) {
      String fileName = _image!.path.split('/').last;
      String? mimeType = mime(fileName);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      return dio.MultipartFile.fromFileSync(_image!.path,
          filename: fileName, contentType: MediaType(mimee, type));
    }

    return null;
  }

  callApiToEditProfile() async {
    AppDialogs.loading();
    try {
      Map<String, dynamic> body = {
        'image': getImageToPass(),
        'name': '${_textFieldControlFirstName.controller.text.trim()}  ${_textFieldControlLastName.controller.text.trim()}',
        'email': '${_textFieldControlEmail.controller.text}',
        'country_code': '$_countryCode',
        'phone_number': '${_textFieldControlPhoneNumber.controller.text}',
        'address': '${_textFieldControlAddress.controller.text}',

      };

      dio.FormData formData = dio.FormData.fromMap(body);

      UpdateProfileResponse response = await _bloc.updateProfileInfo(formData);

      if (response.success!) {
        toastMessage('${response.message}');
       if(widget.isCompleteProfile){
         Get.offAll(()=> SplashScreen());
       }else{
         Get.back();
         Get.back(result: true);
       }
      } else {
        toastMessage('${response.message!}');
        Get.back();
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  _buildImageSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 150,
      color: Colors.transparent,
      child: Container(
        height: 150.0,
        width: 150.0,
        child: Stack(children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: new BoxDecoration(
              color: Colors.black26,
              borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
              border: new Border.all(
                color: primaryColor,
                width: 4.0,
              ),
            ),
            child: ClipOval(
              child: SizedBox.expand(
                child: showImage(),
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: GestureDetector(
                child: Image.asset(
                  ('assets/images/ic_camera.png'),
                  height: 50,
                  width: 50,
                ),
                onTap: () async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 60);

    if(pickedFile!=null){
      _image = File(pickedFile.path);
      setState(() {  });
    }
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget showImage() {
    return Center(
      child: _image == null
          ? CachedNetworkImage(
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        imageUrl: "${widget.baseUrl}${widget.userDetails.imageUrl}",
        placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Center(
            child: Image(
              image:
              AssetImage('assets/images/ic_avatar.png',),color: Colors.white,
            ),
          ),
      )
          : Container(
        height: 140.0,
        width: 140.0,
        child: SizedBox.expand(
          child: Image.file(
            _image!,
            fit: BoxFit.cover,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(const Radius.circular(70.0)),
        ),
      ),
    );
  }
}
