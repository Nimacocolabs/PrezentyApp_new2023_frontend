import 'dart:convert';

import 'package:event_app/bloc/wallet_bloc.dart';
import 'package:event_app/models/wallet&prepaid_cards/register_wallet_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/state_data_response.dart';
import 'package:event_app/models/wallet&prepaid_cards/terms_and_conditions_model.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/repositories/profile_repository.dart';
import 'package:event_app/screens/login/select_country_dialog_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/apply_kyc_verify_otp_screen.dart';
import 'package:event_app/screens/prepaid_cards_wallet/my_cards_wallet/wallet_home_screen.dart';
import 'package:event_app/screens/splash_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/CommonApiErrorWidget.dart';
import 'package:event_app/widgets/CommonApiLoader.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'dart:async';
import '../../util/app_helper.dart';
import 'package:http/http.dart' as http;

class ApplyKycScreen extends StatefulWidget {
  ApplyKycScreen(
      {Key? key,
      required this.razorPayId,
      required this.cardId,
      required this.firstName,
      required this.lastName,
      required this.panNumber})
      : super(key: key);
  final String? razorPayId;
  final String cardId;
  final String firstName;
  final String lastName;
  final String panNumber;

  @override
  State<ApplyKycScreen> createState() => _ApplyKycScreenState();
}

class _ApplyKycScreenState extends State<ApplyKycScreen> {
  WalletBloc _walletBloc = WalletBloc();
  Set<String> selectedCategories = {};
  final TextEditingController firstNameControl = TextEditingController();
  final TextEditingController middleNameControl = TextEditingController();
  final TextEditingController lastNameControl = TextEditingController();
  final TextEditingController phoneNumberControl = TextEditingController();
  final TextEditingController emailIdControl = TextEditingController();
  final TextEditingController panNumberControl = TextEditingController();
  final TextEditingController countryControl = TextEditingController();
  final TextEditingController dobControl = TextEditingController();
  final TextEditingController address1Control = TextEditingController();
  final TextEditingController address2Control = TextEditingController();
  final TextEditingController address3Control = TextEditingController();

  final TextEditingController permanentAddress1Control =
      TextEditingController();
  final TextEditingController permanentAddress2Control =
      TextEditingController();
  final TextEditingController permanentAddress3Control =
      TextEditingController();
  final TextEditingController permanentpinNumberControl =
      TextEditingController();
  final TextEditingController permanentcityControl = TextEditingController();

  final TextEditingController homeAddress1Control = TextEditingController();
  final TextEditingController homeAddress2Control = TextEditingController();
  final TextEditingController homeAddress3Control = TextEditingController();
  final TextEditingController homepinNumberControl = TextEditingController();
  final TextEditingController homecityControl = TextEditingController();
  String entityId = "";
  String categories = "";
  final TextEditingController officeAddress1Control = TextEditingController();
  final TextEditingController officeAddress2Control = TextEditingController();
  final TextEditingController officeAddress3Control = TextEditingController();
  final TextEditingController officepinNumberControl = TextEditingController();
  final TextEditingController officecityControl = TextEditingController();

  final TextEditingController deliveryAddress1Control = TextEditingController();
  final TextEditingController deliveryAddress2Control = TextEditingController();
  final TextEditingController deliveryAddress3Control = TextEditingController();
  final TextEditingController deliverypinNumberControl =
      TextEditingController();
  final TextEditingController deliverycityControl = TextEditingController();

  final TextEditingController communicationAddress1Control =
      TextEditingController();
  final TextEditingController communicationAddress2Control =
      TextEditingController();
  final TextEditingController communicationAddress3Control =
      TextEditingController();
  final TextEditingController communicationpinNumberControl =
      TextEditingController();
  final TextEditingController OtpNumberControl = TextEditingController();
  final TextEditingController communicationcityControl =
      TextEditingController();

  final TextEditingController referredByControl = TextEditingController();
  bool isNricustomer = false;
  bool isMinor = false;
  bool isDependant = false;
  String? addressType;
  States? selectedState;
  String? birthDateInString;
  DateTime? birthDate;
  bool? isDateSelected;
  String title = "title";
  int _titleValue = 0;
  String gender = "select";
  int _genderValue = 0;
  String marital_status = "select";
  int _maritalStatusValue = 0;
  RxBool isChecked = false.obs;
  TermsAndConditionsData? terms_Conditions;
  String _employmentIndustryValue = "";
  String employmentIndustry = "Select";
  String _employmentTypeValue = "";
  String employmentType = "Select";
  String address_status = "select";
  int _addressValue = 0;

  Country _country = Country(
    isoCode: "IN",
    phoneCode: "+91",
    name: "India",
    iso3Code: "IND",
  );

  final _formKey = GlobalKey<FormState>();
  FormatAndValidate formatAndValidate = FormatAndValidate();
  List<States> stateList = [];

  Future _getStateList() async {
    AppDialogs.loading();
    StateCodeResponse? response = await _walletBloc.getStateList();
    stateList = response?.data ?? [];
    AppDialogs.closeDialog();
    if (stateList.isEmpty) {
      Get.back();
      toastMessage('Unable to get states. Please try again');
    } else {
      setState(() {});
    }
  }

  Future<TermsAndConditionsData?> getTermsAndConditions() async {
    TermsAndConditionsData? data = (await _walletBloc.termsAndConditions());
    setState(() {
      terms_Conditions = data;
    });
    return terms_Conditions;
  }
  // late FocusNode focus;

