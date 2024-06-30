import 'dart:io';
import 'package:eventplex_frontend/Cubits/EditEventDetails.dart/EditEventDetailsCubit.dart';
import 'package:eventplex_frontend/Cubits/EditEventDetails.dart/EditEventDetailsState.dart';
import 'package:eventplex_frontend/Widgets/Drawer.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class EditEventDetails extends StatefulWidget {
  String id;
  EditEventDetails({super.key, required this.id});

  @override
  State<EditEventDetails> createState() => _EditEventDetailsState(id);
}

class _EditEventDetailsState extends State<EditEventDetails> {
  String id;
  _EditEventDetailsState(this.id);
  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController fees = TextEditingController();
  TextEditingController keywords = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();

  // TextEditingController keywords = TextEditingController();
  String s = "";
  File? img;
  void takephoto() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
    setState(() {
      print(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(1);
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
          height: h,
          margin: EdgeInsets.only(left: w * 0.025),
          child: SingleChildScrollView(
              child: BlocProvider(
            create: (context) => EditEventDetailsCubit(),
            child: BlocBuilder<EditEventDetailsCubit, EditEventDetailsState>(
                builder: (context, state) {
              if (state is EditEventDetailsLoadedState) {
                String keywordsLabel = "";
                state.event.keywords.forEach((e) => keywordsLabel += ("$e,"));
                return Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 2),
                      child: Stack(children: [
                        GFImageOverlay(
                            image: (img == null)
                                ?
                                // AssetImage("assets/images/e1.jpg")
                                NetworkImage(state.event.images[0])
                                // FileImage(img!) as ImageProvider,
                                : FileImage(img!) as ImageProvider,
                            width: w * 0.4,
                            height: h * 0.2,
                            boxFit: BoxFit.fill,
                            shape: BoxShape.circle),
                        Positioned(
                            bottom: h / 100 * 1,
                            right: w / 100 * 1,
                            child: Container(
                              width: w / 100 * 15,
                              height: h / 100 * 5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Themes.red, shape: BoxShape.circle),
                              child: InkWell(
                                onTap: () async {
                                  takephoto();
                                },
                                child: Icon(Icons.upload_rounded,
                                    size: w / 100 * 8, color: Themes.white),
                              ),
                            ))
                      ])),
                  // Container(
                  //     margin: EdgeInsets.only(top: h / 100 * 6),
                  //     child: CustomDropdown<String>.search(
                  //         decoration: CustomDropdownDecoration(
                  //             closedBorderRadius:
                  //                 BorderRadius.circular(w / 100 * 10),
                  //             expandedBorderRadius:
                  //                 BorderRadius.circular(w / 100 * 5),
                  //             expandedFillColor: Themes.lightred,
                  //             closedFillColor: Themes.transparent),
                  //         hintText: "Search Event To Update",
                  //         items: List.generate(state.event.currentEvents.length,
                  //             (index) => state.club.currentEvents[index].name),
                  //         onChanged: (p0) {
                  //           // print(p0);
                  //         })),
                  textFeild(w, h, state.event.name, name),
                  textFeild(w, h, state.event.location, location),
                  textFeild(w, h, state.event.date, date),
                  textFeild(w, h, state.event.time, time),
                  textFeild(w, h, state.event.fees.toString(), fees),
                  textFeild(w, h, state.event.category, category),
                  textFeild(w, h, keywordsLabel, keywords),
                  // textFeild(w, h, keywordsLabel, keywords),

                  InkWell(
                    splashColor: null,
                    hoverColor: null,
                    onTap: () {
                      
                      // s="hello";
                      // print(1);
                      context.read<EditEventDetailsCubit>().updateData({
                        '_id': id,
                        'dp': img,
                        'name': (name.text == "") ? null : name.text,
                        'location':
                            (location.text == "") ? null : location.text,
                        'date': (date.text == "") ? null : date.text,
                        'time': (time.text == "") ? null : time.text,
                        'fees': (fees.text == "") ? null : fees.text,
                        'category': (category.text == "") ? null : category.text,
                        'keywords': (keywords.text == "") ? null : keywords.text
                      }, state.event);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: h / 100 * 3),
                        width: w * 0.9,
                        height: h * 0.06,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Themes.red,
                            borderRadius: BorderRadius.circular(w / 100 * 10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit,
                                size: w / 100 * 6, color: Themes.white),
                            Text(
                              "Edit",
                              style: Themes.textStyle(
                                  fontsize: w / 100 * 5,
                                  fontColor: Themes.white,
                                  fw: FontWeight.bold),
                            )
                          ],
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom))
                ]);
              } else {
                context.read<EditEventDetailsCubit>().loadDetails(id);
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
          ))),
    );
  }

  Widget textFeild(double w, double h, String s, TextEditingController t) {
    return Container(
        margin: EdgeInsets.only(top: h / 100 * 6),
        child: TextFormField(
            controller: t,
            cursorColor: Themes.lightred,
            style: Themes.textStyle(
                fontsize: w / 100 * 5, fontColor: Themes.black),
            decoration: InputDecoration(
              label: Text(s,
                  style: Themes.textStyle(
                      fontsize: w / 100 * 5, fontColor: Themes.black)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w / 100 * 10),
                  borderSide: BorderSide(color: Themes.black, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(w / 100 * 10),
                  borderSide: BorderSide(color: Themes.lightred, width: 2)),
            )));
  }
}
