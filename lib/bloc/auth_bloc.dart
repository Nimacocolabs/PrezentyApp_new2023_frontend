import 'dart:async';
import 'dart:io';

import 'package:event_app/models/authenticate_login_mpin_model.dart';
import 'package:event_app/models/check_is_mobile_and_email_verified_response.dart';
import 'package:event_app/models/check_loginmpin_set_or_not_model.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/models/forgot_login_mpin_model.dart';
import 'package:event_app/models/forgot_pass_update_pass_response.dart';
import 'package:event_app/models/forgot_pass_verify_otp_response.dart';
import 'package:event_app/models/popup_image_model.dart';
import 'package:event_app/models/set_login_mpin_model.dart';
import 'package:event_app/models/user_sign_up_response.dart';
import 'package:event_app/repositories/auth_repository.dart';
import 'package:event_app/models/forgot_pass_send_otp_response.dart';
import 'package:event_app/screens/login/sign_up_screen.dart';
import 'package:event_app/screens/login/upgrade_to_latest_version_screen.dart';
import 'package:event_app/screens/main_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/app_dialogs.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/app_version_check_response.dart';
import '../models/send_mobile_email_otp_response.dart';
import '../models/send_sms_email_account_verification_signup_model.dart';
import '../models/spin_wheel_rules_model.dart';
import '../network/api_error_message.dart';
import '../services/dynamic_link_service.dart';

class AuthBloc {
  late AuthRepository _repository;

  AuthBloc() {
    _repository = AuthRepository();
  }

