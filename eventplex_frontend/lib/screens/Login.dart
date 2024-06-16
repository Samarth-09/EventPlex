import 'package:eventplex_frontend/Cubits/Login/LoginCubit.dart';
import 'package:eventplex_frontend/Cubits/Login/LoginState.dart';
import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';

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
    // TODO: implement initState
    super.initState();
    auth.authStateChanges().listen((event) async {
      // if(event!.emailVerified){
        SharedPreferences sf = await SharedPreferences.getInstance();
      sf.setString("email", event!.email.toString());
      print(event.email);
      u=event;
      setState(() {
        
      });
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
      color: Themes.lightred,
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          if (state is LoginInitialState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/eventplex_logo.png",
                    width: w * 0.5, height: h * 0.15, fit: BoxFit.fill),
                Container(
                    margin: EdgeInsets.only(top: h / 100 * 1),
                    padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: Divider(color: Themes.black, thickness: 1.5)),
                Container(
                  margin: EdgeInsets.only(top: h / 100 * 3),
                  child: (u == null)
                      ? googleSignInButton(w, h, context)
                      : Container(child: Text(u!.email.toString())),
                )
              ],
            );
          } else {
            return Container();
          }
        }),
      ),
    ));
  }

  Widget googleSignInButton(double w, double h, BuildContext context) {
    return SizedBox(
        width: w * 0.8,
        height: h * 0.1,
        child: SignInButton(
          Buttons.google,
          text: "Sign Up Using Google",
          onPressed: () {
            context.read<LoginCubit>().loginUsingGoogle(auth);
            // print(u!.email);
          },
        ));
  }
}
