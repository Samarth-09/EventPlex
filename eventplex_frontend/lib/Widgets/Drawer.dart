import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Widgets extends StatefulWidget {
  const Widgets({super.key});

  @override
  State<Widgets> createState() => _WidgetsState();
}

class _WidgetsState extends State<Widgets> {
  String? name, dp;
  @override
  void initState() {
    super.initState();
    loadUser().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: Themes.white,
      surfaceTintColor: Themes.white,
      child: SingleChildScrollView(
        child: SizedBox(
          height: h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // height: h,
                // margin: EdgeInsets.only(top: h / 100 * 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: h / 100 * 4, bottom: h / 100 * 2),
                      width: w * 0.9,
                      decoration: BoxDecoration(
                          color: Themes.lightred,
                          border: Border(
                              bottom:
                                  BorderSide(color: Themes.red, width: 1.5))),
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: h / 100 * 3),
                              child: (dp == null)
                                  ? Container()
                                  : GFImageOverlay(
                                      image: NetworkImage(dp!),
                                      width: w * 0.3,
                                      height: h * 0.15,
                                      shape: BoxShape.circle,
                                      boxFit: BoxFit.fill,
                                    )),
                          Container(
                              margin: EdgeInsets.only(top: h / 100 * 1),
                              child: Text(
                                name.toString(),
                                style: Themes.textStyle(
                                    fontsize: w / 100 * 6,
                                    fontColor: Themes.black,
                                    fw: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                    InkWell(
                        splashColor: Themes.white,
                        hoverColor: Themes.white,
                        onTap: () async {
                          // await Future.delayed(Duration(milliseconds: 500));
                          await Navigator.pushNamed(context, Routes.eventFeed);
                          Navigator.pop(context);
                        },
                        child: drawerCard(w, h, "EventFeed")),
                    InkWell(
                        onTap: () async {
                          String r = (await SharedPreferences.getInstance())
                              .getString("role")!;
                          print(r);
                          if (r == "user") {
                            // await Future.delayed(Duration(milliseconds: 500));
                            await Navigator.pushNamed(
                                context, Routes.userProfile);
                          } else if (r == 'club') {
                            // await Future.delayed(Duration(milliseconds: 500));
                            await Navigator.pushNamed(
                                context, Routes.clubProfile);
                          }
                          Navigator.pop(context);
                        },
                        child: drawerCard(w, h, "Dashboard")),
                    InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(context, Routes.login);
                          Navigator.pop(context);
                        },
                        child: drawerCard(w, h, "Login")),
                    InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          await Navigator.pushNamed(context, Routes.login);
                        },
                        child: drawerCard(w, h, "LogOut"))
                  ],
                ),
              ),
              Container(
                  // margin: EdgeInsets.only(top: h / 100 * 4),
                  padding: EdgeInsets.symmetric(
                      horizontal: w / 100 * 2, vertical: h / 100 * 2),
                  decoration: BoxDecoration(
                      color: Themes.lightred,
                      border: Border(
                          top: BorderSide(color: Themes.red, width: 1.5))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Contact Us",
                            style: Themes.textStyle(
                                fontsize: w / 100 * 4.5,
                                fontColor: Themes.black,
                                fw: FontWeight.bold)
                            // .copyWith(decoration: TextDecoration.underline)
                            ),
                        Container(
                          margin: EdgeInsets.only(top: h / 100 * 2),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    // await LaunchApp.openApp(
                                    //     openStore: true,
                                    //     androidPackageName:
                                    //         "com.google.android.gm");
                                    String email = Uri.encodeComponent(
                                        "srparekh0909@gmail.com");
                                    String subject = Uri.encodeComponent(
                                        "Some Suggestions from $name");
                                    String body =
                                        Uri.encodeComponent("Hello Samarth!");
                                    print(subject); //output: Hello%20Flutter
                                    Uri mail = Uri.parse(
                                        "mailto:$email?subject=$subject&body=$body");
                                    await launchUrl(mail);
                                  },
                                  child: Image.network(
                                      "https://img.icons8.com/ios-filled/50/fa2528/gmail-new.png",
                                      width: w / 100 * 8,
                                      height: h / 100 * 4,
                                      fit: BoxFit.fill),
                                ),
                                InkWell(
                                  onTap: () async {
                                    launchUrl(Uri.parse(
                                        "https://www.linkedin.com/in/samarth-parekh-8948492a8/"));
                                  },
                                  child: Image.network(
                                      "https://img.icons8.com/ios-filled/50/fa2528/linkedin.png",
                                      width: w / 100 * 8,
                                      height: h / 100 * 4,
                                      fit: BoxFit.fill),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await launchUrl(Uri.parse(
                                        "https://www.instagram.com/samarth_9_9?igsh=MWpwcmN1MXQyZGlzdQ=="));
                                    // await LaunchApp.openApp(
                                    //     openStore: true,
                                    //     androidPackageName: "com.google.android.gm");
                                  },
                                  child: Image.network(
                                      "https://img.icons8.com/glyph-neue/64/fa2528/instagram-new--v1.png",
                                      width: w / 100 * 8,
                                      height: h / 100 * 4,
                                      fit: BoxFit.fill),
                                )
                              ]),
                        ),
                        // Container(
                        //     // width: w * 0.45,
                        //     margin: EdgeInsets.only(top: h / 100 * 1),
                        //     child: Text(
                        //       "\"Events that Inspire, Connections that lasts!!\"",
                        //       style: Themes.textStyle(
                        //               fontsize: w / 100 * 3,
                        //               fontColor: Themes.red)
                        //           .copyWith(fontStyle: FontStyle.italic),
                        //     )),
                        // Container(
                        //   margin: EdgeInsets.only(top: h / 100 * 2),
                        //   child: Image.asset("assets/images/eventplex_logo.png",
                        //       width: w * 0.35,
                        //       height: h * 0.06,
                        //       fit: BoxFit.fill),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(top: h / 100 * 1),
                        //   child: Text("© 2024 EventPlex. All rights reserved.",
                        //       style: Themes.textStyle(
                        //           fontsize: w / 100 * 3,
                        //           fontColor: Themes.black)),
                        // ),
                      ]))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadUser() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    name = sf.getString("name");
    dp = sf.getString("dp");
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
