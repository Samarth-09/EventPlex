import 'package:eventplex_frontend/Cubits/UserProfile/UserProfileState.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  GraphQLService gqs = GraphQLService();
  UserProfileCubit() : super(UserProfileState());
  void loadUserDetails() async {
    String query = '''query user(\$email: String){
    userInfo(email: \$email){
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
    following{
      _id
      name
      dp
    }
    keywords
    dp
    
    }
    }''';
    SharedPreferences sf = await SharedPreferences.getInstance();
    QueryResult result =
        await gqs.performQuery(query, {"email": sf.getString("email")});
    // print(result.data);
    User u = await User.fromJson(result.data!['userInfo']);
    emit(UserProfileLoadedState(u));
  }
}

// add email feild in club. clicking on dashboard will search email both in user and club and will show screen acc. same sceeen for club dashboard as of club detail with one extra button for creating new event. sign in for both user and club, if the email is new create new user/club and give the screen acc for creation of the user/club