import 'package:eventplex_frontend/Model/Club.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ClubDetailsState.dart';

class ClubDetailsCubit extends Cubit<ClubDetailsState> {
  GraphQLService gqs = GraphQLService();
  ClubDetailsCubit() : super(ClubDetailsState()) {}
  Future<String> loadClubDetails(id) async {
    String query = '''query getClubInfo(\$id: String){
      clubInfo(id: \$id){
      dp
        _id
        name
        pastEvents{
            name
            category
            rating
            _id
            images
        }
        currentEvents{
            name
            category
            rating
            _id
            images
        }
        followers{
            name
            _id
        }
      }
    }''';

    QueryResult result = await gqs.performQuery(query, {"id": id});
    Club c = Club.fromJson(result.data!['clubInfo']);
    bool b = false;
    String currentEmail =
        (await SharedPreferences.getInstance()).getString("email")!;

    for (var u in c.followers) {
      // print(e.id);
      if (u.id == await getCurrentUserId(currentEmail)) {
        b = true;
        break;
      }
    }
    if (b) {
      emit(ClubDetailsStateLoaded(c, true));
    } else {
      emit(ClubDetailsStateLoaded(c, false));
    }
    String role = (await SharedPreferences.getInstance()).getString("role")!;
    return role;
  }

  void changeFollowing(Club c, bool p) async {
    String currentEmail =
        (await SharedPreferences.getInstance()).getString("email")!;
    String id = await getCurrentUserId(currentEmail);
    if (p == true) {
      String query = '''mutation(\$data: followInput){
    unFollowClub(data: \$data){
    name
    }
    }
''';
      gqs.performMutation(query, {
        "data": {"uid": id, "cid": c.id}
      });
      emit(ClubDetailsStateLoaded(c, false));
    } else {
      String query = '''mutation(\$data: followInput){
    followClub(data: \$data){
    name
    }
    }
''';
      gqs.performMutation(query, {
        "data": {"uid": id, "cid": c.id}
      });

      emit(ClubDetailsStateLoaded(c, true));
    }
  }

  Future<String> getCurrentUserId(String email) async {
    String query = '''query(\$email: String){
    userInfo(email: \$email){
    _id
    }
    }
''';
    var result = await gqs.performQuery(query, {"email": email});
    print(result.data);
    return (result.data!['userInfo'] == null)
        ? ""
        : result.data!['userInfo']['_id'];
  }
}
