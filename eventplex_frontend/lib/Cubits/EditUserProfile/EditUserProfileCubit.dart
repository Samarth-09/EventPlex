import 'package:eventplex_frontend/Cubits/EditUserProfile/EditUserProfileState.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit() : super(EditUserProfileState());
  GraphQLService gqs = GraphQLService();
  Api api = Api();
  void loadUserDetails(String id) async {
    User u = await api.getUserById(id);
    // print(u.name);
    emit(EditUserProfileLoadedState(u));
  }

  void updateData(
      String id, String? dp, String? name, String? email, String? keywords) async {
    emit(EditUserProfileState());
    List<String>? l = (keywords == null)?null:keywords.split(",");
    String query = '''mutation(\$data: profileInput){
    editUser(data: \$data){
    _id
    dp
    name
    email
    keywords
    }
    }
''';
    QueryResult result = await gqs.performMutation(query, {
      "data": {"_id": id, "name": name, "email": email, "dp": dp, "keywords": l}
    });
    User u = User.fromJson(result.data!["editUser"]);
    emit(EditUserProfileLoadedState(u));
  }
}
