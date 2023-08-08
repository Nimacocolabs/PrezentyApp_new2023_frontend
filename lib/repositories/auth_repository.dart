import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/models/authenticate_login_mpin_model.dart';
import 'package:event_app/models/check_is_mobile_and_email_verified_response.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/forgot_login_mpin_model.dart';
import 'package:event_app/models/forgot_pass_update_pass_response.dart';
import 'package:event_app/models/forgot_pass_verify_otp_response.dart';
import 'package:event_app/models/get_product_category_list_model.dart';
import 'package:event_app/models/popup_image_model.dart';
import 'package:event_app/models/set_login_mpin_model.dart';
import 'package:event_app/models/spin_wheel_rules_model.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/api_provider_prepaid_cards.dart';
import 'package:event_app/network/apis.dart';
import 'package:event_app/models/forgot_pass_send_otp_response.dart';
import 'package:event_app/util/app_helper.dart';

import '../models/app_version_check_response.dart';
import '../models/check_loginmpin_set_or_not_model.dart';
import '../models/send_mobile_email_otp_response.dart';
import '../models/send_sms_email_account_verification_signup_model.dart';

class AuthRepository {
  late ApiProvider apiClient;
  late ApiProviderPrepaidCards apiClientPrepaidCards;

  AuthRepository() {
    apiClient = ApiProvider();
    apiClientPrepaidCards = ApiProviderPrepaidCards();
  }
  Future<UserSignUpResponse> registerUser(String body) async {
    Response response =
        await apiClient.getJsonInstance().post(Apis.registerUser, data: body);
    return UserSignUpResponse.fromJson(response.data);
  }

  Future<UserSignUpResponse> login(String body) async {
    Response response =
        await apiClient.getJsonInstance().post(Apis.login, data: body);
    return UserSignUpResponse.fromJson(response.data);
  }

  Future<UserSignUpResponse> socialLogin(String email, String name) async {
    Response response = await apiClient.getMultipartInstance().post(
        Apis.socialLogin,
        data: FormData.fromMap({'email': email, 'name': name}));
    return UserSignUpResponse.fromJson(response.data);
  }

  Future<ForgotPassSendOtpResponse> resetPasswordSendOtp(String email) async {
    Response response = await apiClient.getMultipartInstance().post(
        Apis.resetPasswordSendOtp,
        data: FormData.fromMap({'email': email}));
    return ForgotPassSendOtpResponse.fromJson(response.data);
  }

  Future<ForgotPassVerifyOtpResponse> resetPasswordVerifyOtp(String otp) async {
    Response response = await apiClient.getMultipartInstance().post(
        Apis.resetPasswordVerifyOtp,
        data: FormData.fromMap({'otp': otp}));
    return ForgotPassVerifyOtpResponse.fromJson(response.data);
  }

  Future<ForgotPassUpdatePassResponse> resetPasswordUpdatePassword(
      int accountId, String passwordResetToken, String password) async {
    Response response = await apiClient
        .getMultipartInstance()
        .post(Apis.resetPasswordUpdatePassword,
            data: FormData.fromMap({
              'account_id': accountId,
              'password_reset_token': passwordResetToken,
              'confirm_password': password,
              'new_password': password,
            }));
    return ForgotPassUpdatePassResponse.fromJson(response.data);
  }

  Future<AppVersionCheckResponse> checkAppVersion(String device) async {
    Response response = await ApiProviderPrepaidCards()
        .getMultipartInstance()
        .post(Apis.getAppVersionFrom,
            data: FormData.fromMap({'device': device}));
    return AppVersionCheckResponse.fromJson(json.decode(response.data));
  }

  Future<SendMobileEmailOtpData?> sendMobileEmailOtp(
      String email, String phone, bool isSignUp) async {
    Response response = await apiClientPrepaidCards.getMultipartInstance().post(
        Apis.sendMobileEmailOtp,
        data: FormData.fromMap({
          'email': email,
          'phone_number': phone,
          'is_sign_up': isSignUp ? 'yes' : 'no'
        }));

    SendMobileEmailOtpResponse _res =
        SendMobileEmailOtpResponse.fromJson(response.data);
    if (_res.statusCode == 500) {
      toastMessage(
          "Phone number or Email already taken.Please try with another mobile number or Email");
      return null;
    }
    return _res.data;
  }

