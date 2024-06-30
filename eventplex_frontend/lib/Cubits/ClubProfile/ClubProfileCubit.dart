import 'package:eventplex_frontend/Cubits/ClubProfile/ClubProfileState.dart';
import 'package:eventplex_frontend/Model/Club.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClubProfileCubit extends Cubit<ClubProfileState> {
  GraphQLService gqs = GraphQLService();
  ClubProfileCubit() : super(ClubProfileState());
  void loadClubDetails() async {
    String query = '''query(\$email: String){
    clubProfile(email: \$email){
    email
    _id
    name
    currentEvents{
      _id
      name
      category
      rating
      images
    }
    pastEvents{
      _id
      name
      category
      rating
      images
    }
    followers{
      _id
      name
      dp
      pastEvents{
      _id
      }
      currentEvents{
      _id
      }
    }
    dp
    
    }
    }''';
    SharedPreferences sf = await SharedPreferences.getInstance();
    QueryResult result =
        await gqs.performQuery(query, {"email": sf.getString("email")});
    print(result);
    Club c = Club.fromJson(result.data!['clubProfile']);
    emit(ClubProfileStateLoadedState(c));
  }

}

// add email feild in club. clicking on dashboard will search email both in user and club and will show screen acc. same sceeen for club dashboard as of club detail with one extra button for creating new event. sign in for both user and club, if the email is new create new user/club and give the screen acc for creation of the user/club
