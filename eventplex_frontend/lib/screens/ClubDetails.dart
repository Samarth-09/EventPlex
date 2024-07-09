import 'package:eventplex_frontend/Cubits/ClubDetails/ClubDetailsCubit.dart';
import 'package:eventplex_frontend/Cubits/ClubDetails/ClubDetailsState.dart';
import 'package:eventplex_frontend/Widgets/Drawer.dart';
import 'package:eventplex_frontend/screens/EventDetails.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Model/Event.dart';

// ignore: must_be_immutable
class ClubDetails extends StatefulWidget {
  String id = '';
  ClubDetails({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<ClubDetails> createState() => _ClubDetailsState(id);
}

class _ClubDetailsState extends State<ClubDetails> {
  String id;
  _ClubDetailsState(this.id);
  String role = "";
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: const Widgets(),
        appBar: AppBar(
          title: Image.asset("assets/images/eventplex_logo.png",
              width: w * 0.3, height: h * 0.05, fit: BoxFit.fill),
          centerTitle: true,
          backgroundColor: Themes.lightred,
          surfaceTintColor: Themes.lightred,
        ),
        body: Container(
            margin: EdgeInsets.only(left: w * 0.025),
            width: w * 0.95,
            height: h,
            child: BlocProvider(
                create: (context) => ClubDetailsCubit(),
                child: BlocBuilder<ClubDetailsCubit, ClubDetailsState>(
                    builder: (context, state) {
                  if (state is ClubDetailsStateLoaded) {
                    return SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          GFImageOverlay(
                              image:
                                  //  AssetImage((state.event.images.isEmpty)
                                  // ?
                                  NetworkImage(state.club.dp),
                              // : state.event.images[0]),
                              margin: EdgeInsets.only(top: h / 100 * 2),
                              height: h * 0.3,
                              width: w * 0.95,
                              boxFit: BoxFit.fill,
                              borderRadius: BorderRadius.circular(w / 100 * 5)),
                          Container(
                            width: w * 0.95,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: h / 100 * 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.club.name,
                                    style: Themes.textStyle(
                                        fontsize: w / 100 * 6,
                                        fontColor: Themes.black,
                                        fw: FontWeight.bold)),
                                (role == "club")
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          //add the the logged in user to the following list of this club if not there else remove theme
                                          context
                                              .read<ClubDetailsCubit>()
                                              .changeFollowing(
                                                  state.club, state.following);
                                        },
                                        child: Text(
                                            (state.following)
                                                ? "UnFollow"
                                                : "Follow",
                                            style: Themes.textStyle(
                                              fontsize: w / 100 * 4,
                                              fontColor: Themes.red,
                                              // fw: FontWeight.bold
                                            )),
                                      ),
                              ],
                            ),
                          ),
                          (state.club.currentEvents.isEmpty)
                              ? Container(
                                  width: w * 0.95,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      top: h / 100 * 2, bottom: h / 100 * 2),
                                  child: Text("Club has no Events hosted",
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
                          (state.club.currentEvents.isEmpty)
                              ? Container()
                              : Container(
                                  width: w * 0.95,
                                  height: h * 0.42 + h / 100 * 3.5,
                                  margin: EdgeInsets.only(top: h / 100 * 2),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.club.currentEvents.length,
                                    itemBuilder: (context, index) {
                                      return event(w, h,
                                          state.club.currentEvents[index]);
                                    },
                                  ),
                                ),
                          (state.club.pastEvents.isEmpty)
                              ? Container(
                                  width: w * 0.95,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      top: h / 100 * 2, bottom: h / 100 * 2),
                                  child: Text("Club has no past Events hosted",
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
                          (state.club.pastEvents.isEmpty)
                              ? Container()
                              : Container(
                                  width: w * 0.95,
                                  height: h * 0.42 + h / 100 * 3.5,
                                  margin: EdgeInsets.only(top: h / 100 * 2),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.club.pastEvents.length,
                                    itemBuilder: (context, index) {
                                      return event(
                                          w, h, state.club.pastEvents[index]);
                                    },
                                  ),
                                )
                        ]));
                  } else {
                    context
                        .read<ClubDetailsCubit>()
                        .loadClubDetails(id)
                        .then((value) => role = value);
                    return Center(
                      child: Container(
                        width: w,
                        height: h,
                        child: LoadingAnimationWidget.fourRotatingDots(
                            color: Themes.red, size: w / 100 * 20),
                      ),
                    );
                  }
                }))));
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
