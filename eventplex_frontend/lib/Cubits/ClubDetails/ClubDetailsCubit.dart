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
        }
        currentEvents{
            name
        }
        followers{
            name
        }
      }
    }''';

    QueryResult result = await gqs.performQuery(query, {"id": id});
    Club c = Club.fromJson(result.data!['clubInfo']);
    emit(ClubDetailsStateLoaded(c));
  }
}