  Future<CheckIsMobileEmailVerifiedResponse> checkIsMobileEmailVerified(
      String userId) async {
    Response response = await apiClientPrepaidCards.getMultipartInstance().post(
        Apis.checkIsMobileEmailVerified,
        data: FormData.fromMap({'account_id': userId}));
    return CheckIsMobileEmailVerifiedResponse.fromJson(response.data);
  }

  Future<CommonResponse> updateMobileEmailVerifyComplete(String userId) async {
    Response response = await apiClientPrepaidCards.getMultipartInstance().post(
        Apis.updateMobileEmailVerifyComplete,
        data: FormData.fromMap({'account_id': userId}));
    return CommonResponse.fromJson(json.decode(response.data));
  }

  Future<PopupImageModel> getPopupImage() async {
    Response response = await apiClientPrepaidCards
        .getMultipartInstance()
        .get(Apis.getPopupImage);
  
    return PopupImageModel.fromJson(json.decode(response.data));
  }

  Future<SpinWheelRulesData?> spinWheelRules() async {
    final response = await apiClientPrepaidCards
        .getJsonInstance()
        .get('${Apis.spinWheelTermsAndConditions}');
    return SpinWheelRulesModel.fromJson(json.decode(response.data)).data;
  }

  Future<CheckLoginmpinSetOrNotModel> checkLoginMPINSetOrNot(
      String accountId) async {
    Response response = await apiClientPrepaidCards.getMultipartInstance().post(
        Apis.checkLoginMPINSetOrNot,
        data: FormData.fromMap({'account_id': accountId}));

    return CheckLoginmpinSetOrNotModel.fromJson(json.decode(response.data));
  }

  Future<AuthenticateLoginMpinModel> authLoginMPIN(
      String accountId, String loginMPIN) async {
    Response response = await apiClientPrepaidCards
        .getJsonInstance()
        .post(Apis.authenticationLoginMPIN,
            data: FormData.fromMap({
              'account_id': accountId,
              'login_mpin': loginMPIN,
            }));
    print(response.data);
    return AuthenticateLoginMpinModel.fromJson(jsonDecode(response.data));
  }

  Future<SetLoginMpinModel> setLoginMPIN(
      String accountId, String newLoginMPIN) async {
    Response response =
        await apiClientPrepaidCards.getJsonInstance().post(Apis.setLoginMPIN,
            data: FormData.fromMap({
              'account_id': accountId,
              'new_mpin': newLoginMPIN,
            }));

    return SetLoginMpinModel.fromJson(jsonDecode(response.data));
  }

  Future<ForgotLoginMpinModel> forgotLoginMPIN(String accountId) async {
    Response response = await apiClientPrepaidCards.getJsonInstance().post(
        Apis.forgotLoginMPIN,
        data: FormData.fromMap({'account_id': accountId}));
    return ForgotLoginMpinModel.fromJson(response.data);
  }

  Future<CommonResponse> resetLoginMPIN(
    String accountId,
     String loginMPIN,
      {int? otpReferenceId = null, String? otp = null}) async {
    Response response = await apiClientPrepaidCards
        .getMultipartInstance()
        .post(Apis.resetLoginMPIN,
            data: FormData.fromMap({
              'account_id': accountId,
              'reference_id': otpReferenceId,
              'new_mpin': loginMPIN,
              'otp': otp,
            }));

    return CommonResponse.fromJson(response.data);
  }




 Future<SendSmsEmailAccountVerificationSignupModel> sendSmsEmailAccountVerificationSignup(
      String accountId) async {
    Response response = await apiClientPrepaidCards
        .getMultipartInstance()
        .post(Apis.sendSmsEmailAccountVerificationSignup,
            data: FormData.fromMap({
              'account_id': accountId,
              
            }));

    return SendSmsEmailAccountVerificationSignupModel.fromJson(response.data);
  }






}
