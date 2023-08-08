import 'dart:async';
import 'dart:io';

import 'package:event_app/bloc/profile_bloc.dart';
import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/common_response.dart';

import 'package:event_app/models/wallet&prepaid_cards/fetch_user_details_model.dart';

import 'package:event_app/screens/prepaid_cards_wallet/apply_kyc_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';

import 'package:event_app/widgets/app_dialogs.dart';
import 'package:event_app/widgets/base64_converter.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/common_bottom_navigation_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class KYCDocumentsScreen extends StatefulWidget {
  const KYCDocumentsScreen({Key? key}) : super(key: key);

  @override
  State<KYCDocumentsScreen> createState() => _KYCDocumentsScreenState();
}

class _KYCDocumentsScreenState extends State<KYCDocumentsScreen> {
  ProfileBloc _profileBloc = ProfileBloc();

  fetchUserData? kycUserData;
  final TextEditingController panNumberControl = TextEditingController();
  final TextEditingController aadharNumberControl = TextEditingController();
  final TextEditingController filePasswordControl = TextEditingController();

  FormatAndValidate formatAndValidate = FormatAndValidate();
  final _formKey = GlobalKey<FormState>();
  File? pickedXmlFile;
  FilePickerResult? pickerResult;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchUserKYCDetails();
    });
  }

  Future<fetchUserData?> fetchUserKYCDetails() async {
    fetchUserData? userDetails =
        await WalletBloc().fetchUserKYCDetails(User.userId);
    setState(() {
      kycUserData = userDetails;
    });
    return kycUserData;
  }

  pickXMLFile() async {
    pickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xml']);

    if (pickerResult != null) {
      pickedXmlFile = File(pickerResult!.files.single.path!);
    }
  }

  Future showPanUpdateBottomSheet() async {
    panNumberControl.clear();
    await Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 12,
              ),
              kycDataWidget(
                // focus,
                field: "PAN number",
                labelText: "Enter your PAN Number",
                control: panNumberControl,
                keyboardInputType: TextInputType.text,
                validate: formatAndValidate.validatePANCard,
                format: formatAndValidate.formatPANCard(),
              ),
              SizedBox(
                height: 5,
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    AppDialogs.loading();
                    try {
                      String panNumber = panNumberControl.text.toString();
                      String userid = User.userId;
                      Map<String, dynamic> body = {
                        'account_id': '$userid',
                        'pan_number': '$panNumber'
                      };
                      dio.FormData formData = dio.FormData.fromMap(body);
                      CommonResponse response =
                          await _profileBloc.updateUserPanNumber(formData);
                      print(response);
                      if (response.success!) {
                        AppDialogs.closeDialog();
                        await fetchUserKYCDetails();
                        toastMessage('${response.message}');

                        Get.back();
                      }
                    } catch (e, s) {
                      Completer().completeError(e, s);
                      AppDialogs.closeDialog();
                      Get.back();
                      toastMessage('Something went wrong. Please try again');
                    }
                  } else {
                    toastMessage("Please provide valid details");
                  }
                },
                child: Text(
                  "Update PAN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: secondaryColor,
                  fixedSize: Size(screenWidth, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  side: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: secondaryColor.withOpacity(.8)),
                  primary: primaryColor,
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future showAadharUpdateBottomSheet() async {
    aadharNumberControl.clear();
    await Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 12,
              ),
              kycDataWidget(
                // focus,
                field: "Aadhar number",
                labelText: "Enter your Aadhar Number",
                control: aadharNumberControl,
                keyboardInputType: TextInputType.text,
                validate: formatAndValidate.validateAadhaar,
                format: formatAndValidate.formatAadhaar(),
              ),
              SizedBox(
                height: 5,
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    AppDialogs.loading();
                    try {
                      String aadharNumber = aadharNumberControl.text.toString();
                      String userid = User.userId;
                      Map<String, dynamic> body = {
                        'account_id': '$userid',
                        'aadar_number': '$aadharNumber'
                      };
                      dio.FormData formData = dio.FormData.fromMap(body);
                      CommonResponse response =
                          await _profileBloc.updateUserAadharNumber(formData);
                      print(response);
                      if (response.success!) {
                        AppDialogs.closeDialog();
                        await fetchUserKYCDetails();
                        toastMessage('${response.message}');

                        Get.back();
                      }
                    } catch (e, s) {
                      Completer().completeError(e, s);
                      AppDialogs.closeDialog();
                      Get.back();
                      toastMessage('Something went wrong. Please try again');
                    }
                  } else {
                    toastMessage("Please provide valid details");
                  }
                },
                child: Text(
                  "Update Aadhar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: secondaryColor,
                  fixedSize: Size(screenWidth, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  side: BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: secondaryColor.withOpacity(.8)),
                  primary: primaryColor,
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future verifyPanOrAadharBottomSheet({required VerificationType type}) async {
    filePasswordControl.clear();
    pickedXmlFile = null;
    await Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return Container(
            padding: EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Container(
                  child: ListView(shrinkWrap: true,
                      // mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          type == VerificationType.PAN
                              ? 'PAN Number'
                              : "Aadhar Number",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        type == VerificationType.PAN
                            ? textBoxWidget(
                                hintText: kycUserData?.panNumber ?? "")
                            : textBoxWidget(
                                hintText: kycUserData?.aadarNumber ?? ""),
                        SizedBox(
                          height: 5,
                        ),
                        type == VerificationType.PAN
                            ? Container()
                            : pickedXmlFile != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Color(0xfffcaf01),
                                            // border color
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color(0xff979797))),
                                        child: Icon(Icons.folder,
                                            size: 40, color: Colors.white),
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[500],
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Icon(
                                          Icons.upload_file,
                                          size: 50,
                                          color: Colors.white,
                                        )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.transparent,
                                              minimumSize:
                                                  Size(200, 30), // Set this
                                              padding: EdgeInsets.all(
                                                  12), // and this
                                            ),
                                            onPressed: () async {
                                              await pickXMLFile();
                                              setState(() {});
                                            },
                                            child: Text(
                                              "Upload XML File",
                                              style: TextStyle(fontSize: 13),
                                            ))
                                      ],
                                    ),
                                  ),
                        type == VerificationType.PAN
                            ? Container()
                            : SizedBox(
                                height: 10,
                              ),
                        type == VerificationType.PAN
                            ? Container()
                            : Text(
                                "File Password",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                        type == VerificationType.PAN
                            ? Container()
                            : textBoxWidget(
                                enabled: true,
                                control: filePasswordControl,
                                obscure: true,
                                hintText: 'Enter File Password',
                                keyboardInputType:
                                    TextInputType.visiblePassword),
                        TextButton(
                          onPressed: () async {
                            if (type == VerificationType.Aadhar) {
                              if (pickedXmlFile == null) {
                                toastMessage("Please upload file");
                                return;
                              }
                              if (filePasswordControl.text.isEmpty) {
                                toastMessage("Enter File Password");
                                return;
                              }
                            }

                            AppDialogs.loading();
                            try {
                              String userid = User.userId;
                              Map<String, dynamic> body = {
                                'account_id': '$userid',
                                'type': type == VerificationType.PAN
                                    ? 'pan_number'
                                    : 'aadar_number',
                                'id_number': type == VerificationType.PAN
                                    ? '${kycUserData!.panNumber.toString()}'
                                    : '${kycUserData!.aadarNumber.toString()}',
                                'format': type == VerificationType.PAN
                                    ? "null"
                                    : "xml",
                                'base_64_string': type == VerificationType.PAN
                                    ? "null"
                                    : FileConverter.getBase64FormateFile(
                                        pickedXmlFile!.path),
                                'file_password': type == VerificationType.PAN
                                    ? "null"
                                    : filePasswordControl.text
                              };
                              dio.FormData formData =
                                  dio.FormData.fromMap(body);
                              CommonResponse response = await _profileBloc
                                  .verifyPanOrAadhar(formData, type);
                              if (response.success!) {
                                AppDialogs.closeDialog();
                                await fetchUserKYCDetails();
                                toastMessage('${response.message}');

                                Get.back();
                              } else if (response.statusCode == 500) {
                                AppDialogs.closeDialog();
                                toastMessage('${response.message}');

                                Get.back();
                              }
                            } catch (e, s) {
                              Completer().completeError(e, s);
                              AppDialogs.closeDialog();
                              Get.back();
                              toastMessage(
                                  'Something went wrong. Please try again');
                            }
                          },
                          child: Text(
                            type == VerificationType.PAN
                                ? "Verify PAN"
                                : "Verify Aadhar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: secondaryColor,
                            fixedSize: Size(screenWidth, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            side: BorderSide(
                                width: 2,
                                style: BorderStyle.solid,
                                color: secondaryColor.withOpacity(.8)),
                            primary: primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: Size(screenWidth, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              side: BorderSide(color: secondaryColor),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Verify Later',
                                style: TextStyle(color: secondaryColor))),
                        SizedBox(
                          height: 2,
                        )
                      ]),
                )));
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  Widget textBoxWidget({
    String? hintText,
    bool? enabled,
    TextEditingController? control,
    bool? obscure,
    TextInputType? keyboardInputType = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        enabled: enabled ?? false,
        controller: control,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
            hintText: hintText ?? "",
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.grey)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.black12)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: primaryColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: primaryColor)),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8)),
      ),
    );
  }

  Widget kycDataWidget(
      //FocusNode focus,
      {String? field,
      String? labelText,
      TextEditingController? control,
      TextInputType? keyboardInputType = TextInputType.text,
      Widget? suffixWid,
      validate,
      List<TextInputFormatter>? format,
      bool? enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field!,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          enabled: enabled,
          controller: control,
          keyboardType: keyboardInputType!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: format,
          textCapitalization: TextCapitalization.characters,
          validator: (value) => validate(value),
          cursorHeight: 24,
          //onEditingComplete: () => field == "City"?focus.unfocus(): focus.unfocus(),
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus!.unfocus(),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black54),
          decoration: InputDecoration(
            suffixIcon: suffixWid,
            hintText: labelText,
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.grey)),
            border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.grey)),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget textWidget(String title) {
    return Text(title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
      bottomNavigationBar: CommonBottomNavigationWidget(),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text("Documents",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              ),
              Divider(
                thickness: 2,
              ),
              kycUserData != null
                  ? _documentsCard(
                      assetPath: 'assets/images/pan.jpeg',
                      type: VerificationType.PAN,
                      idNumber: kycUserData?.panNumber,
                      idVerified: kycUserData?.idVerified)
                  : Container(),
              SizedBox(height: 20),
              kycUserData != null
                  ? _documentsCard(
                      assetPath: 'assets/images/aadhar.jpeg',
                      type: VerificationType.Aadhar,
                      idNumber: kycUserData?.aadarNumber,
                      idVerified: kycUserData?.aadarVerified)
                  : Container()
            ]),
      ),
    );
  }

  Widget _documentsCard(
      {required VerificationType type,
      required dynamic idNumber,
      required String? idVerified,
      required String assetPath}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
      child: Card(
        elevation: 3,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        assetPath,
                        height: 50,
                        width:50,
                      ),
                      textWidget(type == VerificationType.PAN
                          ? "PAN Number"
                          : "Aadhar Number"),
                          SizedBox(width: 5,),
                          type == VerificationType.Aadhar ?
                          IconButton(onPressed: (){
                           Get.dialog(
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(22.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text("* In order to verify Aadhar you should upload XML file.Following are the steps for downloading XML file.",
                                        style: TextStyle(fontWeight:FontWeight.w600,color: Colors.black,fontSize: 18),),
                                        Divider(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text("Step 1: Go to URL www.uidai.gov.in, which is the official portal provided by Government of India for Aadhaar.",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text("Step 2: Enter 'Aadhaar Number' or 'VID' and mentioned 'Security Code' in screen, then click on 'Send OTP.",
                                         style: TextStyle(
                                          fontSize: 16,
                                        ),),
                                      SizedBox(
                                          height: 8,
                                        ),
                                        Text("Step 3: Enter the OTP received by registered Mobile Number for the given Aadhaar Number.",
                                         style: TextStyle(
                                          fontSize: 16,
                                        ),),
                                         SizedBox(
                                          height: 8,
                                        ),
                                        Text("Step 4: Create Password for Aadhaar XML. Enter a Share Code which will become the password for the ZIP file.",
                                         style: TextStyle(
                                          fontSize: 16,
                                        ),),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text("Step 5: Aadhaar XML is securely packed into a ZIP file with password protection. Download the ZIP file and store in your computer at a safe location. This Aadhaar XML will be used to establish identity when applying Digital Signature.",
                                         style: TextStyle(
                                          fontSize: 16,
                                        ),),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        CloseButton(),
                                      ],
                                    ),
                                    
                                  ),
                                ),
                              ),
                            )
                           );
                          }, icon: Icon(Icons.info_outline_rounded))
                          :SizedBox(),

                         
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  idNumber != null
                      ? Divider(
                          color: Colors.black.withOpacity(0.5),
                        )
                      : Container(),
                  SizedBox(
                    height: 8,
                  ),
                  idNumber == null
                      ? Container()
                      : Row(
                          children: [
                            Text(
                              '${(idNumber).replaceAllMapped(RegExp(r'.(?=.{4})'), (match) => '*')}',
                              style: TextStyle(fontSize: 16),
                            ),
                            idVerified == "yes" ? Spacer() : Container(),
                            idVerified == "yes"
                                ? Icon(
                                    Icons.verified_user,
                                    color: Colors.green,
                                  )
                                : Container()
                          ],
                        ),
                  idVerified == "no" && idNumber != null
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: OutlinedButton(
                              onPressed: () async {
                                await verifyPanOrAadharBottomSheet(
                                    type: type == VerificationType.PAN
                                        ? VerificationType.PAN
                                        : VerificationType.Aadhar);
                              },
                              style: OutlinedButton.styleFrom(
                                primary: secondaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                side: BorderSide(color: secondaryColor),
                              ),
                              child: Text(
                                "Verify",
                                style: TextStyle(color: secondaryColor),
                              )),
                        )
                      : Container(),
                ],
              ),
            ),
            idNumber != null
                ? Positioned(
                    top: 8,
                    right: 2,
                    child: Row(
                      children: [
                        Text(
                          "Updated",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  )
                : Positioned(
                    top: 1,
                    right: 10,
                    child: OutlinedButton(
                        onPressed: () async {
                          type == VerificationType.PAN
                              ? await showPanUpdateBottomSheet()
                              : await showAadharUpdateBottomSheet();
                        },
                        style: OutlinedButton.styleFrom(
                          primary: secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          side: BorderSide(color: secondaryColor),
                        ),
                        child: Text(
                          "Update",
                          style: TextStyle(color: secondaryColor),
                        )),
                  )
          ],
        ),
      ),
    );
  }
  
}
