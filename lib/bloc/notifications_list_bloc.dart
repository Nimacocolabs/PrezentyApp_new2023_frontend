import 'dart:async';
import 'package:event_app/interface/load_more_listener.dart';
import 'package:event_app/models/notifications_list_response.dart';
import 'package:event_app/network/api_response.dart';
import 'package:event_app/network/api_error_message.dart';
import 'package:event_app/repositories/notifications_list_repository.dart';

class NotificationListBloc {
  bool isLoading = false;
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  LoadMoreListener _listener;
  late NotificationListRepository _notificationsListRepository;
  late StreamController<ApiResponse<NotificationResponse>> _itemsController;

  StreamSink<ApiResponse<NotificationResponse>>? get itemsSink =>
      _itemsController.sink;
  Stream<ApiResponse<NotificationResponse>> get itemsStream =>
      _itemsController.stream;

  List<ListItem> itemsList = [];

  NotificationListBloc(this._listener) {
    _notificationsListRepository = NotificationListRepository();
    _itemsController =
        StreamController<ApiResponse<NotificationResponse>>.broadcast();
  }

  getList(bool isPagination) async {
    if (isLoading) return;

    isLoading = true;
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      itemsSink!.add(ApiResponse.loading('Fetching items'));
    }
    try {
      NotificationResponse response =
          await _notificationsListRepository.getList(pageNumber, perPage);

      hasNextPage = response.hasNextPage!;
      pageNumber = response.page!;
      if (isPagination) {
        if (itemsList.length == 0) {
          itemsList = response.list!;
        } else {
          itemsList.addAll(response.list!);
        }
      } else {
        itemsList = response.list!;
      }
      itemsSink!.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        itemsSink!
            .add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    } finally {
      isLoading = false;
    }
  }

  dispose() {
    itemsSink?.close();
    _itemsController.close();
  }
}