  @override
  void initState() {
    super.initState();

    firstNameControl.text = widget.firstName;
    lastNameControl.text = widget.lastName;
    panNumberControl.text = widget.panNumber;

    emailIdControl.text = User.userEmail;
    phoneNumberControl.text = "${_country.phoneCode}-${User.userMobile}";
    countryControl.text = _country.name;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getStateList();
      getTermsAndConditions();
    });
  }

  @override
  void dispose() {
    _walletBloc.dispose();
    //focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAll(() => MainScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 48,
                      width: screenWidth * 0.3,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          alignment: AlignmentDirectional.centerEnd,
                          underline: Container(),
                          elevation: 0,
                          // isDense: true,
                          iconSize: 30,
                          //  icon: Icon(Icons.arrow_downward_rounded),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 16),
                          value: _titleValue,
                          items: [
                            DropdownMenuItem(
                              child: Text("Title"),
                              value: 0,
                            ),
                            DropdownMenuItem(
                              child: Text("Mr"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Ms"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Mrs"),
                              value: 3,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _titleValue = value as int;
                              value == 1
                                  ? title = "Mr"
                                  : value == 2
                                      ? title = "Ms"
                                      : title = "Mrs";
                            });
                            print(_titleValue.toString);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: kycDataWidget(
                        // focus,
                        field: "",
                        labelText: "first Name",
                        control: firstNameControl,
                        validate: formatAndValidate.validateName,
                        format: formatAndValidate.formatName(),
                      ),
                    ),
                  ],
                ),
                kycDataWidget(
                  //focus,
                  field: "Middle Name",
                  labelText: "middle Name",
                  control: middleNameControl,
                  validate: formatAndValidate.validateName,
                  format: formatAndValidate.formatName(),
                ),
                kycDataWidget(
                  //focus,
                  field: "Last Name",
                  labelText: "last Name",
                  control: lastNameControl,
                  validate: formatAndValidate.validateName,
                  format: formatAndValidate.formatName(),
                ),
                kycDataWidget(
                  //focus,
                  field: "Phone number",
                  labelText: "Phone Number",
                  control: phoneNumberControl,
                  keyboardInputType: TextInputType.phone,
                  validate: formatAndValidate.validatePhoneNo,
                  format: formatAndValidate.formatPhone(),
                  enabled: false,
                ),
                kycDataWidget(
                  //focus,
                  field: "Email ID",
                  labelText: "Email ID",
                  control: emailIdControl,
                  keyboardInputType: TextInputType.emailAddress,
                  validate: formatAndValidate.validateEmailID,
                  format: formatAndValidate.formatEmail(),
                  enabled: false,
                ),
                kycDataWidget(
                  //focus,
                  field: "Date of Birth",
                  labelText: "YYYY-MM-DD",
                  control: dobControl,
                  keyboardInputType: TextInputType.number,
                  validate: formatAndValidate.validateDob,
                  format: formatAndValidate.formatDateOfBirth(),
                  suffixWid: _calenderDatePick(),
                ),
                kycDataWidget(
                  // focus,
                  field: "PAN number",
                  labelText: "PAN Number",
                  control: panNumberControl,
                  keyboardInputType: TextInputType.text,
                  validate: formatAndValidate.validatePANCard,
                  format: formatAndValidate.formatPANCard(),
                ),
                Text(
                  "Gender",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  width: screenWidth - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      alignment: AlignmentDirectional.centerEnd,
                      underline: Container(),
                      elevation: 0,
                      // isDense: true,
                      iconSize: 30,
                      //  icon: Icon(Icons.arrow_downward_rounded),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 16),
                      value: _genderValue,
                      items: [
                        DropdownMenuItem(
                          child: Text("select"),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text("Male"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Female"),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("Other"),
                          value: 3,
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _genderValue = value as int;
                          value == 1
                              ? gender = "Male"
                              : value == 2
                                  ? gender = "Female"
                                  : gender = "Other";
                        });
                        print(_genderValue.toString);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Marital",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  width: screenWidth - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      alignment: AlignmentDirectional.centerEnd,
                      underline: Container(),
                      elevation: 0,
                      // isDense: true,
                      iconSize: 30,
                      //  icon: Icon(Icons.arrow_downward_rounded),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 16),
                      value: _maritalStatusValue,
                      items: [
                        DropdownMenuItem(
                          child: Text("select"),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text("Single"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Married"),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("Others"),
                          value: 3,
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _maritalStatusValue = value as int;
                          value == 1
                              ? marital_status = "Single"
                              : value == 2
                                  ? marital_status = "Married"
                                  : marital_status = "Others";
                        });
                        print(_maritalStatusValue.toString);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "NRI Customer",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 50,
                      width: 60,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: isNricustomer,
                          activeColor: primaryColor,
                          activeTrackColor: Colors.grey[350],
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[350],
                          onChanged: (check) {
                            setState(() {
                              isNricustomer = check;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Minor",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    Spacer(),
                    SizedBox(
                      height: 50,
                      width: 60,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: isMinor,
                          activeColor: primaryColor,
                          activeTrackColor: Colors.grey[350],
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[350],
                          onChanged: (check) {
                            setState(() {
                              isMinor = check;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Dependant",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 50,
                      width: 60,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: isDependant,
                          activeColor: primaryColor,
                          activeTrackColor: Colors.grey[350],
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[350],
                          onChanged: (check) {
                            setState(() {
                              isDependant = check;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Employment Industry",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  width: screenWidth - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      alignment: Alignment.centerLeft,
                      underline: Container(),
                      elevation: 0,
                      // isDense: true,
                      iconSize: 30,
                      //  icon: Icon(Icons.arrow_downward_rounded),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 11.2),
                      value: _employmentIndustryValue,
                      items: [
                        DropdownMenuItem(
                          child: Text("select"),
                          value: "",
                        ),
                        DropdownMenuItem(
                          child: Text("AGRICULTURE FOOD NATURAL RESOURCES"),
                          value: "AGRICULTURE_FOOD_NATURAL_RESOURCES",
                        ),
                        DropdownMenuItem(
                          child: Text("ARCHITECTURE AND CONSTRUCTION"),
                          value: "ARCHITECTURE_AND_CONSTRUCTION",
                        ),
                        DropdownMenuItem(
                          child: Text(
                              "ARTS AUDIO OR VIDEO TECHNOLOGY \nAND COMMUNICATIONS"),
                          value:
                              "ARTS_AUDIO_OR_VIDEO_TECHNOLOGY_AND_COMMUNICATIONS",
                        ),
                        DropdownMenuItem(
                          child: Text("BUSINESS MANAGEMENT AND ADMINISTRATION"),
                          value: "BUSINESS_MANAGEMENT_AND_ADMINISTRATION",
                        ),
                        DropdownMenuItem(
                          child: Text("EDUCATION AND TRAINING"),
                          value: "EDUCATION_AND_TRAINING",
                        ),
                        DropdownMenuItem(
                          child: Text("FINANCE"),
                          value: "FINANCE",
                        ),
                        DropdownMenuItem(
                          child: Text("GOVERNMENT AND PUBLIC ADMINISTRATION"),
                          value: "GOVERNMENT_AND_PUBLIC_ADMINISTRATION",
                        ),
                        DropdownMenuItem(
                          child: Text("HEALTH SCIENCE"),
                          value: "HEALTH_SCIENCE",
                        ),
                        DropdownMenuItem(
                          child: Text("HOSPITALITY AND TOURISM"),
                          value: "HOSPITALITY_AND_TOURISM",
                        ),
                        DropdownMenuItem(
                          child: Text("HUMAN SERVICES"),
                          value: "HUMAN_SERVICES",
                        ),
                        DropdownMenuItem(
                          child: Text("INFORMATION TECHNOLOGY"),
                          value: "INFORMATION_TECHNOLOGY",
                        ),
                        DropdownMenuItem(
                          child: Text(
                              "LAW PUBLIC SAFETY CORRECTIONS AND SECURITY"),
                          value: "LAW_PUBLIC_SAFETY_CORRECTIONS_AND_SECURITY",
                        ),
                        DropdownMenuItem(
                          child: Text("MANUFACTURING"),
                          value: "MANUFACTURING",
                        ),
                        DropdownMenuItem(
                          child: Text("MARKETING SALES AND SERVICE"),
                          value: "MARKETING_SALES_AND_SERVICE",
                        ),
                        DropdownMenuItem(
                          child: Text(
                              "SCIENCE TECHNOLOGY ENGINEERING AND MATHEMATICS"),
                          value:
                              "SCIENCE_TECHNOLOGY_ENGINEERING_AND_MATHEMATICS",
                        ),
                        DropdownMenuItem(
                          child:
                              Text("TRANSPORTATION DISTRIBUTION AND LOGISTICS"),
                          value: "TRANSPORTATION_DISTRIBUTION_AND_LOGISTICS",
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _employmentIndustryValue = value as String;
                          value == "AGRICULTURE_FOOD_NATURAL_RESOURCES"
                              ? employmentIndustry =
                                  "AGRICULTURE FOOD NATURAL RESOURCES"
                              : value == "ARCHITECTURE_AND_CONSTRUCTION"
                                  ? employmentIndustry =
                                      "ARCHITECTURE AND CONSTRUCTION"
                                  : value ==
                                          "ARTS_AUDIO_OR_VIDEO_TECHNOLOGY_AND_COMMUNICATIONS"
                                      ? employmentIndustry =
                                          "ARTS AUDIO OR VIDEO TECHNOLOGY AND COMMUNICATIONS"
                                      : value ==
                                              "BUSINESS_MANAGEMENT_AND_ADMINISTRATION"
                                          ? employmentIndustry =
                                              "BUSINESS MANAGEMENT AND ADMINISTRATION"
                                          : value == "EDUCATION_AND_TRAINING"
                                              ? employmentIndustry =
                                                  "EDUCATION AND TRAINING"
                                              : value == "FINANCE"
                                                  ? employmentIndustry =
                                                      "FINANCE"
                                                  : value ==
                                                          "GOVERNMENT_AND_PUBLIC_ADMINISTRATION"
                                                      ? employmentIndustry =
                                                          "GOVERNMENT AND PUBLIC ADMINISTRATION"
                                                      : value ==
                                                              "HEALTH_SCIENCE"
                                                          ? employmentIndustry =
                                                              "HEALTH SCIENCE"
                                                          : value ==
                                                                  "HOSPITALITY_AND_TOURISM"
                                                              ? employmentIndustry =
                                                                  "HOSPITALITY AND TOURISM"
                                                              : value ==
                                                                      "HUMAN_SERVICES"
                                                                  ? employmentIndustry =
                                                                      "HUMAN SERVICES"
                                                                  : value ==
                                                                          "INFORMATION_TECHNOLOGY"
                                                                      ? employmentIndustry =
                                                                          "INFORMATION TECHNOLOGY"
                                                                      : value ==
                                                                              "LAW_PUBLIC_SAFETY_CORRECTIONS_AND_SECURITY"
                                                                          ? employmentIndustry =
                                                                              "LAW PUBLIC SAFETY CORRECTIONS AND SECURITY"
                                                                          : value == "MANUFACTURING"
                                                                              ? employmentIndustry = "MANUFACTURING"
                                                                              : value == "MARKETING_SALES_AND_SERVICE"
                                                                                  ? employmentIndustry = "MARKETING SALES AND SERVICE"
                                                                                  : value == "SCIENCE_TECHNOLOGY_ENGINEERING_AND_MATHEMATICS"
                                                                                      ? employmentIndustry = "SCIENCE TECHNOLOGY ENGINEERING AND MATHEMATICS"
                                                                                      : value == "TRANSPORTATION_DISTRIBUTION_AND_LOGISTICS"
                                                                                          ? employmentIndustry == "TRANSPORTATION DISTRIBUTION AND LOGISTICS"
                                                                                          : employmentIndustry = "";
                        });
                        print(_employmentIndustryValue.toString);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Employment Type",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  width: screenWidth - 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      alignment: Alignment.centerLeft,
                      underline: Container(),
                      elevation: 0,
                      // isDense: true,
                      iconSize: 30,
                      //  icon: Icon(Icons.arrow_downward_rounded),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 12),
                      value: _employmentTypeValue,
                      items: [
                        DropdownMenuItem(
                          child: Text("select"),
                          value: "",
                        ),
                        DropdownMenuItem(
                          child: Text("EMPLOYED"),
                          value: "EMPLOYED",
                        ),
                        DropdownMenuItem(
                          child: Text("UNEMPLOYED"),
                          value: "UNEMPLOYED",
                        ),
                        DropdownMenuItem(
                          child: Text("ENTREPRENEUR"),
                          value: "ENTREPRENEUR",
                        ),
                        DropdownMenuItem(
                          child: Text("PUBLIC SECTOR EMPLOYEE"),
                          value: "PUBLIC_SECTOR_EMPLOYEE",
                        ),
                        DropdownMenuItem(
                          child: Text("FREELANCER"),
                          value: "FREELANCER",
                        ),
                        DropdownMenuItem(
                          child: Text("HOUSEWORK"),
                          value: "HOUSEWORK",
                        ),
                        DropdownMenuItem(
                          child: Text("APPRENTICE"),
                          value: "APPRENTICE",
                        ),
                        DropdownMenuItem(
                          child: Text("RETIRED"),
                          value: "RETIRED",
                        ),
                        DropdownMenuItem(
                          child: Text("STUDENT"),
                          value: "STUDENT",
                        ),
                        DropdownMenuItem(
                          child: Text("SELF EMPLOYED"),
                          value: "SELF_EMPLOYED",
                        ),
                        DropdownMenuItem(
                          child: Text("MILITARY OR COMMUNITY SERVICE"),
                          value: "MILITARY_OR_COMMUNITY_SERVICE",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _employmentTypeValue = value as String;
                          value == "EMPLOYED"
                              ? employmentType = "EMPLOYED"
                              : value == "UNEMPLOYED"
                                  ? employmentType = "UNEMPLOYED"
                                  : value == "ENTREPRENEUR"
                                      ? employmentType = "ENTREPRENEUR"
                                      : value == "PUBLIC_SECTOR_EMPLOYEE"
                                          ? employmentType =
                                              "PUBLIC SECTOR EMPLOYEE"
                                          : value == "FREELANCER"
                                              ? employmentType = "FREELANCER"
                                              : value == "HOUSEWORK"
                                                  ? employmentType = "HOUSEWORK"
                                                  : value == "APPRENTICE"
                                                      ? employmentType =
                                                          "APPRENTICE"
                                                      : value == "RETIRED"
                                                          ? employmentType =
                                                              "RETIRED"
                                                          : value == "STUDENT"
                                                              ? employmentType =
                                                                  "STUDENT"
                                                              : value ==
                                                                      "SELF_EMPLOYED"
                                                                  ? employmentType =
                                                                      "SELF EMPLOYED"
                                                                  : value ==
                                                                          "MILITARY_OR_COMMUNITY_SERVICE"
                                                                      ? employmentType =
                                                                          "MILITARY OR COMMUNITY SERVICE"
                                                                      : employmentType ==
                                                                          "";
                        });
                        print(_employmentIndustryValue.toString);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor), // Outer border styling
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTileCard(
                    shadowColor: primaryColor,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    baseColor: Colors.grey[300],
                    // leading: CircleAvatar(backgroundColor: ColorConstant.green6320,
                    //     child: Text(numbering[index],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
                    title: Text(
                      "Permanent Address",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            10), // Adjust the padding for the children
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              thickness: 1.5,
                              height: 1.0,
                            ),
                            kycDataWidget(
                                //focus,
                                field: "Address 1",
                                labelText: "Enter",
                                control: permanentAddress1Control,
                                validate: formatAndValidate.validateAddress,
                                format: formatAndValidate.formatAddress()),
                            kycDataWidget(
                                //focus,
                                field: "Address 2",
                                labelText: "Enter",
                                control: permanentAddress2Control,
                                validate: formatAndValidate.validateAddress,
                                format: formatAndValidate.formatAddress()),
                            kycDataWidget(
                                //focus,
                                field: "Address 3",
                                labelText: "Enter",
                                control: permanentAddress3Control,
                                validate: formatAndValidate.validateAddress,
                                format: formatAndValidate.formatAddress()),
                            kycDataWidget(
                                //focus,
                                field: "City",
                                labelText: "Enter",
                                control: permanentcityControl,
                                validate: formatAndValidate.validateName,
                                keyboardInputType: TextInputType.name),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                "State",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _stateList(),
                            kycDataWidget(
                              //focus,
                              field: "Country",
                              labelText: "Enter",
                              control: countryControl,
                              keyboardInputType: TextInputType.text,
                              validate: formatAndValidate.formatName,
                              format: formatAndValidate.formatName(),
                              enabled: false,
                            ),
                            kycDataWidget(
                                //focus,
                                field: "Pin Code",
                                labelText: "Enter",
                                control: permanentpinNumberControl,
                                keyboardInputType: TextInputType.number,
                                validate: formatAndValidate.validatePinCode,
                                format: formatAndValidate.formatPinCode()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Add another address",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: primaryColor), // Outer border styling
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTileCard(
                    shadowColor: primaryColor,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    baseColor: Colors.grey[300],
                    title: Text(
                      "Address",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            10), // Adjust the padding for the children
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              thickness: 1.5,
                              height: 1.0,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Container(
                            //   height: 48,
                            //   width: screenWidth - 20,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(
                            //         width: 2,
                            //         color: primaryColor,
                            //       ),
                            //       borderRadius: BorderRadius.circular(8)),
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton(
                            //       alignment: Alignment.centerLeft,
                            //       underline: Container(),
                            //       elevation: 0,
                            //       // isDense: true,
                            //       iconSize: 30,
                            //       //  icon: Icon(Icons.arrow_downward_rounded),
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           color: Colors.black54,
                            //           fontSize: 16),
                            //       value: _addressValue,
                            //       items: [
                            //         DropdownMenuItem(
                            //           child: Text("select"),
                            //           value: 0,
                            //         ),
                            //         DropdownMenuItem(
                            //           child: Text("HOME"),
                            //           value: 1,
                            //         ),
                            //         DropdownMenuItem(
                            //           child: Text("OFFICE"),
                            //           value: 2,
                            //         ),
                            //         DropdownMenuItem(
                            //           child: Text("DELIVERY"),
                            //           value: 3,
                            //         ),
                            //         DropdownMenuItem(
                            //           child: Text("COMMUNICATION"),
                            //           value: 4,
                            //         )
                            //       ],
                            //       onChanged: (value) {
                            //         setState(() {
                            //           _addressValue = value as int;
                            //           value == 1
                            //               ? address_status = "HOME"
                            //               : value == 2
                            //               ? marital_status = "OFFICE"
                            //               : value == 3 ? marital_status = "DELIVERY"
                            //               : marital_status = "COMMUNICATION";
                            //           _addressValue = value as int;
                            //         });
                            //         print(_maritalStatusValue.toString);
                            //       },
                            //     ),
                            //   ),
                            // ),
                            Text(
                              'Select Address Categories:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            buildCategoryRadioButton('HOME'),
                            if (selectedCategories.contains('HOME'))
                              Column(
                                children: [
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 1",
                                      labelText: "Enter",
                                      control: homeAddress1Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 2",
                                      labelText: "Enter",
                                      control: homeAddress2Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 3",
                                      labelText: "Enter",
                                      control: homeAddress3Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "City",
                                      labelText: "Enter",
                                      control: homecityControl,
                                      validate: formatAndValidate.validateName,
                                      keyboardInputType: TextInputType.name),
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Text(
                                      "State",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _stateList(),
                                  kycDataWidget(
                                    //focus,
                                    field: "Country",
                                    labelText: "Enter",
                                    control: countryControl,
                                    keyboardInputType: TextInputType.text,
                                    validate: formatAndValidate.formatName,
                                    format: formatAndValidate.formatName(),
                                    enabled: false,
                                  ),
                                  kycDataWidget(
                                      //focus,
                                      field: "Pin Code",
                                      labelText: "Enter",
                                      control: homepinNumberControl,
                                      keyboardInputType: TextInputType.number,
                                      validate:
                                          formatAndValidate.validatePinCode,
                                      format:
                                          formatAndValidate.formatPinCode()),
                                ],
                              ),
                            buildCategoryRadioButton('OFFICE'),
                            if (selectedCategories.contains('OFFICE'))
                              Column(
                                children: [
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 1",
                                      labelText: "Enter",
                                      control: officeAddress1Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 2",
                                      labelText: "Enter",
                                      control: officeAddress2Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 3",
                                      labelText: "Enter",
                                      control: officeAddress3Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "City",
                                      labelText: "Enter",
                                      control: officecityControl,
                                      validate: formatAndValidate.validateName,
                                      keyboardInputType: TextInputType.name),
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Text(
                                      "State",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _stateList(),
                                  kycDataWidget(
                                    //focus,
                                    field: "Country",
                                    labelText: "Enter",
                                    control: countryControl,
                                    keyboardInputType: TextInputType.text,
                                    validate: formatAndValidate.formatName,
                                    format: formatAndValidate.formatName(),
                                    enabled: false,
                                  ),
                                  kycDataWidget(
                                      //focus,
                                      field: "Pin Code",
                                      labelText: "Enter",
                                      control: officepinNumberControl,
                                      keyboardInputType: TextInputType.number,
                                      validate:
                                          formatAndValidate.validatePinCode,
                                      format:
                                          formatAndValidate.formatPinCode()),
                                ],
                              ),
                            buildCategoryRadioButton('DELIVERY'),
                            if (selectedCategories.contains('DELIVERY'))
                              Column(
                                children: [
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 1",
                                      labelText: "Enter",
                                      control: deliveryAddress1Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 2",
                                      labelText: "Enter",
                                      control: deliveryAddress2Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 3",
                                      labelText: "Enter",
                                      control: deliveryAddress3Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "City",
                                      labelText: "Enter",
                                      control: deliverycityControl,
                                      validate: formatAndValidate.validateName,
                                      keyboardInputType: TextInputType.name),
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Text(
                                      "State",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _stateList(),
                                  kycDataWidget(
                                    //focus,
                                    field: "Country",
                                    labelText: "Enter",
                                    control: countryControl,
                                    keyboardInputType: TextInputType.text,
                                    validate: formatAndValidate.formatName,
                                    format: formatAndValidate.formatName(),
                                    enabled: false,
                                  ),
                                  kycDataWidget(
                                      //focus,
                                      field: "Pin Code",
                                      labelText: "Enter",
                                      control: deliverypinNumberControl,
                                      keyboardInputType: TextInputType.number,
                                      validate:
                                          formatAndValidate.validatePinCode,
                                      format:
                                          formatAndValidate.formatPinCode()),
                                ],
                              ),
                            buildCategoryRadioButton('COMMUNICATION'),
                            if (selectedCategories.contains('COMMUNICATION'))
                              Column(
                                children: [
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 1",
                                      labelText: "Enter",
                                      control: communicationAddress1Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 2",
                                      labelText: "Enter",
                                      control: communicationAddress2Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "Address 3",
                                      labelText: "Enter",
                                      control: communicationAddress3Control,
                                      validate:
                                          formatAndValidate.validateAddress,
                                      format:
                                          formatAndValidate.formatAddress()),
                                  kycDataWidget(
                                      //focus,
                                      field: "City",
                                      labelText: "Enter",
                                      control: communicationcityControl,
                                      validate: formatAndValidate.validateName,
                                      keyboardInputType: TextInputType.name),
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Text(
                                      "State",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _stateList(),
                                  kycDataWidget(
                                    //focus,
                                    field: "Country",
                                    labelText: "Enter",
                                    control: countryControl,
                                    keyboardInputType: TextInputType.text,
                                    validate: formatAndValidate.formatName,
                                    format: formatAndValidate.formatName(),
                                    enabled: false,
                                  ),
                                  kycDataWidget(
                                      //focus,
                                      field: "Pin Code",
                                      labelText: "Enter",
                                      control: communicationpinNumberControl,
                                      keyboardInputType: TextInputType.number,
                                      validate:
                                          formatAndValidate.validatePinCode,
                                      format:
                                          formatAndValidate.formatPinCode()),
                                ],
                              ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "NOTE: Please prevent @,#,%,\$,\&,+,=,*,"
                  ",! and white spaces while entering your address.",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 20,
                ),
                kycDataWidget(
                  // focus,
                  field: "Referred person name",
                  labelText: "Referred person name",
                  control: referredByControl,
                  keyboardInputType: TextInputType.text,
                  validate: (v) {},
                  format: [],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 170,
                      child: kycDataWidget(
                          //focus,
                          field: "Enter OTP",
                          labelText: "Enter",
                          control: OtpNumberControl,
                          keyboardInputType: TextInputType.number,
                          validate: formatAndValidate.validateOtp,
                          format: formatAndValidate.formatPinCode()),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await generateotp();
                        },
                        child: Text("Generate Otp")),
                  ],
                ),
                terms_Conditions != null
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade300)),
                        width: double.infinity,
                        height: 200,
                        child: Scrollbar(
                          thumbVisibility: true,
                          interactive: true,
                          child: ListView(
                            padding: EdgeInsets.all(4),
                            children: [
                              HtmlWidget('${terms_Conditions!.termsCondition}'),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Row(
                  children: [
                    Obx(() => Checkbox(
                        value: isChecked.value,
                        onChanged: (v) {
                          isChecked.value = v ?? false;
                        })),
                    Text.rich(
                      TextSpan(children: [
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'I accept ',
                          ),
                        )),
                        WidgetSpan(
                            // child: InkWell(
                            //     onTap: () async {
                            // if (await canLaunch(
                            //     termsAndConditionsCardUrl)) {
                            //   await launch(termsAndConditionsCardUrl);
                            // } else {
                            //   toastMessage(
                            //       'Unable to open url $termsAndConditionsCardUrl');
                            // }
                            // },
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        )
                            // )
                            )
                      ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    if (selectedState == null) {
                      toastMessage('Select state');
                      return;
                    }
                    if (_formKey.currentState!.validate() &&
                        _genderValue != 0 &&
                        selectedState != null) {
                      if (!isChecked.value) {
                        toastMessage(
                            'Please accept the terms & conditions to continue');
                        return;
                      }
                      print("xxxxxxxx");

                      _sendOtp(
                          fName: firstNameControl.text,
                          lName: lastNameControl.text,
                          mName: middleNameControl.text,
                          pan: panNumberControl.text,
                          dob: dobControl.text,
                          otp: OtpNumberControl.text.toString(),
                          gender: gender,
                          address: address1Control.text,
                          pinCode: permanentpinNumberControl.text,
                          city: permanentcityControl.text,
                          //aadhaarNumber: aadhaarControl.text,
                          state: (selectedState?.stateId ?? 0).toString());
                    } else if (_genderValue == 0) {
                      toastMessage("Please select your gender");
                    } else {
                      toastMessage("Please fill all field with valid details");
                    }
                  },
                  child: Text(
                    "Create Wallet",
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryRadioButton(String category) {
    return Row(
      children: [
        Checkbox(
          value: selectedCategories.contains(category),
          onChanged: (value) {
            setState(() {
              if (value != null && value) {
                selectedCategories.add(category);
                categories = category;
                print("category->${category}");
              } else {
                selectedCategories.remove(category);
              }
            });
          },
        ),
        Text(category),
      ],
    );
  }

  Widget _stateList() {
    // if(dropDownValue==null){
    //   dropDownValue =  response.data?.elementAt(response.data!.length-1);
    //   state = dropDownValue?.stateTitle;
    //   stateCode = dropDownValue?.stateId;
    // }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor, width: 2)),
      child: DropdownButton<States>(
        value: selectedState,
        isExpanded: true,
        // menuMaxHeight: 300,
        underline: SizedBox(),
        onChanged: (States? data) {
          setState(() {
            selectedState = data!;
          });
        },
        items: stateList.map<DropdownMenuItem<States>>((value) {
          return DropdownMenuItem<States>(
            value: value,
            child: Text(
              value.stateTitle ?? 'Select state',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54),
            ),
          );
        }).toList(),
      ),
    );

    //   return Container(
    //   width: screenWidth,
    //   decoration: BoxDecoration(
    //       border: Border.all(
    //           color: primaryColor, width: 2, style: BorderStyle.solid),
    //       borderRadius: BorderRadius.circular(10)),
    //   child: Padding(
    //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
    //     child: DropdownButtonHideUnderline(
    //       child: DropdownButton<States>(
    //         style: TextStyle(color: secondaryColor),
    //         alignment: AlignmentDirectional.centerStart,
    //         hint: Text(
    //           "Select State",
    //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //         ),
    //         value: dropDownValue,
    //         items: response.data!.map((item) {
    //           // dropDownValue = item;
    //           return DropdownMenuItem<States>(
    //             onTap: (){
    //               dropDownValue = item;
    //                 state = item.stateTitle;
    //                 stateCode = item.stateId;
    //                 setState(() {});
    //             },
    //               value: dropDownValue,
    //               child: Text(item.stateTitle!,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w700,
    //                       color: Colors.black54,
    //                       fontSize: 16)));
    //         }).toList(),
    //         onChanged: (value) {
    //           // dropDownValue = value;
    //           // state = value!.stateTitle;
    //           // stateCode = value.stateId;
    //           // setState(() {});
    //         },
    //       ),
    //     ),
    //   ),
    // );
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
                borderSide: BorderSide(width: 2, color: primaryColor)),
            border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: primaryColor)),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  _calenderDatePick() {
    return GestureDetector(
        child: new Icon(Icons.calendar_today, color: primaryColor),
        onTap: () async {
          final datePick = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(1900),
              lastDate: new DateTime(2100));
          if (datePick != null && datePick != birthDate) {
            setState(() {
              birthDate = datePick;
              isDateSelected = true;

              // put it here
              birthDateInString =
                  "${birthDate!.year}-${birthDate!.month}-${birthDate!.day}"; // 08/14/2019
              dobControl.text = birthDateInString!;
            });
          }
        });
  }

  Future generateotp() async {
    try {
      AppDialogs.loading();
      Map<String, dynamic> data = {
        'firstName': firstNameControl.text,
        "contactNo": User.userMobile,
        'user_id': User.userId,
      };
      final response = await http.post(
        Uri.parse(
            "https://prezenty.in/prezentycards-live/public/api/prepaid/cards/generate/otp"),
        headers: {
          "Authorization": "Bearer ${TokenPrepaidCard}",
        },
        body: data,
      );
      Get.back();
      print(response.body);
      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);

        entityId = jsonResponse['entityId'];
        print("entity->${entityId}");
        toastMessage('${jsonResponse['message']}');
      } else {
        Map errorResponse = json.decode(response.body);
        if (errorResponse.containsKey('message') &&
            errorResponse['message'] is Map<String, dynamic>) {
          Map<String, dynamic> errorMessageMap = errorResponse['message'];

          if (errorMessageMap.containsKey('firstName') &&
              errorMessageMap['firstName'] is List<dynamic> &&
              errorMessageMap['firstName'].isNotEmpty) {


          } else if (errorMessageMap.containsKey('contactNo') &&
              errorMessageMap['contactNo'] is List<dynamic> &&
              errorMessageMap['contactNo'].isNotEmpty) {
            toastMessage(errorMessageMap['contactNo'][0]);
          }
          else{
            toastMessage('Unknown error occurred');
          }
        } else {

          toastMessage('Unknown error occurred');
        }
      }
    }  catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

  Future _sendOtp(
      {String? fName,
      String? lName,
      String? mName,
      String? otp,
      //String? email,
      String? pan,
      String? dob,
      String? gender,
      String? address,
      String? pinCode,
      String? city,
      String? state,
      String? aadhaarNumber}) async {
    List<Map<String, dynamic>> addressInfo = [
      {
        "addressCategory": "PERMANENT",
        "address1": permanentAddress1Control.text,
        "address2": permanentAddress2Control.text,
        "address3": permanentAddress3Control.text,
        "city": permanentcityControl.text,
        "state_code": state,
        "country": "INDIA",
        "pinCode": permanentpinNumberControl.text
      },
      if(categories == "HOME") {
        "addressCategory":categories ,
         "address1": homeAddress1Control.text,
         "address2": homeAddress2Control.text,
         "address3": homeAddress3Control.text,
         "city": homecityControl.text,
         "state_code": state,
         "country": "INDIA",
         "pinCode": homepinNumberControl.text.toString()
       }else if(categories == "OFFICE"){
        "addressCategory":categories ,
        "address1": officeAddress1Control.text,
        "address2": officeAddress2Control.text,
        "address3": officeAddress3Control.text,
        "city": officecityControl.text,
        "state_code": state,
        "country": "INDIA",
        "pinCode": officepinNumberControl.text.toString()
      }
      else if(categories=="DELIVERY"){
          "addressCategory":categories ,
          "address1": deliveryAddress1Control.text,
          "address2": deliveryAddress2Control.text,
          "address3": deliveryAddress3Control.text,
          "city": deliverycityControl.text,
          "state_code": state,
          "country": "INDIA",
          "pinCode": deliverypinNumberControl.text.toString()

      }
      else{
            "addressCategory":categories ,
            "address1": communicationAddress1Control.text,
            "address2": communicationAddress2Control.text,
            "address3": communicationAddress3Control.text,
            "city": communicationcityControl.text,
            "state_code": state,
            "country": "INDIA",
            "pinCode": communicationpinNumberControl.text.toString()
          }
    ];

// communicationInfo array
    List<Map<String, dynamic>> communicationInfo = [
      {
        "contactNo": "+91${User.userMobile}",
        "notification": true,
        "emailId": emailIdControl.text
      }
    ];

    // kycInfo array
    List<Map<String, dynamic>> kycInfo = [
      {
        "documentType": "PAN",
        "documentNo": panNumberControl.text,
        "documentExpiry": ""
      }
    ];
    List<Map<String, dynamic>> dateInfo = [
      {
        "dateType": "DOB",
        "date": dob,
      }
    ];

    Map<String, dynamic> body = {};
    body["user_id"] = User.userId;
    body["firstName"] = fName;
    body["middleName"] = mName;
    body["entityId"] = entityId;
    body["title"] = title;
    body["lastName"] = lName;
    body["email"] = User.userEmail;
    body["otp"] = OtpNumberControl.text.toString();
    body["isNRICustomer"] = isNricustomer;
    body["isMinor"] = isMinor;
    body["isDependant"] = isDependant;
    body["maritalStatus"] = marital_status;
    body["countryCode"] = "91";
    body["employmentIndustry"] = _employmentIndustryValue;
    body["employmentType"] = _employmentTypeValue;
    // body["aadhaar_number"] = aadhaarNumber;
    // body["rzr_pay_id"] = widget.razorPayId!;
    body["referred_by"] = User.userId;
    body["prepaid_card_id"] = 5;
    body["gender"] = gender!.toUpperCase();
    body["addressInfo"] = addressInfo;
    body["communicationInfo"] = communicationInfo;
    body["aliasName"] = fName;
    body["kycInfo"] = kycInfo;
    body["dateInfo"] = dateInfo;
    print("body->${body}");
    print("body->${otp}");
    try {
      AppDialogs.loading();
      RegisterWalletResponse response = await _walletBloc.registerWallet(body);
      Get.back();
      print("Response${response.data}");
      if (response.statusCode == 200) {
        toastMessage(response.message);
        print(response.data);
        Get.offAll(() => WalletHomeScreen(
              isToLoadMoney: false,
            ));
      } else {
        if (response.statusCode == 400 && response.success == false) {
          // Here, response.message will contain the error message
          toastMessage(response.message);
        } else {
          // Handle other error scenarios
          toastMessage('Error: ${response.message}');
        }
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      String errorMessage = e.toString();
      toastMessage(errorMessage);
    }
  }
}

class FormatAndValidate {
  static final RegExp alphaRegExp = RegExp('[a-zA-Z]');
  static final RegExp _numericRegExp = RegExp('[0-9]');
  static final RegExp _alphanumericRegExp = new RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp _drivingLicenceRegExp = RegExp(
      '^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}');
  static final RegExp emailRegExp = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  static final RegExp _addressRegExp = RegExp(r'^[a-zA-Z0-9\.\-\s\,\/]+$');
  static final RegExp _dobRegExp =
      RegExp('^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])');

  formatName() {
    return [FilteringTextInputFormatter.allow(alphaRegExp)];
  }

  formatPhone() {
    return [
      LengthLimitingTextInputFormatter(10),
      FilteringTextInputFormatter.digitsOnly
    ];
  }

  formatEmail() {
    return [FilteringTextInputFormatter.allow(emailRegExp)];
  }

  formatDateOfBirth() {
    return [LengthLimitingTextInputFormatter(10)];
  }

  formatAadhaar() {
    return [
      LengthLimitingTextInputFormatter(12),
      FilteringTextInputFormatter.digitsOnly
    ];
  }

  formatPANCard() {
    return [
      LengthLimitingTextInputFormatter(10),
      FilteringTextInputFormatter.allow(_alphanumericRegExp)
    ];
  }

  formatPassport() {
    return [
      LengthLimitingTextInputFormatter(8),
      FilteringTextInputFormatter.allow(_alphanumericRegExp)
    ];
  }

  formatDrivingLicence() {
    return [
      LengthLimitingTextInputFormatter(16),
      // FilteringTextInputFormatter.allow(_drivingLicenceRegExp)
    ];
  }

  formatAddress() {
    FilteringTextInputFormatter.allow(_addressRegExp);
  }

  formatPinCode() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(6)
    ];
  }

  validatePinCode(value) {
    String? x =
        value!.isEmpty || value.length != 6 ? "Enter 6 digit pin code" : null;
    print("xxxx");
    print(x.toString());
    return x;
  }

  validateOtp(value) {
    String? x =
        value!.isEmpty || value.length != 6 ? "Enter 6 digit OTP" : null;
    print("xxxx");
    print("x==${x.toString()}");
    return x;
  }

  validateAddress(value) {
    String? abc = value!.isEmpty || !_addressRegExp.hasMatch(value)
        ? "Enter valid Address"
        : null;
    print("aaa");
    print(abc.toString());
    return abc;
  }

  validateName(value) {
    String? bbb = value!.isEmpty || !alphaRegExp.hasMatch(value)
        ? "Enter valid name, space not allowed"
        : null;
    print("bbb");
    print(bbb.toString());
    return bbb;
  }

  validateDob(value) {
    String? dob = value!.isEmpty ||
            value.length > 10 ||
            value.length < 8 ||
            _dobRegExp.hasMatch(value)
        ? "Enter Date in format YYYY-MM-DD"
        : null;
    print("1321");
    print(dob.toString());
    return dob;
  }

  validateAadhaar(value) {
    return value!.isEmpty ||
            value.length != 12 ||
            !_numericRegExp.hasMatch(value) ||
            alphaRegExp.hasMatch(value)
        ? "Enter valid 12 digit Adhaar number"
        : null;
  }

  validatePANCard(value) {
    String? pan = value!.isEmpty ||
            value.length != 10 ||
            !alphaRegExp.hasMatch(value.substring(0,
                2)) //First three characters i.e. "XYZ" in the above PAN are alphabetic series running from AAA to ZZZ
            ||
            !alphaRegExp.hasMatch(value.substring(
                3)) //Fourth character i.e. "P" stands for Individual status of applicant.
            ||
            !alphaRegExp.hasMatch(value.substring(
                4)) //Fifth character i.e. "K" in the above PAN represents first character of the PAN holder's last name/surname.
            ||
            !_numericRegExp.hasMatch(value.substring(5,
                8)) //Next four characters i.e. "8200" in the above PAN are sequential number running from 0001 to 9999.
            ||
            !alphaRegExp.hasMatch(value.substring(
                9)) //Last character i.e. "S" in the above PAN is an alphabetic check digit.
        ? "Enter 10 digit valid PAN Card number"
        : null;
    print("abdddd123");
    print(pan.toString());
    return pan;
  }

  validatePassport(value) {
    return value!.isEmpty ||
            value.length != 8 ||
            !(alphaRegExp.hasMatch(value[0])) ||
            !(_numericRegExp.hasMatch(value.substring(1, 8)))
        ? "Enter 8 digit valid Passport ID"
        : null;
  }

  validateDrivingLicence(value) {
    return value.isEmpty ||
            value.length != 16 ||
            !(_drivingLicenceRegExp.hasMatch(value))
        ? "Enter 16 digit valid Driving licence number"
        : null;
  }

  validateVotersID(value) {
    return value.isEmpty ? "Enter valid voter's ID" : null;
  }

  validateEmailID(String? value) {
    bool? email;
    if (value!.trim().isEmail == true) {
      return null;
    } else {
      return "Enter valid email address";
    }
    // : "Enter valid email address";
    // print("adadhja@nsadnsa");
    // print(email);
    // return email;
  }

  validatePhoneNo(value) {
    String? phno = value.isEmpty ? "Enter phone number" : null;
    print("9685852556");
    print(phno);
    return phno;
  }
}
