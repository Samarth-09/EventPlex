import 'package:eventplex_frontend/Cubits/EventDetails/EventDetailsCubit.dart';
import 'package:eventplex_frontend/Cubits/EventDetails/EventDetailsState.dart';
import 'package:eventplex_frontend/Cubits/EventDetails/EventLikeDislikeCubit.dart';
import 'package:eventplex_frontend/Cubits/EventDetails/EventLikeDislikeState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/screens/ClubDetails.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:getwidget/getwidget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class EventDetails extends StatefulWidget {
  String id;
  EventDetails({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<EventDetails> createState() => _EventDetailsState(id);
}

class _EventDetailsState extends State<EventDetails> {
  String eventId;
  _EventDetailsState(this.eventId);
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
          margin: EdgeInsets.only(left: w * 0.025),
          width: w * 0.95,
          height: h,
          child: BlocProvider(
            create: (context) => EventDetailsCubit(),
            child: BlocBuilder<EventDetailsCubit, EventDetailsState>(
                builder: (context, state) {
              // bool b = false;
              // if(context.read<EventDetailsCubit>().findEvent(eventId)){
              //   b= true;
              // }
              if (state is EventDetailsStateLoaded) {
                return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Hero(
                          tag: state.event.id,
                          child: ImageSlideshow(
                              width: w * 0.95,
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
                                  state.event.images.length,
                                  (index) => GFImageOverlay(
                                      image:
                                          AssetImage(state.event.images[index]),
                                      width: w * 0.95,
                                      height: h * 0.3,
                                      borderRadius:
                                          BorderRadius.circular(w / 100) * 6),
                                )
                              ])),
                      Container(
                        margin: EdgeInsets.only(top: h / 100 * 2),
                        child: Text(state.event.name,
                            style: Themes.textStyle(
                                fontsize: w / 100 * 6,
                                fontColor: Themes.black,
                                fw: FontWeight.bold)),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: h / 100 * 2),
                          width: w * 0.95,
                          child: Row(children: [
                            Text("${state.event.category}",
                                style: Themes.textStyle(
                                    fontsize: w / 100 * 4,
                                    fontColor: Themes.black)),
                            Container(
                                margin: EdgeInsets.only(left: w / 100 * 5),
                                child: Text(
                                    "Tickets Remaining:- ${state.event.ticketsRemaining}",
                                    style: Themes.textStyle(
                                        fontsize: w / 100 * 4,
                                        fontColor: Themes.black)))
                          ])),
                      Container(
                          margin: EdgeInsets.only(top: h / 100 * 2),
                          width: w * 0.95,
                          child: BlocProvider(
                            create: (context) => EventLikeDislikeCubit(),
                            child: BlocBuilder<EventLikeDislikeCubit,
                                    EventLikeDislikeState>(
                                builder: (context, state1) {
                              if (state1 is EventLikedState) {
                                return like_Dislike_Rating_Widget(
                                    w,
                                    h,
                                    state.event,
                                    Themes.red,
                                    Themes.lightred,
                                    context);
                              } else if (state1 is EventDislikedState) {
                                return like_Dislike_Rating_Widget(
                                    w,
                                    h,
                                    state.event,
                                    Themes.lightred,
                                    Themes.red,
                                    context);
                              } else {
                                // context
                                //     .read<EventLikeDislikeCubit>()
                                //     .findEventForLike(eventId);
                                // context
                                //     .read<EventLikeDislikeCubit>()
                                //     .findEventForDisLike(eventId);
                                return like_Dislike_Rating_Widget(
                                    w,
                                    h,
                                    state.event,
                                    Themes.lightred,
                                    Themes.lightred,
                                    context);
                              }
                            }),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: h / 100 * 3),
                        child: Text(
                          (state.event.desciption.isEmpty)
                              ? ""
                              : state.event.desciption,
                          textAlign: TextAlign.justify,
                          style: Themes.textStyle(
                              fontsize: w / 100 * 4, fontColor: Themes.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: h / 100 * 3, bottom: h / 100 * 2),
                        // padding: EdgeInsets.only(left: w * 0.05),
                        width: w * 0.95,
                        decoration: BoxDecoration(
                            color: Themes.grey,
                            borderRadius: BorderRadius.circular(w / 100 * 5)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: w *
                                      0.9, //giving it a width allow us to align the child inside the container else will take the size of its chils only
                                  margin: EdgeInsets.only(top: h / 100) * 2,
                                  child: Text("Event Information",
                                      style: Themes.textStyle(
                                          fontsize: w / 100 * 5,
                                          fontColor: Themes.black,
                                          fw: FontWeight.bold))),
                              ...List.generate(state.info.length, (index) {
                                bool b = false;
                                if (state.info[index].keys.first == "club") {
                                  b = true;
                                }
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w / 100 * 5),
                                  width: w * 0.9,
                                  margin: EdgeInsets.only(top: h / 100 * 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (b) {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClubDetails(
                                                            id: state.event
                                                                .clubId)));
                                          }
                                        },
                                        child: Text(
                                            state.info[index].keys.first
                                                .toString(),
                                            style: Themes.textStyle(
                                                    fontsize: w / 100 * 5,
                                                    fontColor: (b)
                                                        ? Themes.red
                                                        : Themes.black)
                                                .copyWith(
                                                    decorationColor: Themes.red,
                                                    decoration: (b)
                                                        ? TextDecoration
                                                            .underline
                                                        : TextDecoration.none)),
                                      ),
                                      Text(
                                          state.info[index]
                                                  [state.info[index].keys.first]
                                              .toString(),
                                          style: Themes.textStyle(
                                              fontsize: w / 100 * 5,
                                              fontColor: Themes.black))
                                    ],
                                  ),
                                );
                              }),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: h / 100 * 2, bottom: h / 100 * 2),
                                  width: w * 0.9,
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: w * 0.7,
                                      height: h * 0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              w / 100 * 10),
                                          color: Themes.red),
                                      child: Text("Participate",
                                          textAlign: TextAlign.center,
                                          style: Themes.textStyle(
                                              fontsize: w / 100 * 6,
                                              fontColor: Themes.white,
                                              fw: FontWeight.bold))))
                            ]),
                      )
                    ]));
              } else {
                context.read<EventDetailsCubit>().loadEventDetails(eventId);
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
          ),
        ));
  }

  Widget like_Dislike_Rating_Widget(double w, double h, Event event,
      Color likeColor, Color dislikeColor, BuildContext context) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.star_outlined, color: Themes.red, size: w / 100 * 8),
          Container(
              margin: EdgeInsets.only(left: w / 100 * 2),
              child: Text(event.rating.toString(),
                  style: Themes.textStyle(
                      fontsize: w / 100 * 4, fontColor: Themes.black))),
          Container(
              margin: EdgeInsets.only(left: w / 100 * 6),
              child: InkWell(
                onTap: () {
                  context
                      .read<EventLikeDislikeCubit>()
                      .loadEventsLiked("665a2845e75985c1d041aae6");
                },
                child: Icon(Icons.thumb_up_alt,
                    color: likeColor, size: w / 100 * 6),
              )),
          Container(
              margin: EdgeInsets.only(left: w / 100 * 1),
              child: Text("Likes: ${event.likes}",
                  style: Themes.textStyle(
                      fontsize: w / 100 * 4, fontColor: Themes.black))),
          Container(
              margin: EdgeInsets.only(left: w / 100 * 6),
              child: InkWell(
                onTap: () {
                  context
                      .read<EventLikeDislikeCubit>()
                      .loadEventsDisliked("665a2845e75985c1d041aae6");
                },
                child: Icon(Icons.thumb_down_alt,
                    color: dislikeColor, size: w / 100 * 6),
              )),
          Container(
              margin: EdgeInsets.only(left: w / 100 * 1),
              child: Text("DisLikes: ${event.dislikes}",
                  style: Themes.textStyle(
                      fontsize: w / 100 * 4, fontColor: Themes.black)))
        ]);
  }
}
