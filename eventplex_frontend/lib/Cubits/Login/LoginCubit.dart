import 'package:eventplex_frontend/Cubits/Login/LoginState.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  void loginUsingGoogle(FirebaseAuth auth) {
    try {
      //sha-1 key is required to tell that the request for sign in is comming from legimit source
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print(e);
    }
  }

  void selectRole(int i) async {
    String role = "";
    if (i == 0) {
      print(1);
      role = "club";
    } else if (i == 1) {
      role = "user";
    }
    await (await SharedPreferences.getInstance()).setString("role", role);
    emit(LoginRoleSelectedState(i));
  }

  void loadCurrentUser(String email) async {
    QueryResult result;
    String query = '''query user(\$email: String){
    userInfo(email: \$email){
    email
    _id
    name
    dp
    }
    }''';

    result = await GraphQLService().performQuery(query, {"email": email});
    // print(sf.getString('role'));
    if (result.data!['userInfo'] == null) {
      query = '''query(\$email: String){
    clubProfile(email: \$email){
    name
    email
    _id
    dp
    }
    }''';

      result = await GraphQLService().performQuery(query, {"email": email});
      // print(result.data);
      SharedPreferences sf = await SharedPreferences.getInstance();
      sf.setString("name", result.data!['clubProfile']['name']);
      sf.setString("dp", result.data!['clubProfile']['dp']);
      return;
    }

    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setString("name", result.data!['userInfo']['name']);
    sf.setString("dp", result.data!['userInfo']['dp']);
  }
}
