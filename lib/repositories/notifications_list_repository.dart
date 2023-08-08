import 'package:event_app/models/notifications_list_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/apis.dart';
int notificationcount=0;
class NotificationListRepository{
  late ApiProvider apiProvider;

  NotificationListRepository(){
    apiProvider = ApiProvider();
  }

  Future<NotificationResponse> getList( int pageNumber, int perPage) async {
    final response = await apiProvider.getJsonInstance().get('${Apis.getNotificationList}?page=${pageNumber + 1}&per_page=$perPage');
    notificationcount = response.data["notification_count"];
    print("count->${notificationcount}");
    print("Url-->${apiProvider.getJsonInstance().get('${Apis.getNotificationList}?page=${pageNumber + 1}&per_page=$perPage')}");

    return NotificationResponse.fromJson(response.data);
  }
}