import 'package:eventplex_frontend/Cubits/UserProfile/UserProfileCubit.dart';
import 'package:eventplex_frontend/Cubits/UserProfile/UserProfileState.dart';
import 'package:eventplex_frontend/Model/Club.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/screens/EditUserProfile.dart';
import 'package:eventplex_frontend/screens/EventDetails.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Image.asset("assets/images/eventplex_logo.png",
              width: w * 0.3, height: h * 0.05, fit: BoxFit.fill),
          centerTitle: true,
          backgroundColor: Themes.lightred,
          surfaceTintColor: Themes.lightred,
        ),
        body: Container(
            width: w * 0.95,
            margin: EdgeInsets.only(left: w * 0.025),
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: BlocProvider(
              create: (context) => UserProfileCubit(),
              child: BlocBuilder<UserProfileCubit, UserProfileState>(
                  builder: (context, state) {
                if (state is UserProfileLoadedState) {
                  return Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: h / 100 * 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GFImageOverlay(
                                  image: AssetImage("assets/images/e2.jpg"),
                                  width: w * 0.5,
                                  height: h * 0.2,
                                  borderRadius:
                                      BorderRadius.circular(w / 100 * 3)),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.user.name,
                                      style: Themes.textStyle(
                                          fontsize: w / 100 * 6,
                                          fontColor: Themes.black,
                                          fw: FontWeight.bold),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.only(top: h / 100 * 1),
                                        child: Text(
                                          state.user.email,
                                          style: Themes.textStyle(
                                              fontsize: w / 100 * 4,
                                              fontColor: Themes.red,
                                              fw: FontWeight.bold),
                                        )),
                                    Container(
                                        width: w / 100 * 15,
                                        height: h / 100 * 5,
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.only(top: h / 100 * 2),
                                        decoration: BoxDecoration(
                                            color: Themes.red,
                                            shape: BoxShape.circle),
                                        child: InkWell(
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditUserProfile(
                                                            id: state
                                                                .user.id)));
                                          },
                                          child: Icon(Icons.edit_note_rounded,
                                              size: w / 100 * 8,
                                              color: Themes.white),
                                        ))
                                  ])
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: h / 100 * 3),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: w * 0.25,
                                    height: h * 0.07,
                                    decoration: BoxDecoration(
                                        color: Themes.grey,
                                        borderRadius:
                                            BorderRadius.circular(w / 100 * 4)),
                                    child: Column(children: [
                                      TweenAnimationBuilder(
                                          duration: const Duration(seconds: 1),
                                          tween: Tween<double>(
                                              begin: 0,
                                              end: state.user.following.length *
                                                  1.0),
                                          builder: (context, value, child) {
                                            return Text(
                                                value.toInt().toString(),
                                                style: Themes.textStyle(
                                                    fontsize: w / 100 * 5,
                                                    fontColor: Themes.red));
                                          }),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: h / 100 * 0.06),
                                          child: Text("Following",
                                              style: Themes.textStyle(
                                                  fontsize: w / 100 * 3,
                                                  fontColor: Themes.black)))
                                    ]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: w * 0.25,
                                    height: h * 0.07,
                                    decoration: BoxDecoration(
                                        color: Themes.grey,
                                        borderRadius:
                                            BorderRadius.circular(w / 100 * 4)),
                                    child: Column(children: [
                                      TweenAnimationBuilder(
                                          tween: Tween<double>(
                                              begin: 0,
                                              end:
                                                  state.user.pastEvents.length +
                                                      state.user.currentEvents
                                                              .length *
                                                          1.0),
                                          duration: const Duration(seconds: 1),
                                          builder: (context, value, child) {
                                            return Text(
                                                value.toInt().toString(),
                                                style: Themes.textStyle(
                                                    fontsize: w / 100 * 5,
                                                    fontColor: Themes.red));
                                          }),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: h / 100 * 0.06),
                                          child: Text("Participations",
                                              style: Themes.textStyle(
                                                  fontsize: w / 100 * 3,
                                                  fontColor: Themes.black)))
                                    ]),
                                  )
                                ])),
                        (state.user.currentEvents.isEmpty)
                            ? Container(
                                width: w * 0.95,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: h / 100 * 2, bottom: h / 100 * 2),
                                child: Text(
                                    "You haven't participated in current events yet",
                                    style: Themes.textStyle(
                                        fontsize: w / 100 * 3,
                                        fontColor: Themes.black)))
                            : Container(
                                width: w * 0.95,
                                // alignment: Alignment.,
                                margin: EdgeInsets.only(top: h / 100 * 3),
                                child: Text("Current Events(Ongoing)",
                                    style: Themes.textStyle(
                                        fontsize: w / 100 * 4,
                                        fontColor: Themes.black,
                                        fw: FontWeight.bold)),
                              ),
                        (state.user.currentEvents.isEmpty)
                            ? Container()
                            : Container(
                                width: w * 0.95,
                                height: h * 0.45,
                                margin: EdgeInsets.only(top: h / 100 * 2),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.user.currentEvents.length,
                                  //  state.club.currentEvents.length,
                                  itemBuilder: (context, index) {
                                    return event(
                                        w, h, state.user.currentEvents[0]);
                                  },
                                ),
                              ),
                        (state.user.pastEvents.isEmpty)
                            ? Container(
                                width: w * 0.95,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: h / 100 * 2, bottom: h / 100 * 2),
                                child: Text(
                                    "You haven't any past events participated in",
                                    style: Themes.textStyle(
                                        fontsize: w / 100 * 3,
                                        fontColor: Themes.black)))
                            : Container(
                                width: w * 0.95,
                                // alignment: Alignment.,
                                margin: EdgeInsets.only(top: h / 100 * 3),
                                child: Text("Past Events(Conducted)",
                                    style: Themes.textStyle(
                                        fontsize: w / 100 * 4,
                                        fontColor: Themes.black,
                                        fw: FontWeight.bold)),
                              ),
                        (state.user.pastEvents.isEmpty)
                            ? Container()
                            : Container(
                                width: w * 0.95,
                                height: h * 0.45,
                                margin: EdgeInsets.only(top: h / 100 * 2),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.user.pastEvents.length,
                                  itemBuilder: (context, index) {
                                    return event(
                                        w, h, state.user.pastEvents[index]);
                                  },
                                ),
                              ),
                        Container(
                          width: w * 0.95,
                          // alignment: Alignment.,
                          margin: EdgeInsets.only(top: h / 100 * 2),
                          child: Text("Clubs you are following:- ",
                              style: Themes.textStyle(
                                  fontsize: w / 100 * 4,
                                  fontColor: Themes.black,
                                  fw: FontWeight.bold)),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: h / 100 * 2, bottom: h / 100 * 2),
                            height: h * 0.08,
                            width: w * 0.95,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.user.following.length,
                              itemBuilder: (context, index) {
                                return club(w, h, state.user.following[index]);
                              },
                            ))
                      ]);
                } else {
                  context.read<UserProfileCubit>().loadUserDetails();
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
            ))));
  }

  Widget club(double w, double h, Club club) {
    return Container(
      width: w * 0.45,
      height: h * 0.08,
      margin: EdgeInsets.only(right: w / 100 * 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Themes.lightred, width: 3)),
          color: Themes.grey,
          borderRadius: BorderRadius.circular(w / 100 * 10)),
      child: Row(children: [
        Container(
          margin: EdgeInsets.only(left: w / 100 * 5),
          child: GFImageOverlay(
              image: AssetImage("assets/images/e1.jpg"),
              width: w * 0.12,
              height: h * 0.12,
              boxFit: BoxFit.fill,
              shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.only(left: w / 100 * 5),
          child: Text(club.name,
              style: Themes.textStyle(
                  fontsize: w / 100 * 5, fontColor: Themes.black)),
        )
      ]),
    );
  }

  Widget event(double w, double h, Event e) {
    return InkWell(
      hoverColor: Themes.transparent,
      focusColor: Themes.transparent,
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventDetails(id: e.id)));
      },
      child: Container(
          width: w * 0.9,
          height: h * 0.42,
          margin: EdgeInsets.only(bottom: h / 100 * 3),
          decoration: BoxDecoration(
              border:
                  Border(right: BorderSide(color: Themes.lightred, width: 1.5)),
              color: Themes.grey,
              borderRadius: BorderRadius.circular(w / 100 * 6)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: w * 0.8,
                    margin: EdgeInsets.only(top: h / 100 * 2),
                    child: Text(e.name,
                        style: Themes.textStyle(
                            fontsize: w / 100 * 4,
                            fontColor: Themes.black,
                            fw: FontWeight.bold))),
                Container(
                    // width: w * 0.8,
                    margin: EdgeInsets.only(top: h / 100 * 1),
                    child: GFImageOverlay(
                        image: const AssetImage("assets/images/e2.jpg"),
                        width: w * 0.8,
                        height: h * 0.3,
                        borderRadius: BorderRadius.circular(w / 100) * 6)),
                Container(
                    width: w * 0.8,
                    margin:
                        EdgeInsets.only(top: h / 100 * 1, bottom: h / 100 * 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.category,
                            style: Themes.textStyle(
                                fontsize: w / 100 * 4,
                                fontColor: Themes.black)),
                        Container(
                          width: w / 100 * 20,
                          height: h / 100 * 4,
                          // alignment: Alignment.center,
                          // padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Themes.red,
                              borderRadius: BorderRadius.circular(w / 100 * 5)),
                          child: Text(e.rating,
                              textAlign: TextAlign.center,
                              style: Themes.textStyle(
                                  fontsize: w / 100 * 5,
                                  fontColor: Themes.white,
                                  fw: FontWeight.w700)),
                        )
                      ],
                    )),
              ])),
    );
  }
}
