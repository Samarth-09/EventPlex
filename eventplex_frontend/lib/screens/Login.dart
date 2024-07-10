import 'package:eventplex_frontend/Cubits/Login/LoginCubit.dart';
import 'package:eventplex_frontend/Cubits/Login/LoginState.dart';
import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/screens/EventFeed.dart';
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
  BuildContext? c;
  Future<String>? email;
  @override
  void initState() {
    super.initState();
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
        child: BlocBuilder<LoginCubit, LoginState>(builder: (con, state) {
          if (state is LoginInitialState) {
            c = con;
            return SizedBox(
              width: w * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: h / 100 * 2),
                    // height: h * 0.88,
                    child: Image.asset("assets/images/login.png",
                        height: h * 0.7, width: w * 0.85, fit: BoxFit.fill),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 1),
                      child: Text(
                        "EventPlex is a platform that facilitates networking and collaboration between event enthusiasts and event organizers.",
                        textAlign: TextAlign.center,
                        style: Themes.textStyle(
                            fontsize: w / 100 * 4,
                            fontColor: Themes.black,
                            fw: FontWeight.w600),
                      )),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                        // isScrollControlled: true,
                        context: con,
                        builder: (context) => bottomSheet(w, h, con),
                      );
                    },
                    child: Container(
                        width: w * 0.85,
                        margin: EdgeInsets.only(top: h / 100 * 2),
                        alignment: Alignment.center,
                        height: h * 0.065,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(w / 100 * 3),
                            color: Themes.red),
                        child: Text("Login",
                            style: TextStyle(
                                color: Themes.white,
                                fontSize: w / 100 * 3.5,
                                fontWeight: FontWeight.w600))),
                  ),
                  InkWell(
                    splashColor: Themes.transparent,
                    hoverColor: Themes.transparent,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.signin);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: h / 100 * 2),
                        child: Text.rich(TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                color: Themes.black,
                                fontSize: w / 100 * 3,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                      color: Themes.red,
                                      fontSize: w / 100 * 3,
                                      fontWeight: FontWeight.w600))
                            ]))),
                  ),
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
      onTap: () {
        context.read<LoginCubit>().loginUsingGoogle(auth);
        auth.authStateChanges().listen((event) async {
          if (event!.emailVerified) {
            SharedPreferences sf = await SharedPreferences.getInstance();
            sf.setString("email", event.email.toString());
            print(event.email);
            u = event;
            setState(() {});
            if (event.emailVerified) {
              context.read<LoginCubit>().loadCurrentUser(event.email!);
            }
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return EventFeed(email: event.email!);
              },
            ));
          }
        });
      },
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

  Widget bottomSheet(double w, double h, BuildContext c) {
    return Container(
      width: w,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: h / 100 * 1),
            width: w * 0.4,
            height: h / 100 * 0.5,
            decoration: BoxDecoration(
                color: Color.fromARGB(50, 0, 0, 0),
                borderRadius: BorderRadius.circular(w / 100 * 10)),
          ),
          Container(
            width: w * 0.8,
            height: h * 0.1,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: h / 100 * 2),
            child: Image.asset("assets/images/eventplex_logo.png",
                width: w * 0.7, fit: BoxFit.contain),
          ),

          Container(
              margin: EdgeInsets.only(top: h / 100 * 3),
              child: Text("Login",
                  style: Themes.textStyle(
                      fontsize: w / 100 * 4,
                      fontColor: Themes.black,
                      fw: FontWeight.bold))),
          Container(
              margin: EdgeInsets.only(top: h / 100 * 1),
              padding: EdgeInsets.symmetric(horizontal: w * 0.38),
              child: Divider(color: Themes.red, thickness: 1.5)),
          // Container(
          // margin: EdgeInsets.only(top: 0),
          // padding: EdgeInsets.symmetric(horizontal: w * 0.3),
          // child: Divider(color: Themes.black, thickness: 1)),
          Container(
              margin: EdgeInsets.only(top: h / 100 * 1),
              child: Text("Select your Role",
                  style: Themes.textStyle(
                    fontsize: w / 100 * 3,
                    fontColor: Themes.black,
                    // fw: FontWeight.bold
                  ))),
          BlocProvider(
            create: (context) => LoginCubit(),
            child:
                BlocBuilder<LoginCubit, LoginState>(builder: (context, state1) {
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
              margin: EdgeInsets.only(top: h / 100 * 3),
              child: Row(children: [
                Expanded(
                    child: Divider(
                        thickness: 1,
                        indent: w / 100 * 10,
                        endIndent: w / 100 * 2)),
                Text("Sign In Using",
                    style: Themes.textStyle(
                        fontsize: w / 100 * 3, fontColor: Themes.black)),
                Expanded(
                    child: Divider(
                        thickness: 1,
                        indent: w / 100 * 2,
                        endIndent: w / 100 * 10)),
              ])),
          Container(
            margin: EdgeInsets.only(top: h / 100 * 1),
            child: (u == null)
                ? googleSignInButton(w, h, c)
                : Container(child: Text(u!.email.toString())),
          )
        ]),
      ),
    );
  }
}
