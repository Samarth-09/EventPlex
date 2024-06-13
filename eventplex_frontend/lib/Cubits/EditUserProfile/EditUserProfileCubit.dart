import 'package:eventplex_frontend/Cubits/EditUserProfile/EditUserProfileState.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Services/Api.dart';
import 'package:eventplex_frontend/Services/GraphQLService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit() : super(EditUserProfileState());
  GraphQLService gqs = GraphQLService();
  Api api = Api();
  void loadUserDetails(String id) async {
    User u = await api.getUserById(id);
    // print(u.name);
    emit(EditUserProfileLoadedState(u));
  }
}