  Future<UserSignUpResponse> userRegistration(String body) async {
    try {
      UserSignUpResponse response = await _repository.registerUser(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<UserSignUpResponse> login(String body) async {
    try {
      return await _repository.login(body);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<UserSignUpResponse> socialLogin(String email, String name) async {
    try {
      return await _repository.socialLogin(email, name);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<ForgotPassSendOtpResponse> resetPasswordSendOtp(String email) async {
    try {
      return await _repository.resetPasswordSendOtp(email);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<ForgotPassVerifyOtpResponse> resetPasswordVerifyOtp(String otp) async {
    try {
      AppDialogs.loading();
      ForgotPassVerifyOtpResponse response =
          await _repository.resetPasswordVerifyOtp(otp);
      Get.back();
      return response;
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<ForgotPassUpdatePassResponse> resetPasswordUpdatePassword(
      int accountId, String passwordResetToken, String password) async {
    try {
      return await _repository.resetPasswordUpdatePassword(
          accountId, passwordResetToken, password);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future checkAppVersion(bool isFromLogout) async {
    try {
      AppVersionCheckResponse res = await _repository
          .checkAppVersion(Platform.isAndroid ? 'android' : 'ios');

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int buildNum = int.tryParse(packageInfo.buildNumber) ?? 0;
      print("Build No : ${buildNum}");
      print("Data build : ${res.data?.buildNumber}");

      if ((res.data?.buildNumber ?? 0) > buildNum &&
          ((Platform.isAndroid && res.data?.isLivePlayStore == 1) ||
              (Platform.isIOS && res.data?.isLiveAppStore == 1))) {
        Get.to(() => UpgradeToLatestVersionScreen());
      } else {
        // latest version installed
        if (isFromLogout) {
          // Get.offAll(()=>LoginScreen(),transition: Transition.fade);
          goToHomeScreen();
          // Get.offAll(
          //         () => WoohooVoucherListScreen(
          //       redeemData: RedeemData.buyVoucher(),
          //       showBackButton: false,
          //     ),
          //     transition: Transition.fade);
        } else {
          DynamicLinkService().initDynamicLinks();
        }
      }
    } catch (e, s) {
      toastMessage('Unable to complete version check');
      Completer().completeError(e, s);
    }
  }

  Future<SendMobileEmailOtpData?> sendMobileEmailOtp(
      String email, String phone, bool isSignUp) async {
    try {
      AppDialogs.loading();
      return await _repository.sendMobileEmailOtp(email, phone, isSignUp);
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

  Future checkIsMobileEmailVerified(String userId) async {
    try {
      // await Future.delayed(Duration(seconds: 3));
      CheckIsMobileEmailVerifiedResponse response =
          await _repository.checkIsMobileEmailVerified(userId);

      if ((response.success ?? false) &&
          (response.data?.mobileVerify == 'no')) {
        mobileOrEmailOtpNotCompleted(isMobileOtpMissing: true);
      } else if ((response.success ?? false) &&
          (response.data?.emailVerify == 'no')) {
        mobileOrEmailOtpNotCompleted(isMobileOtpMissing: false);

        //initVerifyMobileEmail(User.userEmail, User.userMobile, true);
      } else if ((response.success ?? false) &&
          (response.data?.mobileVerify == 'yes' ||
              response.data?.emailVerify == 'yes')) {
        Get.off(MainScreen());
      }
    } catch (e, s) {
      Completer().completeError(e, s);
    }
  }

  Future<String?> getPopupImage() async {
    AppDialogs.loading();
    try {
      //await Future.delayed(Duration(seconds: 2));
      PopupImageModel response = await _repository.getPopupImage();

      if (response.data!.status == 'Active') {
        return response.data?.imageUrl;
      }
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

  Future updateMobileEmailVerifyComplete(String userId) async {
    try {
      AppDialogs.loading();
      CommonResponse response =
          await _repository.updateMobileEmailVerifyComplete(userId);

      if (response.success ?? false) {
        toastMessage('Thank you for verifying your mobile and email id');
      } else {
        toastMessage('Unable to complete your verification');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage('Unable to complete your verification');
    } finally {
      AppDialogs.closeDialog();
    }
  }

  Future<SpinWheelRulesData?> spinWheelRules() async {
    try {
      AppDialogs.loading();
      SpinWheelRulesData? response = await _repository.spinWheelRules();
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    } finally {
      AppDialogs.closeDialog();
    }
    return null;
  }

  Future checkLoginMPINSetOrNot(String accountId) async {
    try {
      CheckLoginmpinSetOrNotModel response =
          await _repository.checkLoginMPINSetOrNot(accountId);

      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    }
  }

  Future<AuthenticateLoginMpinModel> authLoginMPIN(
      String accountId, String loginMPIN) async {
    try {
      AppDialogs.loading();
      return await _repository.authLoginMPIN(accountId, loginMPIN);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<SetLoginMpinModel> setLoginMPIN(
      String accountId, String newLoginMPIN) async {
    try {
      AppDialogs.loading();
      return await _repository.setLoginMPIN(accountId, newLoginMPIN);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    } finally {
      Get.back();
    }
  }

  Future<ForgotLoginMpinModel> forgotLoginMPIN(String accountId) async {
    try {
      return await _repository.forgotLoginMPIN(accountId);
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<CommonResponse> resetLoginMPIN(String accountId, String loginMPIN,
      {int? otpReferenceId = null, String? otp = null}) async {
    try {
      return await _repository.resetLoginMPIN(
        accountId,
        loginMPIN,
        otpReferenceId: otpReferenceId,
        otp: otp,
      );
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }


  Future<SendSmsEmailAccountVerificationSignupModel?>
      sendSmsEmailAccountVerificationSignup(String accountId) async {
    try {
      AppDialogs.loading();
      SendSmsEmailAccountVerificationSignupModel? response =
          await _repository.sendSmsEmailAccountVerificationSignup(accountId);
      Get.back();

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e, s) {
      Get.back();
      Completer().completeError(e, s);
      toastMessage(ApiErrorMessage.getNetworkError(e));
    }
  }

// Future<PopupImageData> getPopupImage() async {
//   try {

//     return await _repository.getPopupImage();
//   } catch (e, s) {
//     Completer().completeError(e, s);
//     throw e;
//   }
// }

}
