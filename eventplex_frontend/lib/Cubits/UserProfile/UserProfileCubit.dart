import 'package:eventplex_frontend/Cubits/UserProfile/UserProfileState.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';

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
    QueryResult result =
        await gqs.performQuery(query, {"email": "sam@gmail.com"});
    // print(result.data);
    User u = await User.fromJson(result.data!['userInfo']);
    emit(UserProfileLoadedState(u));
  }
}
