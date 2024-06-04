import 'package:eventplex_frontend/Cubits/ClubDetails/ClubDetailsCubit.dart';
import 'package:eventplex_frontend/Cubits/ClubDetails/ClubDetailsState.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';

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
                                  AssetImage("assets/images/e1.jpg"),
                              // : state.event.images[0]),
                              margin: EdgeInsets.only(top: h / 100 * 2),
                              height: h * 0.3,
                              width: w * 0.95,
                              boxFit: BoxFit.fill,
                              borderRadius: BorderRadius.circular(w / 100 * 5)),
                          Container(
                            width: w*0.95,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: h / 100 * 2),
                            child: Text(state.club.name,
                                style: Themes.textStyle(
                                    fontsize: w / 100 * 6,
                                    fontColor: Themes.black,
                                    fw: FontWeight.bold)),
                          ),
                        ]));
                  } else {
                    context.read<ClubDetailsCubit>().loadClubDetails(id);
                    return Container();
                  }
                }))));
  }
}
