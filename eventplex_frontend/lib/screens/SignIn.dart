import 'dart:io';

import 'package:eventplex_frontend/Cubits/SignIn/SignInCubit.dart';
import 'package:eventplex_frontend/Cubits/SignIn/SignInState.dart';
import 'package:eventplex_frontend/Widgets/Drawer.dart';
import 'package:eventplex_frontend/screens/EventFeed.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  File? img;
  TextEditingController name = TextEditingController();
  TextEditingController keywords = TextEditingController();
  User? u;
  final FirebaseAuth auth = FirebaseAuth.instance;
  void takephoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
    setState(() {
      print(img);
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/eventplex_logo.png",
            width: w * 0.3, height: h * 0.05, fit: BoxFit.fill),
        centerTitle: true,
        backgroundColor: Themes.lightred,
        surfaceTintColor: Themes.lightred,
      ),
      drawer: const Widgets(),
      body: Container(
          width: w * 0.95,
          height: h,
          margin: EdgeInsets.only(left: w * 0.025),
          child: SingleChildScrollView(
              child: BlocProvider(
            create: (context) => SignInCubit(),
            child: BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
              if (state is SignInStateSubmitted) {
                // print(1);
                // print(img==null);
                // String keywordsLabel = "";
                // state.club.keywords.forEach((e) => keywordsLabel += ("$e,"));
                context.read<SignInCubit>().loadCurrentUserInMemory(state.user);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EventFeed(email: state.user.email)));
                // Navigator.pop(context);
                return Container(child: Text(u!.email.toString()));
              } else if (state is SignInStateLoading) {
                return Container(
                  width: w,
                  height: h,
                  alignment: Alignment.center,
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Themes.red, size: w / 100 * 20),
                );
              } else {
                return Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 2),
                      child: Stack(children: [
                        (img == null)
                            ? Icon(Icons.photo_size_select_actual_rounded,
                                size: w * 0.4, color: Themes.lightred)
                            : GFImageOverlay(
                                image: FileImage(img!) as ImageProvider,
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
                                  takephoto();
                                },
                                child: Icon(Icons.upload_rounded,
                                    size: w / 100 * 8, color: Themes.white),
                              ),
                            ))
                      ])),
                  textFeild(w, h, "name", name),
                  textFeild(w, h, "keywords", keywords),
                  InkWell(
                    onTap: () async {
                      // s="hello";
                      // print(1);
                      context.read<SignInCubit>().loginUsingGoogle(auth);
                      auth.authStateChanges().listen((event) async {
                        if (event!.emailVerified) {
                          SharedPreferences sf =
                              await SharedPreferences.getInstance();
                          sf.setString("email", event.email.toString());
                          print(event.email);
                          u = event;
                          context.read<SignInCubit>().submit({
                            'dp': img,
                            'name': name.text,
                            'keywords': keywords.text
                          });
                        }
                      });
                    },
                    child: Container(
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
                              "Sign In",
                              style: Themes.textStyle(
                                  fontsize: w / 100 * 5,
                                  fontColor: Themes.white,
                                  fw: FontWeight.bold),
                            )
                          ],
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom))
                ]);
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
