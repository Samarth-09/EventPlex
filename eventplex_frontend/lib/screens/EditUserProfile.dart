import 'dart:io';

import 'package:eventplex_frontend/Cubits/EditUserProfile/EditUserProfileState.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventplex_frontend/Cubits/EditUserProfile/EditUserProfileCubit.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class EditUserProfile extends StatefulWidget {
  String id;
  EditUserProfile({super.key, required this.id});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState(id);
}

class _EditUserProfileState extends State<EditUserProfile> {
  String id;
  _EditUserProfileState(this.id);
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController keywords = TextEditingController();
  File? img;
  Future<String> takephoto() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
    var x = await image.readAsBytes();
    String s = String.fromCharCodes(x);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: Image.asset("assets/images/eventplex_logo.png",
            width: w * 0.3, height: h * 0.05, fit: BoxFit.fill),
        centerTitle: true,
        backgroundColor: Themes.lightred,
        surfaceTintColor: Themes.lightred,
      ),
      body: Container(
          width: w * 0.95,
          height: h,
          margin: EdgeInsets.only(left: w * 0.025),
          child: SingleChildScrollView(
              child: BlocProvider(
            create: (context) => EditUserProfileCubit(),
            child: BlocBuilder<EditUserProfileCubit, EditUserProfileState>(
                builder: (context, state) {
              if (state is EditUserProfileLoadedState) {
                String s = "";
                state.user.keywords.forEach((e) => s += ("$e,"));
                return Column(children: [
                  // Container(
                  //     width: w * 0.95,
                  //     alignment: Alignment.centerLeft,
                  //     margin: EdgeInsets.only(top: h / 100 * 2),
                  //     child: Text(
                  //       "Edit Your Profile",
                  //       style: Themes.textStyle(
                  //           fontsize: w / 100 * 6, fontColor: Themes.black),
                  //     )),
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 2),
                      child: Stack(children: [
                        GFImageOverlay(
                            image: (img == null)
                                ? AssetImage("assets/images/e1.jpg")
                                : FileImage(img!) as ImageProvider,
                            width: w * 0.4,
                            height: h * 0.2,
                            boxFit: BoxFit.fill,
                            shape: BoxShape.circle),
                        Positioned(
                            bottom: h / 100 * 1,
                            right: w / 100 * 1,
                            child: Container(
                              width: w / 100 * 15,
                              height: h / 100 * 5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Themes.red, shape: BoxShape.circle),
                              child: InkWell(
                                onTap: () async {
                                  String s = await takephoto();
                                  context
                                      .read<EditUserProfileCubit>()
                                      .loadUserDetails(id);
                                },
                                child: Icon(Icons.upload_rounded,
                                    size: w / 100 * 8, color: Themes.white),
                              ),
                            ))
                      ])),
                  textFeild(w, h, state.user.name, name),
                  textFeild(w, h, state.user.email, email),
                  textFeild(w, h, s, keywords),
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 2),
                      child: Text(
                        "*Write interests with comma seperations",
                        style: Themes.textStyle(
                            fontsize: w / 100 * 3, fontColor: Themes.black),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 3),
                      width: w * 0.9,
                      height: h * 0.06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Themes.red,
                          borderRadius: BorderRadius.circular(w / 100 * 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit,
                              size: w / 100 * 6, color: Themes.white),
                          Text(
                            "Edit",
                            style: Themes.textStyle(
                                fontsize: w / 100 * 5,
                                fontColor: Themes.white,
                                fw: FontWeight.bold),
                          )
                        ],
                      )),
                ]);
              } else {
                context.read<EditUserProfileCubit>().loadUserDetails(id);
                return Center(
                  child: Container(
                    width: w,
                    height: h,
                    child: LoadingAnimationWidget.fourRotatingDots(
                        color: Themes.red, size: w / 100 * 20),
                  ),
                );
              }
            }),
          ))),
    );
  }

  Widget textFeild(double w, double h, String s, TextEditingController t) {
    return Container(
        margin: EdgeInsets.only(top: h / 100 * 6),
        child: TextFormField(
            controller: t,
            cursorColor: Themes.lightred,
            style: Themes.textStyle(
                fontsize: w / 100 * 5, fontColor: Themes.black),
            decoration: InputDecoration(
              label: Text(s,
                  style: Themes.textStyle(
                      fontsize: w / 100 * 5, fontColor: Themes.black)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w / 100 * 10),
                  borderSide: BorderSide(color: Themes.black, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w / 100 * 10),
                  borderSide: BorderSide(color: Themes.lightred, width: 2)),
            )));
  }
}
