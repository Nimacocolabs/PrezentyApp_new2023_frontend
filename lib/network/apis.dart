class Apis {
  static String registerUser = 'user/sign-up';
  static String login = 'user/login';
  static String socialLogin = 'user/social';
  static String resetPasswordSendOtp = 'user/forgot-password';
  static String resetPasswordVerifyOtp = 'user/verify-otp';
  static String resetPasswordUpdatePassword = 'user/reset-password';

  // static String createEvent = 'event/create';
  static String createEvent = 'event/create-event';
  static String updateEvent = 'event/update-event';
  static String deleteEvent = 'event/delete-event';
  static String getEventDetails = 'event/event-detail';
  static String getParticipants = 'event-participant/participants';
  static String sendGoLiveNotification = 'go-live/start';
  static String getBlockedUserList = 'blocked-users';

  static String getMusicList = 'music-files/list';
  static String geHomeEventList = 'event/home';
  static String getMyWishesList = 'event-participant/video-wishes';
  static String getMyEventsList = 'event/my-events';

  static String getProfileInfo = 'user/profile';
  static String changePassword = 'user/update-password';
  static String updateProfileInfo = 'user/update-profile';
  static String getVirtualBalance = 'event-participant/account-det-coin';
  static String coinStatementTable = "event/coin-statement";
  static String redeemStatementTable = "event/event-gift-redeem-statement";
  static String receiveStatementTable = "event/event-gift-statement";

  static String postJointEvent = 'event-participant/create';
  static String sendVideoWish = 'event-participant/send-video-wishes';

  static String getNotificationList = 'notification/list';
  static String getFavouriteList = 'favourite/list';
  static String addFavourite = 'favourite/add';

  static String getEventVouchersList = 'event-participant/gift-list';
  static String getEventParticipantsList = 'participants';
  static String createSendFoodOrder = 'orders/create';
  static String getRedeemedVoucherList = 'event-participant/get-redeem-voucher-list';

  static String getPaymentGatewayKey = 'razorpay/get-api-key';
  static String getPaymentGatewayOrderId = 'razorpay/get-payment-order-id';
  static String getPaymentGatewayConfirmVoucherAmountOrderId =
      'razorpay/confirm-voucher-amount';
  static String getPaymentOrder = 'razorpay/get-order-id';
  static String getPaymentOrderWoohoo = 'product/create-order';

  static String getAllReceivedEventVouchersList =
      'summary/gift-vouchers-received';
  static String getVoucherDetail = 'summary/gift-voucher-detail';
  static String getVoucherUsersList = 'summary/gift-voucher-users-list';

  static String getOrderRelatedUsers = 'summary/order-detail-users';

  static String getPersonalChatMessages = 'chat/message';
  static String getGroupChatMessages = 'chat/group-message';
  static String sendChatMessages = 'chat/send-message';
  static String blockUser = 'chat/block-user';
  static String unBlockUser = 'chat/un-block-user';

  static String getEventOrders = 'orders';
  static String getEventOrderDetail = 'orders/view';

  static String getProductCategories = 'woohoo-catelog/get-catlog';
  static String ProductList = 'woohoo-products/get-products';
  static String ProductDetails = 'woohoo-products/product-detail';
  static String orderCreation = 'order-create/create';

  static String getOrderStatus = 'woohoo-order/order-status';
  static String getActiveCards = 'activated-cards';

  static String cardBalance = 'order-create/balance';
  static String getTransactions = 'woohoo-order/transaction-history';
  static String getReceivedPayments = 'event-participant/account-det';

  static String getPaymentUpiLink = 'decentro-api/create-upi';
  static String getPaymentStatus = 'decentro-api/transaction-status';
  static String redeemInitTransfer = 'decentro-api/money-transfer';
  static String getTransferStatus = 'decentro-api/check-money-transfer-status';

  static String sendFeedbackMessage = 'user/contact-us';

  static String getRedeemOrders = 'event-participant/get-redeem-report';
  static String getSendFoodOrders = 'event-participant/get-send-food-report';
  static String getMyVoucherOrdersBought =
      'event-participant/get-user-bought-vouchers';
  static String getMyVoucherOrdersReceived =
      'event-participant/get-user-received-vouchers';
  static String createRedeemOrder = 'order-create/redeem';
  static String sendInvoice = 'order-create/send-invoice-by-type';
  static String getBuyTaxInfo = 'woohoo-order/get-tax-value';
  static String getRedeemTaxInfo = 'woohoo-order/get-redeem-tax-value';

  //Prepaid Cards & Wallet

  static String authWallet = "api/auth-mpin";
  static String setWalletPin = "api/set-mpin";
  static String forgetWalletPinSendOtp = "api/forget-mpin";
  static String resetWalletPin = "api/reset-mpin";
  static String getStateCode = "api/state-list";

  static String getAllAvailableCardList = "api/prepaid-card-list";
  static String getCardOffers = "api/card-offer-list";
  static String offers = "api/offers-list";
  static String blockCardNow = "api/prepaid/cards/card-status";
  static String replaceCardNow="api/prepaid/cards/replace-card";

  static String walletCreationAndPaymentStatus = "api/check-paid-wallet-status";
  static String registerWallet = "api/prepaid/cards/wallet-registration";
  static String verifyWalletRegistrationOtp = "api/verify-registration";
     static String walletRegistrationResendOtp = "api/resend-otp";
  static String getWalletDetails = "api/prepaid/cards/wallet-details";
  static String getCVV = "api/fetch-cvv";
  static String checkPhysicalCardExists = "api/check-enable-cardsetpin-button";
  static String checkEnableRequestPhysicalCard =
      "api/prepaid/cards/check-physical-card-request";
  static String setCardPin = 'api/prepaid/cards/set-pin';
  static String loadMoney = "";
  static String getWalletStatementList = "api/prepaid/cards/transactions";
  static String requestPhysicalCard = "api/physicalcard-request";

  static String getOffers = "api/offers-list";

  static String getWalletPaymentOrderDetails = "api/get-order-id";
  static String getRazorpayGateWayKey = "api/get-api-key";
  static String getCardUpgradePlans = "api/listUpgradeplans";
  static String getEnableUpgradeButton = "api/enable-upgrade-button";
  static String qrcodeWalletPay = "api/qrdoce-wallet-pay";
  static String paymentStatus = "api/wallet-load-transaction-status";

  static String getApplyCardTaxInfo = 'api/basic-registration-prepaid-card';
  static String getMPinStatus = 'api/check-mpin-set-or-not';

  static String couponListing = "api/coupon-listing";
  static String couponValidate = "api/check-coupon-valid";
  static String upgradeCouponTaxInfo = "api/upgrade-value-details-new";
  // static String upgradeCouponTaxInfo = "api/upgrade-value-screen";
  static String checkTransactionStatusApplyCard =
      "api/check-transaction-success-or-not";
  static String checkTransactionStatusUpgradeCard =
      "api/check-transaction-upgrade-success-or-not";
  static String navigateToWallet = "api/wallate-navigation-api";
  static String touchPoints = "api/get-touch-points";
  static String userDetailsFetch = "api/fetch-userdetails";
  static String tpEarningHistory = "api/earning-history";
  static String tpRedemptionHistory = "api/redumption-history";
  static String getTouchPointWalletBalance = "api/get-touch-wallet-balance";
  static String checkAppVersion = "api/get-app-version";
  static String checkEventVaCreated = "event/create-virtual-account-check";

  static String sendMobileEmailOtp = "api/send-sms-email-account-verification";
  // static String checkIsMobileEmailVerified =
  //     "api/check-account-verified-emai-id-phone";
  static String checkIsMobileEmailVerified = "api/check-verify-emai-id-phone";
  static String updateMobileEmailVerifyComplete =
      "api/update-mobile-email-verify";
  static String accountDeleteEmailOtp = "api/account-delele-email-confirm";
  static String accountDeleteConfirm = "api/confirm-account-delele-request";
  static String transferCoinHistory = "api/coin-transfer-history";
  static String checkPrepaidUserOrNot = "api/prepaid/cards/check-customer/";
  static String checkPrepaidUserOrNotToken = "api/prepaid/cards/get-token/";
  static String transferCoinToPrepaidCard = "api/transfer-coin-to-prepaid-card";
  static String userPermenantAddress = "api/get-user-permenant-address";
  static String getPhysicalOrderId = "api/prepaid/cards/get-physical-order-id-amount";
  static String getTermsAndConditions = "api/get-terms-condition";

  static String updatePanNumber = "api/update-pan-number";
  static String updateAadharNumber = "api/update-aadar-number";
  static String verifyPanAadhar = 'api/verify-pan-aadar';
  static String fetchPhysicalCardDetails = 'api/fetch-card-details-physic';
  static String getPhysicalCardRequestAmount =
      'api/prepaid/cards/get-physical-card-request-amount';
  static String validatePrepaidCardNumber = "api/validate-prepaid-card-number";
  static String updateReferalCode = "api/update-referal-code";
  static String offerProductList = "api/get-offer-product-list";
  static String insertSpinUserAttempt = "api/insert-spin-user-attmpt";
  static String insertSpinItem = "api/insert-spin-item";
  static String getUserSpinItem = "api/get-user-spin-item";
  static String getSpinWheelProductList = "api/get-spinwheel-product-list";
  static String getSpinVoucherList = "api/get-user-spin-voucher-list";
  static String getCurrentDateAndTime = "api/get-current-date-time";
  static String getAppVersionFrom = "api/get-app-version-from";
  static String getPopupImage = "api/get-popup-image";
  static String getScratchCardValidOrNot = "api/check-scrach-coupon-code-valid";
  static String getHowItWorks = "api/get-how_it_works";
  static String spinWheelTermsAndConditions = "api/get-spin-terms-conditions";
  static String getDealsForYouProducts = "api/get-deals-products";
  static String checkLoginMPINSetOrNot = "api/check-login-mpin-set-or-not";
  static String authenticationLoginMPIN = "api/auth-login-mpin";
  static String setLoginMPIN = "api/set-login-mpin";
  static String forgotLoginMPIN = "api/forget-login-mpin";
  static String resetLoginMPIN = "api/reset-login-mpin";
  static String checkVoucherCodeValidOrNOt = "api/check-voucher-code-valid";
  static String getFoodAndMovieProducts = "api/get-food-movie-products";
  static String checkCustomerCardType = "api/check-customer-card-type";
  static String getMerchantsList = "api/get-marchants-list";
  static String getProductCategoryList = "api/get-product-category-list";
  static String getDetailedProductCategoryList = "api/product-category-list";
  static String getBackToCampusProductsList = "api/get-campus-products";
  static String getHICardBalance = "api/get-hi-card-balance";
  static String checkHiCardBalance = "api/check-hi-card-balance";
  static String getHICardRedemptionHistory = "api/get-hi-card-redemptionhistory";
  static String giftHICard = "api/gift-hi-card";
  static String getOrderIdTouchPoint = "api/get-order-id-touchpoint";
  // static String getGiftOrder = "api/get-gift-order";
  static String getHICardEarningHistory = "api/get-hi-card-earninghistory";
  static String hiCardLoadMoney = "api/hi-card-load-money";
  static String transferTouchpointsToHicard = "api/transfer-touchpoint-hi-card";
  static String sendGiftToUser = "api/send-gift-particepents-to-user";
  static String checkHiCardValidity = "api/check-hi-card-validity";
  static String getUserEventSummary = "api/user-event-summery";
  static String eventBasedGift = "api/get-event-based-gift";
  static String eventGiftReceived = "api/recieved-event-gift";
  static String validateWalletNumber = "api/validate-wallet-number-common";
  static String walletUPIPayment = "api/wallet-upi-payment";
  static String checkWalletPayeeExistOrNot = "api/check-wallet-payee-exist";
  static String addWalletBeneficiary = "api/add-wallet-beneficiary";
  static String getExistingPayee = "api/get-existing-payee";
  static String addBeneficiaryToFavourite = "api/add-beneficiary-favorite";
  static String removeBeneficiaryToFavourite =
      "api/remove-beneficiary-favorite";
  static String deleteBeneficiary = "api/delete-beneficiary";
  static String favouritePayeesList = "api/get-favourite-payee-list";
  // static String walletLoadTransactionStatusCheck =
  //     "api/wallet-load-transaction-status-check";
  static String homeSliderImages = "api/get-home-slider-images";
  static String loadMoneyTransactionHistory =
      "api/event-money-transaction-history";
  static String loadMoneyContent = "api/get-load-money-content";
  static String checkVAStatementStatus =
      "api/check-va-statement-status-success";
  static String getPhysicalCardStatus = "api/get-physical-card-status";
  static String homeScreenCommonApi = "api/home-screen-common-api";
  static String getVATransactionSuccessOrNot =
      "api/get-va-transaction-success-or-not";
  static String sendSmsEmailAccountVerificationSignup =
      "api/send-sms-email-account-verification-signup";

static String upilink ="api/prepaid/cards/generate-upi-link";
  static String upistatus ="api/prepaid/cards/upi-transaction-status";
  static String upistatusucsess ="api/prepaid/cards/load-wallet";

  /////Additional api set from public live/////////
  static String notificationread = "api/notification-read";

}
