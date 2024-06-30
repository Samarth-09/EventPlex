import 'dart:io';

import 'package:eventplex_frontend/Cubits/EditClubProfile/EditClubProfileState.dart';
import 'package:eventplex_frontend/Model/Club.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditClubProfileCubit extends Cubit<EditClubProfileState> {
  EditClubProfileCubit() : super(EditClubProfileState());
  GraphQLService gqs = GraphQLService();
  Api api = Api();
  void loadUserDetails(String id) async {
    String query = '''query(\$email: String){
    clubProfile(email: \$email){
    email
    _id
    name 
    dp
    currentEvents{
    name
      _id
    }
    pastEvents{
      _id
      name
    }
    }}''';
    SharedPreferences sf = await SharedPreferences.getInstance();
    QueryResult result =
        await gqs.performQuery(query, {"email": sf.getString("email")});
    // print(result);
    Club c = Club.fromJson(result.data!['clubProfile']);
    emit(EditClubProfileLoadedState(c));
  }

  void updateData(Map<String, dynamic> mp,Club c) async {
    emit(EditClubProfileState());
    // String? imgLink;
    // print(email);
    // print(dp);
    if (mp['dp'] != null) {
      mp['email'] = (await SharedPreferences.getInstance()).getString("email")!;
      mp['dp'] = await uploadImageAndGetUrl(mp['email'], mp['dp']);
      print(mp['dp']);
    }
    c.dp = mp['dp'];
    await api.updateClub(mp);
    emit(EditClubProfileLoadedState(c));
  }

  Future<String> uploadImageAndGetUrl(String email, File img) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageref = storageRef.child("$email/images/dp.jpg");
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
