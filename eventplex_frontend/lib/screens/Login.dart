import 'package:eventplex_frontend/Cubits/Login/LoginCubit.dart';
import 'package:eventplex_frontend/Cubits/Login/LoginState.dart';
import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? u;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((event) async {
      // if(event!.emailVerified){
      SharedPreferences sf = await SharedPreferences.getInstance();
      sf.setString("email", event!.email.toString());
      print(event.email);
      u = event;
      setState(() {});
      Navigator.pushNamed(context, Routes.eventFeed);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      width: w,
      height: h,
      // color: Themes.lightred,
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          if (state is LoginInitialState) {
            return SizedBox(
              width: w * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: w * 0.8,
                    height: h * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Themes.lightred,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(w / 100 * 8),
                            bottomRight: Radius.circular(w / 100 * 8))),
                    // margin: EdgeInsets.only(top: h / 100 * 3),
                    child: Image.asset("assets/images/eventplex_logo.png",
                        width: w * 0.55, height: h * 0.13, fit: BoxFit.fill),
                  ),

                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 3),
                      child: Text("Login",
                          style: Themes.textStyle(
                              fontsize: w / 100 * 6,
                              fontColor: Themes.black,
                              fw: FontWeight.bold))),
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 0.1),
                      padding: EdgeInsets.symmetric(horizontal: w * 0.38),
                      child: Divider(color: Themes.red, thickness: 1.5)),
                  // Container(
                  // margin: EdgeInsets.only(top: 0),
                  // padding: EdgeInsets.symmetric(horizontal: w * 0.3),
                  // child: Divider(color: Themes.black, thickness: 1)),
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 3),
                      child: Text("Select your Role",
                          style: Themes.textStyle(
                            fontsize: w / 100 * 4,
                            fontColor: Themes.black,
                            // fw: FontWeight.bold
                          ))),
                  BlocProvider(
                    create: (context) => LoginCubit(),
                    child: BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state1) {
                      if (state1 is LoginInitialState) {
                        return selectRoleWidget(w, h, state1.i, context);
                      } else if (state1 is LoginRoleSelectedState) {
                        return selectRoleWidget(w, h, state1.i, context);
                      } else {
                        return Container();
                      }
                    }),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 4),
                      child: Row(children: [
                        Expanded(
                            child: Divider(
                                thickness: 1,
                                indent: w / 100 * 10,
                                endIndent: w / 100 * 2)),
                        Text("Sign In Using",
                            style: Themes.textStyle(
                                fontsize: w / 100 * 3,
                                fontColor: Themes.black)),
                        Expanded(
                            child: Divider(
                                thickness: 1,
                                indent: w / 100 * 2,
                                endIndent: w / 100 * 10)),
                      ])),
                  Container(
                    margin: EdgeInsets.only(top: h / 100 * 1),
                    child: (u == null)
                        ? googleSignInButton(w, h, context)
                        : Container(child: Text(u!.email.toString())),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        }),
      ),
    ));
  }

  Widget googleSignInButton(double w, double h, BuildContext context) {
    return InkWell(
      onTap: () => context.read<LoginCubit>().loginUsingGoogle(auth),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: h / 100 * 2, horizontal: w / 100 * 3),
        child: Column(
          children: [
            Image.network("https://img.icons8.com/fluency/96/google-logo.png",
                width: w / 100 * 10, height: h / 100 * 5, fit: BoxFit.fill),
            Text("Google",
                style: Themes.textStyle(
                    fontsize: w / 100 * 3, fontColor: Themes.black))
          ],
        ),
      ),
    );
  }

  Widget selectRoleWidget(double w, double h, int i, BuildContext c) {
    return Container(
        margin: EdgeInsets.only(top: h / 100 * 2),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Themes.transparent,
                hoverColor: Themes.transparent,
                onTap: () => c.read<LoginCubit>().selectRole(0),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: w / 100 * 3, vertical: h / 100 * 1),
                        decoration: BoxDecoration(
                            color: (i == 0) ? Themes.red : Themes.lightred,
                            border: Border.all(color: Themes.red, width: 1.5),
                            borderRadius: BorderRadius.circular(w / 100 * 5)),
                        child: Icon(Icons.groups_3_rounded,
                            color: Themes.white, size: w / 100 * 15)),
                    Text("Club",
                        style: Themes.textStyle(
                            fontsize: w / 100 * 4, fontColor: Themes.black))
                  ],
                ),
              ),
              Container(
                  height: h * 0.1,
                  padding: EdgeInsets.symmetric(vertical: w / 100 * 2),
                  child: VerticalDivider(thickness: 0.4, color: Themes.black)),
              InkWell(
                splashColor: Themes.transparent,
                hoverColor: Themes.transparent,
                onTap: () => c.read<LoginCubit>().selectRole(1),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: w / 100 * 3, vertical: h / 100 * 1),
                        decoration: BoxDecoration(
                            color: (i == 1) ? Themes.red : Themes.lightred,
                            border: Border.all(color: Themes.red, width: 1.5),
                            borderRadius: BorderRadius.circular(w / 100 * 5)),
                        child: Icon(Icons.person_2_rounded,
                            color: Themes.white, size: w / 100 * 15)),
                    Text("User",
                        style: Themes.textStyle(
                            fontsize: w / 100 * 4, fontColor: Themes.black))
                  ],
                ),
              )
            ]));
  }
}
