import 'package:eventplex_frontend/Model/Club.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'ClubDetailsState.dart';

class ClubDetailsCubit extends Cubit<ClubDetailsState> {
  GraphQLService gqs = GraphQLService();
  ClubDetailsCubit() : super(ClubDetailsState()) {}
  void loadClubDetails(id) async {
    String query = '''query getClubInfo(\$id: String){
      clubInfo(id: \$id){
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
    for (var e in c.followers) {
      // print(e.id);
      if (e.id == "665a2845e75985c1d041aae6") {
        b = true;
        break;
      }
    }
    if (b) {
      emit(ClubDetailsStateLoaded(c, true));
    } else {
      emit(ClubDetailsStateLoaded(c, false));
    }
  }

  void changeFollowing(Club c, bool p) {
    if (p == true) {
      String query = '''mutation(\$data: followInput){
    unFollowClub(data: \$data){
    name
    }
    }
''';
      gqs.performMutation(query, {
        "data": {"uid": "665a2845e75985c1d041aae6", "cid": c.id}
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
        "data": {"uid": "665a2845e75985c1d041aae6", "cid": c.id}
      });

      emit(ClubDetailsStateLoaded(c, true));
    }
  }
}
