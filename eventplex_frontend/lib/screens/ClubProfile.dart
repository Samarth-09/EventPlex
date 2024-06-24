import 'package:eventplex_frontend/Cubits/ClubProfile/ClubProfileCubit.dart';
import 'package:eventplex_frontend/Cubits/ClubProfile/ClubProfileState.dart';
import 'package:eventplex_frontend/Cubits/UserProfile/UserProfileCubit.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Model/User.dart';
import 'package:eventplex_frontend/Widgets/Drawer.dart';
import 'package:eventplex_frontend/screens/EditUserProfile.dart';
import 'package:eventplex_frontend/screens/EventDetails.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ClubProfile extends StatefulWidget {
  const ClubProfile({super.key});

  @override
  State<ClubProfile> createState() => _ClubProfileState();
}

class _ClubProfileState extends State<ClubProfile> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: Widgets().AppDrawer(w, h, context),
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
              create: (context) => ClubProfileCubit(),
              child: BlocBuilder<ClubProfileCubit, ClubProfileState>(
                  builder: (context, state) {
                if (state is ClubProfileStateLoadedState) {
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
                                  image: NetworkImage(state.club.dp),
                                  width: w * 0.45,
                                  height: h * 0.2,
                                  borderRadius:
                                      BorderRadius.circular(w / 100 * 3)),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.club.name,
                                      style: Themes.textStyle(
                                          fontsize: w / 100 * 6,
                                          fontColor: Themes.black,
                                          fw: FontWeight.bold),
                                    ),
                                    Container(
                                        width: w * 0.45,
                                        margin:
                                            EdgeInsets.only(top: h / 100 * 1),
                                        child: Text(
                                          state.club.email,
                                          // softWrap: true,
                                          overflow: TextOverflow.fade,
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
                                                                .club.id)));
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
                                              end: state.club.followers.length *
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
                                          child: Text("Followers",
                                              style: Themes.textStyle(
                                                  fontsize: w / 100 * 3,
                                                  fontColor: Themes.black)))
                                    ]),
                                  ),
                                  (state.club.currentEvents.isEmpty)
                                      ? Container(
                                          width: w * 0.95,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: h / 100 * 2,
                                              bottom: h / 100 * 2),
                                          child: Text(
                                              "You haven't participated in current events yet",
                                              style: Themes.textStyle(
                                                  fontsize: w / 100 * 3,
                                                  fontColor: Themes.black)))
                                      : Container(
                                          width: w * 0.95,
                                          // alignment: Alignment.,
                                          margin:
                                              EdgeInsets.only(top: h / 100 * 3),
                                          child: Text("Current Events(Ongoing)",
                                              style: Themes.textStyle(
                                                  fontsize: w / 100 * 4,
                                                  fontColor: Themes.black,
                                                  fw: FontWeight.bold)),
                                        ),
                                  (state.club.currentEvents.isEmpty)
                                      ? Container()
                                      : Container(
                                          width: w * 0.95,
                                          height: h * 0.42 + h / 100 * 3.5,
                                          margin:
                                              EdgeInsets.only(top: h / 100 * 2),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                state.club.currentEvents.length,
                                            //  state.club.currentEvents.length,
                                            itemBuilder: (context, index) {
                                              print(index);
                                              return event(
                                                  w,
                                                  h,
                                                  state.club
                                                      .currentEvents[index]);
                                            },
                                          ),
                                        ),
                                  (state.club.pastEvents.isEmpty)
                                      ? Container(
                                          width: w * 0.95,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: h / 100 * 2,
                                              bottom: h / 100 * 2),
                                          child: Text(
                                              "You haven't any past events participated in",
                                              style: Themes.textStyle(
                                                  fontsize: w / 100 * 3,
                                                  fontColor: Themes.black)))
                                      : Container(
                                          width: w * 0.95,
                                          // alignment: Alignment.,
                                          margin:
                                              EdgeInsets.only(top: h / 100 * 3),
                                          child: Text("Past Events(Conducted)",
                                              style: Themes.textStyle(
                                                  fontsize: w / 100 * 4,
                                                  fontColor: Themes.black,
                                                  fw: FontWeight.bold)),
                                        ),
                                  (state.club.pastEvents.isEmpty)
                                      ? Container()
                                      : Container(
                                          width: w * 0.95,
                                          height: h * 0.42 + h / 100 * 3.5,
                                          margin:
                                              EdgeInsets.only(top: h / 100 * 2),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                state.club.pastEvents.length,
                                            itemBuilder: (context, index) {
                                              return event(w, h,
                                                  state.club.pastEvents[index]);
                                            },
                                          ),
                                        ),
                                  Container(
                                    width: w * 0.95,
                                    // alignment: Alignment.,
                                    margin: EdgeInsets.only(top: h / 100 * 2),
                                    child: Text("Club Followers:- ",
                                        style: Themes.textStyle(
                                            fontsize: w / 100 * 4,
                                            fontColor: Themes.black,
                                            fw: FontWeight.bold)),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: h / 100 * 2,
                                          bottom: h / 100 * 2),
                                      height: h * 0.08,
                                      width: w * 0.95,
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: w * 4),
                                        // scrollDirection: Axis.horizontal,
                                        itemCount: state.club.followers.length,
                                        itemBuilder: (context, index) {
                                          return club(w, h,
                                              state.club.followers[index]);
                                        },
                                      ))
                                ]))
                      ]);
                } else {
                  context.read<ClubProfileCubit>().loadClubDetails();
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

  Widget club(double w, double h, User user) {
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
              image: NetworkImage(user.dp),
              width: w * 0.12,
              height: h * 0.12,
              boxFit: BoxFit.fill,
              shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.only(left: w / 100 * 5),
          child: Text(user.name,
              style: Themes.textStyle(
                  fontsize: w / 100 * 5, fontColor: Themes.black)),
        )
      ]),
    );
  }

  Widget event(double w, double h, Event e) {
    // print(e.images);
    return InkWell(
      hoverColor: Themes.transparent,
      focusColor: Themes.transparent,
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventDetails(id: e.id)));
      },
      child: Container(
          width: w * 0.95,
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
                    child: ImageSlideshow(
                        width: w * 0.8,
                        height: h * 0.3,
                        initialPage: 0,
                        indicatorColor: Themes.lightred,
                        indicatorBackgroundColor: Themes.red,
                        onPageChanged: (value) {
                          // print('Page changed: $value');
                          // idx = value;
                        },
                        autoPlayInterval: 5000,
                        isLoop: true,
                        children: [
                          ...List.generate(
                            e.images.length,
                            (index) => GFImageOverlay(
                                image: NetworkImage(e.images[index]),
                                width: w * 0.8,
                                height: h * 0.3,
                                borderRadius:
                                    BorderRadius.circular(w / 100) * 6),
                          )
                        ])),
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
