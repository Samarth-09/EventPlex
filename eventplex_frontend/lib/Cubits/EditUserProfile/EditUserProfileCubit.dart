import 'dart:io';
import 'package:eventplex_frontend/Cubits/EditUserProfile/EditUserProfileState.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit() : super(EditUserProfileState());
  GraphQLService gqs = GraphQLService();
  Api api = Api();
  void loadUserDetails(String id) async {
    User u = await api.getUserById(id);
    // print(u.name);
    // File f = await toImage(u.dp);
    emit(EditUserProfileLoadedState(u));
  }

  void updateData(String id, File? dp, String? name, String? email,
      String? keywords) async {
    emit(EditUserProfileState());
    List<String>? l = (keywords == null) ? null : keywords.split(",");
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
    // print({"_id": id, "name": name, "email": email, "dp": dp, "keywords": l});
    // dp = jsonEncode({
    //   "img": dp
    // });
    //  dp!.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
    // print(dp);
    // api.uploadImage(dp!);
    String? imgLink;
    // print(email);
    // print(dp);
    if (dp != null) {
      email ??= (await SharedPreferences.getInstance()).getString("email");
      imgLink = await uploadImageAndGetUrl(email!, dp);
      print(imgLink);
    }
    

    QueryResult result = await gqs.performMutation(query, {
      "data": {
        "_id": id,
        "dp": imgLink,
        "name": name,
        "email": email,        
        "keywords": l
      }
    });
    print(result);
    User u = User.fromJson(result.data!["editUser"]);
    emit(EditUserProfileLoadedState(u));
  }

  Future<String> uploadImageAndGetUrl(String email, File img) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageref = storageRef.child(
          "$email/images/dp.jpg");
          // /${DateTime.now().microsecondsSinceEpoch}-${img.path.split("/").last}
          // ");
      await imageref.putFile(img);
      print(2);
      return await imageref.getDownloadURL();
    } catch (e) {
      print(e);
      return "";
    }
  }
}
