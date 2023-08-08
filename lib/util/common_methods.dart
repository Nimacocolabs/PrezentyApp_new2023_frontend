import 'dart:io';

import 'package:event_app/interface/FavouritesUpdatedListener.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonMethods {
  static FavouritesUpdatedListener? _favouritesUpdatedListener;

  void setFavouritesUpdatedListener(FavouritesUpdatedListener listener) {
    print("initialized#####");
    _favouritesUpdatedListener = listener;
  }

  void userFavouritesUpdated() {
    print("*****refresh view all page ");
    if (_favouritesUpdatedListener != null) {
      _favouritesUpdatedListener?.refreshHome();
    }
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  String readTimestamp(String dateReceived) {
    try {
      DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
      DateTime dateTimeNow = DateTime.now();
      var diff = dateTimeNow.difference(dateTimeCreatedAt);
      var time = '';

      if (diff.inSeconds <= 0 ||
          diff.inSeconds > 0 && diff.inMinutes == 0 ||
          diff.inMinutes > 0 && diff.inHours == 0 ||
          diff.inHours > 0 && diff.inDays == 0) {
        time = DateFormat("hh:mm:ss a").format(dateTimeCreatedAt);
      } else if (diff.inDays > 0 && diff.inDays < 7) {
        if (diff.inDays == 1) {
          time = diff.inDays.toString() + ' DAY AGO';
        } else {
          time = diff.inDays.toString() + ' DAYS AGO';
        }
      } else {
        if (diff.inDays == 7) {
          time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
        } else {
          time = DateFormat("dd MMM yyyy").format(dateTimeCreatedAt);
        }
      }

      return time;
    } catch (e) {
      return dateReceived;
    }
  }

  //  getStoredEventsInfo() async {
  //   print("**getStoredEventsInfo");
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     LoginModel().eventsParticipated =
  //         prefs.getStringList("eventsParticipating") ?? [];
  //     print(LoginModel().eventsParticipated.length);
  //   } catch (e) {
  //     print("**getStoredEventsInfoError");
  //     print("error${e.toString()}");
  //   }
  // }

  void removeStoredEventsInfo() async {
    var toRemove = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> eventsParticipated =
          prefs.getStringList("eventsParticipating")!;

      // String now = DateFormat("dd MMM yyyy hh:mm a").format(DateTime.now());
      // DateTime dateTimeNow = DateTime.parse(now);

      if (eventsParticipated != null) {
        print("***2");
        if (eventsParticipated.length > 0) {
          print("***3");
          print("Length ${eventsParticipated.length}");

          eventsParticipated.forEach((dat) {
            var arr = dat.split('-');
            var dateReceived = arr[1];
            DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
            DateTime dateTimeNow = DateTime.now();
            var diff = dateTimeCreatedAt.difference(dateTimeNow);

            final differenceInDays = diff.inDays;
            // final differenceInHours = diff.inHours;

            if (differenceInDays < 0) {
              toRemove.add(dat);
            }
          });
        }

        eventsParticipated.removeWhere((e) => toRemove.contains(e));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList("eventsParticipating", eventsParticipated);
      }
    } catch (e) {
      print("error${e.toString()}");
    }
  }

// void getPaymentKeyInfo() async {
//   PaymentBloc paymentBloc = new PaymentBloc();
//   paymentBloc.getPaymentKey().then((res) {
//     GatewayKeyResponse? response = res;
//     if (response != null) {
//       if (response.statusCode == 200) {
//         LoginModel().paymentKeyResponse = response;
//       }
//     }
//   });
// }
}
