import 'package:event_app/models/blocked_users_response.dart';
import 'package:event_app/models/participant_response.dart';
import 'package:event_app/network/api_provider.dart';
import 'package:event_app/network/apis.dart';

class ParticipantRepository {
  late ApiProvider apiProvider;

  ParticipantRepository() {
    apiProvider = ApiProvider();
  }

  Future<ParticipantResponse> getParticipantList(
      int id, int pageNumber, int perPage,String email) async {
    final response = await apiProvider.getJsonInstance().get(
        '${Apis.getParticipants}?id=$id&page=${pageNumber + 1}&per_page=$perPage&email=$email');
    return ParticipantResponse.fromJson(response.data);
  }

  Future<BlockedUsersResponse> getBlockedUsersList(int id,String email) async {
    final response = await apiProvider
        .getJsonInstance()
        .get('${Apis.getBlockedUserList}?event_id=$id&blocked_by_user_email=$email');
    return BlockedUsersResponse.fromJson(response.data);
  }
}
