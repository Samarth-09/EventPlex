import 'package:eventplex_frontend/Routes.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';

class Widgets {
  Widget AppDrawer(double w, double h, BuildContext context) {
    return Drawer(
      backgroundColor: Themes.white,
      surfaceTintColor: Themes.white,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: h / 100 * 3),
              child: GFImageOverlay(
                image: AssetImage("assets/images/e2.jpg"),
                width: w * 0.3,
                height: h * 0.2,
                shape: BoxShape.circle,
                boxFit: BoxFit.fill,
              )),
          Container(
              margin: EdgeInsets.only(top: h / 100 * 1),
              child: Text(
                "Samarth Parekh",
                style: Themes.textStyle(
                    fontsize: w / 100 * 6,
                    fontColor: Themes.black,
                    fw: FontWeight.bold),
              )),
          Container(
              margin: EdgeInsets.only(top: h / 100 * 3),
              child: Divider(
                color: Themes.red,
                thickness: 1,
                indent: w / 100 * 2,
                endIndent: w / 100 * 2,
              )),
          InkWell(
              onTap: () async {
                await Navigator.pushNamed(context, Routes.eventFeed);
              },
              child: drawerCard(w, h, "EventFeed")),
          InkWell(
              onTap: () async {
                await Navigator.pushNamed(context, Routes.userProfile);
              },
              child: drawerCard(w, h, "Dashboard")),
          InkWell(
              onTap: () async {
                await Navigator.pushNamed(context, Routes.Login);
              },
              child: drawerCard(w, h, "Login"))
        ],
      ),
    );
  }

  Widget drawerCard(double w, double h, String s) {
    return Container(
        margin: EdgeInsets.only(top: h / 100 * 3),
        width: w * 0.6,
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
