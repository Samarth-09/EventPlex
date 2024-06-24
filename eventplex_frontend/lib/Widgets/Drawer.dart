import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Widgets {
  String? dp;

  Widget AppDrawer(double w, double h, BuildContext context) {
    return Drawer(
      backgroundColor: Themes.white,
      surfaceTintColor: Themes.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Container(
          //     margin: EdgeInsets.only(top: h / 100 * 3),
          //     child: GFImageOverlay(
          //       image: NetworkImage(),
          //       width: w * 0.3,
          //       height: h * 0.2,
          //       shape: BoxShape.circle,
          //       boxFit: BoxFit.fill,
          //     )),
          // Container(
          //     margin: EdgeInsets.only(top: h / 100 * 1),
          //     child: Text(
          //       "Samarth Parekh",
          //       style: Themes.textStyle(
          //           fontsize: w / 100 * 6,
          //           fontColor: Themes.black,
          //           fw: FontWeight.bold),
          //     )),
          // Container(
          //     margin: EdgeInsets.only(top: h / 100 * 3),
          //     child: Divider(
          //       color: Themes.red,
          //       thickness: 1,
          //       indent: w / 100 * 2,
          //       endIndent: w / 100 * 2,
          //     )),
          Container(
            // height: h,
            margin: EdgeInsets.only(top: h / 100 * 5),
            child: Column(
              children: [
                InkWell(
                    onTap: () async {
                      await Navigator.pushNamed(context, Routes.eventFeed);
                    },
                    child: drawerCard(w, h, "EventFeed")),
                InkWell(
                    onTap: () async {
                      String r = (await SharedPreferences.getInstance()).getString("role")!;
                      if(r=="user")
                      {
                        await Navigator.pushNamed(context, Routes.userProfile);
                      }
                      else if(r=='club'){
                        await Navigator.pushNamed(context, Routes.ClubProfile);
                      }
                      
                    },
                    child: drawerCard(w, h, "Dashboard")),
                InkWell(
                    onTap: () async {
                      await Navigator.pushNamed(context, Routes.Login);
                    },
                    child: drawerCard(w, h, "Login")),
                    InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      await Navigator.pushNamed(context, Routes.Login);
                    },
                    child: drawerCard(w, h, "LogOut"))
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: w / 100 * 2, vertical: h / 100 * 2),
              color: Themes.lightred,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Contact Us",
                        style: Themes.textStyle(
                                fontsize: w / 100 * 4,
                                fontColor: Themes.black,
                                fw: FontWeight.bold)
                            .copyWith(decoration: TextDecoration.underline)),
                    Container(
                      margin: EdgeInsets.only(top: h / 100 * 2),
                      child: Text("For Any Query or Suggestion, lets connect!!",
                          style: Themes.textStyle(
                              fontsize: w / 100 * 3, fontColor: Themes.black)),
                    ),
                    InkWell(
                      onTap: () async {
                        await LaunchApp.openApp(
                            openStore: true,
                            androidPackageName: "com.google.android.gm");
                      },
                      child: ListTile(
                          leading: Image.network(
                              "https://img.icons8.com/color/96/gmail-new.png",
                              width: w / 100 * 8,
                              height: h / 100 * 4,
                              fit: BoxFit.fill),
                          title: Text("srparekh0909@gmail.com",
                              style: Themes.textStyle(
                                  fontsize: w / 100 * 3,
                                  fontColor: Themes.black))),
                    ),
                    InkWell(
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            "https://www.linkedin.com/in/samarth-parekh-8948492a8/"));
                      },
                      child: ListTile(
                          leading: Image.network(
                              "https://img.icons8.com/fluency/96/linkedin.png",
                              width: w / 100 * 8,
                              height: h / 100 * 4,
                              fit: BoxFit.fill),
                          title: Text("LinkedIn",
                              style: Themes.textStyle(
                                  fontsize: w / 100 * 3,
                                  fontColor: Themes.black))),
                    ),
                    Text("© 2024 EventPlex. All rights reserved.",
                        style: Themes.textStyle(
                            fontsize: w / 100 * 3, fontColor: Themes.black)),
                    Container(
                      margin: EdgeInsets.only(top: h / 100 * 1),
                      child: Image.asset("assets/images/eventplex_logo.png",
                          width: w * 0.4, height: h * 0.05, fit: BoxFit.fill),
                    )
                  ]))
        ],
      ),
    );
  }

  Widget drawerCard(double w, double h, String s) {
    return Container(
        margin: EdgeInsets.only(top: h / 100 * 5),
        width: w * 0.7,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: h / 100 * 1.5),
        decoration: BoxDecoration(
            color: Themes.grey,
            border:
                Border(bottom: BorderSide(color: Themes.lightred, width: 1.5)),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(w / 100 * 2),
                bottomRight: Radius.circular(w / 100 * 2))),
        child: Text(s,
            style: Themes.textStyle(
              fontsize: w / 100 * 4,
              fontColor: Themes.black,
            )));
  }
}
