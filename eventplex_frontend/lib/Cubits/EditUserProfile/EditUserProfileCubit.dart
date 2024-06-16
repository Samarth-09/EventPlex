import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eventplex_frontend/Cubits/EditUserProfile/EditUserProfileState.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:path_provider/path_provider.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit() : super(EditUserProfileState());
  GraphQLService gqs = GraphQLService();
  Api api = Api();
  void loadUserDetails(String id) async {
    User u = await api.getUserById(id);
    // print(u.name);
    File f = await toImage(u.dp);
    emit(EditUserProfileLoadedState(u, f));
  }

  void updateData(String id, File? dp, String? name, String? email,
      String? keywords) async {
    emit(EditUserProfileState());
    List<String>? l = (keywords == null) ? null : keywords.split(",");
    String query = '''mutation(\$data: profileInput){
    editUser(data: \$data){
    _id
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
    api.uploadImage(dp!);
    QueryResult result = await gqs.performMutation(query, {
      "data": {"_id": id, "name": name, "email": email, "keywords": l}
    });
    print(1);
    // print(result.data!['editUser']);
    // User u = User.fromJson(result.data!["editUser"]);
    // emit(EditUserProfileLoadedState(u));
  }

  Future<File> toImage(String s) async {
    //  covert String(made from codes) to uint8
    // Uint8List y = Uint8List.fromList(s.codeUnits);
    Uint8List bytes = base64Decode(s);
    // create a temporary file at a temporary directory and then write those image's byte to the file
    var tempDir = await getTemporaryDirectory();
    File f = await File('${tempDir.path}/image.png').create();
    // print(img);
    f.writeAsBytesSync(bytes);

    // Uint8List bytes = base64Decode(s);
    // File f = File.fromRawPath(bytes);
    return f;
  }
}
