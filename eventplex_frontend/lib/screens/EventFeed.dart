import 'package:eventplex_frontend/Cubits/EventFeed/EventFeedCubit.dart';
import 'package:eventplex_frontend/Cubits/EventFeed/EventFeedState.dart';
import 'package:eventplex_frontend/Model/Event.dart';
import 'package:eventplex_frontend/Widgets/Drawer.dart';
import 'package:eventplex_frontend/screens/EventDetails.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:getwidget/getwidget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EventFeed extends StatefulWidget {
  const EventFeed({super.key});

  @override
  State<EventFeed> createState() => _EventFeedState();
}

class _EventFeedState extends State<EventFeed>
    with SingleTickerProviderStateMixin {
  // bool isScrolled = false;
  TextEditingController t = TextEditingController();
  late AnimationController ac;
  late Animation typingAnimation;
  late BuildContext eventFeedContext;
  @override
  void initState() {
    ac = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    ac.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: 2));
        ac.repeat();
      }
    });
    typingAnimation = Tween<double>(begin: 1, end: 42)
        .animate(CurvedAnimation(parent: ac, curve: Curves.linear));
    ac.forward();
    super.initState();
  }

  bool isScrolled = false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    ScrollController scrollController = ScrollController();
    return Scaffold(
        drawer: Widgets().AppDrawer(w, h, context),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            BlocProvider(
              create: (context) => EventFeedCubit(),
              child: BlocBuilder<EventFeedCubit, EventFeedState>(
                builder: (context, state) {
                  if (state is EventFeedStateLoaded) {
                    scrollController.addListener(() {
                      // print(1);
                      if (scrollController.position.pixels > (h * 0.15)) {
                        isScrolled = true;
                        context
                            .read<EventFeedCubit>()
                            .changeAppBar(state.eventList, true);
                      } else if (scrollController.position.pixels <
                          (h * 0.15)) {
                        isScrolled = false;
                        context
                            .read<EventFeedCubit>()
                            .changeAppBar(state.eventList, false);
                      }
                    });
                    // print(state.isScrolled);
                    return AnimatedBuilder(
                        animation: typingAnimation,
                        builder: (context, child) {
                          return appBar(
                              w,
                              h,
                              (state.isScrolled)
                                  ? "Samarth"
                                  : ("Events that Inspire, Connections that Last"
                                      .substring(
                                          0, typingAnimation.value.toInt())),
                              state.isScrolled,
                              context);
                        });
                    // } else if (state is EventFeedScrolledState) {
                    //   scrollController.addListener(() {
                    //     if (scrollController.position.pixels < (h * 0.15)) {
                    //       context
                    //           .read<EventFeedCubit>()
                    //           .makeAppbarTextInVisible();
                    //     }
                    //   });
                    //   return AppBar(w, h, "Samarth", state.isScrolled, context);
                  } else {
                    return SliverAppBar();
                  }
                },
              ),
            ),
            // SliverAppBar(
            //   surfaceTintColor: Themes.grey,
            //   backgroundColor: Themes.lightred,
            //   pinned: true,
            //   snap: false,
            //   floating: false,
            //   title: Text("Welcome Samarth to EventPlex",
            //       style: Themes.textStyle(
            //           fontsize: (w / 100) * 4,
            //           fontColor:
            //               (isScrolled) ? Themes.black : Themes.transparent,
            //           fw: FontWeight.bold)),
            //   expandedHeight: h * 0.3,
            //   flexibleSpace: FlexibleSpaceBar(
            //       background: Image.asset(
            //     "assets/images/eventplex_logo.png",
            //     width: w,
            //     height: h * 0.3,
            //     fit: BoxFit.fill,
            //   )),
            // ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                height: (h / 100) * 7,
                margin: EdgeInsets.only(
                    top: (h / 100) * 3,
                    left: (w / 100) * 5,
                    right: (w / 100) * 5),
                width: w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          // alignment: Alignment.centerLeft,
                          // padding: EdgeInsets.symmetric(horizontal: (w / 100) * 5),
                          // margin: EdgeInsets.only(left: (w / 100) * 5),
                          child: TextFormField(
                        controller: t,
                        style: Themes.textStyle(
                            fontsize: w / 100 * 5, fontColor: Themes.black),
                        cursorColor: Themes.black,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search,
                                color: Themes.black, size: (w / 100) * 7),
                            fillColor: Colors.transparent,
                            hintText: "Search Events...",
                            hintStyle: Themes.textStyle(
                                fontsize: (w / 100) * 4,
                                fontColor: Themes.black,
                                fw: null),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(color: Themes.black)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(w / 100 * 8),
                                borderSide: BorderSide(
                                    color: Themes.black, width: 20))),
                      )),
                    ),
                    InkWell(
                      hoverColor: Themes.transparent,
                      splashColor: Themes.lightred,
                      onTap: () {
                        String query =
                            '''query eventsAccToKeywords(\$keywords: [String]){
                            allEventsAccToKeywords(keywords: \$keywords){ 
                              _id
                              images
                              name
                              Club{
                                _id
                                name
                                }
                              category
                              rating
                              }
                            }
                          ''';
                        Map<String, dynamic> variables = {
                          "keywords": [t.text]
                        };
                        eventFeedContext
                            .read<EventFeedCubit>()
                            .loadFilteredState(query, "allEventsAccToKeywords",
                                variables, isScrolled, -1);
                      },
                      child: Container(
                        // margin: EdgeInsets.only(
                        // left: w / 100 * 2, right: w / 100 * 2),
                        width: w / 100 * 18,
                        height: h / 100 * 6.5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Themes.red),
                        child: Icon(Icons.tune_sharp,
                            size: w / 100 * 8, color: Themes.white),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: (h / 100) * 4,
                      left: (w / 100) * 5,
                      right: (w / 100) * 5),
                  child: Text("Featured Event",
                      style: Themes.textStyle(
                          fontsize: (w / 100) * 4,
                          fontColor: Themes.black,
                          fw: FontWeight.bold))),
              BlocProvider(
                  create: (context) => EventFeedCubit(),
                  child: BlocBuilder<EventFeedCubit, EventFeedState>(
                      builder: (context, state) {
                    // state.loadEventList();
                    if (state is EventFeedStateLoaded) {
                      return Container(
                        width: w * 0.9,
                        alignment: Alignment.center,
                        child: EventCard(
                            w,
                            h,
                            state.featuredEvent.images,
                            state.featuredEvent.name,
                            state.featuredEvent.club,
                            state.featuredEvent.category,
                            state.featuredEvent.rating,
                            state.featuredEvent.id),
                      );
                    } else {
                      return Container();
                    }
                  })),
              // Column(children: Lis)

              BlocProvider(
                  create: (context) => EventFeedCubit(),
                  child: BlocBuilder<EventFeedCubit, EventFeedState>(
                    builder: (context, state) {
                      eventFeedContext = context;
                      // state.loadEventList();
                      if (state is EventFeedStateLoaded) {
                        return Column(children: [
                          ...categories(w, h, state.categories,
                              state.currentIndex, context),
                          ...eventFeed(w, h, state.eventList),
                        ]);
                      } else if (state is EventFeedFilteredStateLoaded) {
                        return Column(children: [
                          ...categories(w, h, state.categories,
                              state.currentIndex, context),
                          ...eventFeed(w, h, state.filteredEventList)
                        ]);
                      } else {
                        return Center(
                          child: Container(
                            width: w,
                            height: h,
                            child: LoadingAnimationWidget.fourRotatingDots(
                                color: Themes.red, size: w / 100 * 20),
                          ),
                        );
                      }
                    },
                  )),
              // hackathon, workshop, seminar, dj night, webinar, cultural,sports, charity, wellness, food & drink
              // Container(
              //   width: w,
              //   height: h * 1.1,
              // )
            ]))
          ],
        ));
  }

  Widget appBar(
      double w, double h, String s, bool isScrolled, BuildContext context) {
    // print(isScrolled);
    return SliverAppBar(
      actions: (isScrolled)
          ? [
              InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: (w / 100) * 5),
                    child: Image.network(
                        "https://img.icons8.com/fluency-systems-regular/96/squared-menu.png",
                        width: (w / 100) * 8,
                        height: (h / 100) * 5),
                  ))
            ]
          : [],
      surfaceTintColor: Themes.grey,
      backgroundColor: Themes.lightred,
      pinned: true,
      snap: false,
      floating: false,
      // primary: false,
      leadingWidth: (w / 100) * 15,
      leading: (isScrolled)
          ? Container(
              margin: EdgeInsets.only(left: (w / 100) * 5),
              child: const GFAvatar(
                // foregroundColor: ,
                backgroundImage: NetworkImage("assets/images/photo.jpg"),
                // size: GFSize.LARGE,
              ),
            )
          : null,
      title: Text("Welcome $s!!",
          style: Themes.textStyle(
              fontsize: (w / 100) * 4,
              fontColor: (isScrolled) ? Themes.black : Themes.transparent,
              fw: FontWeight.bold)),
      expandedHeight: h * 0.25,
      flexibleSpace: FlexibleSpaceBar(
          background: Container(
        width: w,
        height: h * 0.25,
        // alignment: Alignment.center,
        color: Themes.lightred,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/eventplex_logo.png",
              width: w * 0.75,
              // height: h * 0.2,
              fit: BoxFit.fill,
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: typingAnimation,
                  builder: (context, child) { 
                    return Text(
                      s,
                      style: Themes.textStyle(
                          fontsize: (w / 100) * 3.5,
                          fontColor: Themes.red,
                          fw: FontWeight.bold),
                    );
                  },
                ),
                Opacity(
                    opacity: (s.length % 2 == 0) ? 0 : 1,
                    child: Container(
                        color: Themes.red,
                        width: (w / 100) * 0.5,
                        height: (h / 100) * 3))
              ],
            ),
          ],
        ),
      )),
    );
  }

  List<Widget> eventFeed(double w, double h, List<Event> eventList) {
    return [
      Container(
          width: w * 0.9,
          margin: EdgeInsets.only(top: (h / 100) * 5),
          child: Text("Events",
              style: Themes.textStyle(
                  fontsize: (w / 100) * 4,
                  fontColor: Themes.black,
                  fw: FontWeight.bold))),
      ...List.generate(
          eventList.length,
          (index) => EventCard(
              w,
              h,
              // state.eventList[index].images[0]??
              ["", ""],
              eventList[index].name,
              eventList[index].club,
              eventList[index].category,
              eventList[index].rating,
              eventList[index].id))
    ];
  }

  List<Widget> categories(double w, double h, var categories, int currentIndex,
      BuildContext context) {
    return [
      Container(
          width: w * 0.9,
          margin: EdgeInsets.only(top: (h / 100) * 4),
          child: Text("Categories",
              style: Themes.textStyle(
                  fontsize: (w / 100) * 4,
                  fontColor: Themes.black,
                  fw: FontWeight.bold))),
      Container(
          margin: EdgeInsets.only(top: h / 100 * 3),
          width: w * 0.9,
          height: h * 0.1,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Themes.transparent,
                  hoverColor: Themes.transparent,
                  onTap: () {
                    String query =
                        '''query eventsAccToCategory(\$category: [String]){
                          allEventsAccToCategory(category: \$category) {
                           _id
                           images
                           name
                           Club{
                            _id
                            name
                            }
                            category
                            rating
                          }}''';
                    Map<String, dynamic> variables = {
                      "category": [categories[index].name.toString()]
                    };
                    // print(variables);
                    if (currentIndex == index) {
                      query = '''
                        query eventCardDetails{
                          allEvents {
                            _id
                            images
                            name
                            Club{
                              _id
                              name
                              }
                              category
                              rating
                              }
                              }
                      ''';
                      context
                          .read<EventFeedCubit>()
                          .loadEventList(query, variables, isScrolled);
                    } else {
                      context.read<EventFeedCubit>().loadFilteredState(
                          query,
                          "allEventsAccToCategory",
                          variables,
                          isScrolled,
                          index);
                    }
                  },
                  child: AnimatedContainer(
                      duration: const Duration(microseconds: 300),
                      curve: Curves.bounceOut,
                      width: w * 0.22,
                      height: h * 0.1,
                      margin: EdgeInsets.only(
                          left: (index == 0) ? 0 : (w / 100) * 5),
                      decoration: BoxDecoration(
                          color: (currentIndex == index)
                              ? Themes.lightred
                              : Themes.grey,
                          borderRadius: BorderRadius.circular(w / 100 * 6)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.network(categories[index].image,
                                width: w * 0.18,
                                height: h * 0.05,
                                fit: BoxFit.fill),
                            Text(categories[index].name,
                                style: Themes.textStyle(
                                    fontsize: w / 100 * 3,
                                    fontColor: Themes.black))
                          ])),
                );
              }))
    ];
  }

  Widget EventCard(double w, double h, List<String> images, String eventName,
      String clubName, String category, String rating, String id) {
    // int idx = 0;
    return InkWell(
      // focusColor: Themes.transparent,
      hoverColor: Themes.transparent,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventDetails(id: id)));
      },
      child: Container(
        width: w * 0.9,
        margin: EdgeInsets.only(top: (h / 100) * 3),
        height: h * 0.35,
        decoration: BoxDecoration(
            color: Themes.grey,
            borderRadius: BorderRadius.circular(w / 100 * 4)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: h / 100 * 2),
                child: Hero(
                    flightShuttleBuilder: (flightContext, animation,
                        flightDirection, fromHeroContext, toHeroContext) {
                      Widget hero = fromHeroContext.widget;
                      return ScaleTransition(
                          scale: animation.drive(Tween<double>(begin: 2, end: 1)
                              .chain(CurveTween(curve: Curves.bounceOut))),
                          child: hero);
                    },
                    tag: id,
                    child: ImageSlideshow(
                        width: w * 0.8,
                        height: h * 0.2,
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
                            images.length,
                            (index) => GFImageOverlay(
                                image: NetworkImage(images[index]),
                                width: w * 0.8,
                                height: h * 0.2,
                                borderRadius:
                                    BorderRadius.circular(w / 100) * 6),
                          )
                        ])),
              )
              // GFImageOverlay(
              //     image: AssetImage(image),
              //     width: w * 0.8,
              //     height: h * 0.2,
              //     borderRadius: BorderRadius.circular(w / 100) * 6),
              ,
              Container(
                  width: w * 0.8,
                  margin: EdgeInsets.only(bottom: h / 100 * 2),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                eventName,
                                style: Themes.textStyle(
                                    fontsize: w / 100 * 4,
                                    fontColor: Themes.red),
                              ),
                              Text(
                                clubName,
                                style: Themes.textStyle(
                                    fontsize: w / 100 * 4,
                                    fontColor: Themes.black,
                                    fw: FontWeight.w400),
                              ),
                              Text(
                                category,
                                style: Themes.textStyle(
                                    fontsize: w / 100 * 4,
                                    fontColor: Themes.black,
                                    fw: FontWeight.bold),
                              )
                            ]),
                        Container(
                          width: w / 100 * 15,
                          height: h / 100 * 4,
                          decoration: BoxDecoration(
                              color: Themes.red,
                              borderRadius: BorderRadius.circular(w / 100 * 6)),
                          child: Text(rating,
                              textAlign: TextAlign.center,
                              style: Themes.textStyle(
                                  fontsize: w / 100 * 4.2,
                                  fontColor: Themes.white,
                                  fw: FontWeight.w700)),
                        )
                      ]))
            ]),
      ),
    );
  }

 

// ImageSlideshow(
//                     width: double.infinity,
//                     height: h * 0.7,
//                     initialPage: 0,
//                     indicatorColor: globals.brownish,
//                     indicatorBackgroundColor: globals.greyish,
//                     onPageChanged: (value) {
//                       // print('Page changed: $value');
//                       idx = value;
//                     },
//                     autoPlayInterval: 5000,
//                     isLoop: true,
//                     children: imageWidgets,
//                   )
    }