import 'dart:io';

import 'package:eventplex_frontend/Cubits/CreateEvent/CreateEventCubit.dart';
import 'package:eventplex_frontend/Cubits/CreateEvent/CreateEventState.dart';
import 'package:eventplex_frontend/Widgets/Drawer.dart';
import 'package:eventplex_frontend/screens/ClubProfile.dart';
import 'package:eventplex_frontend/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class CreateEvent extends StatefulWidget {
  String id;
  CreateEvent({super.key, required this.id});

  @override
  State<CreateEvent> createState() => _CreateEventState(id);
}

class _CreateEventState extends State<CreateEvent> {
  String id;
  _CreateEventState(this.id);
  List<File> img = [];
  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController fees = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController keywords = TextEditingController();
  TextEditingController description = TextEditingController();
  // TextEditingController name = TextEditingController();

  void takephoto() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    images.forEach((element) {
      img.add(File(element.path));
    });
    setState(() {
      print(img.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/eventplex_logo.png",
            width: w * 0.3, height: h * 0.05, fit: BoxFit.fill),
        centerTitle: true,
        backgroundColor: Themes.lightred,
        surfaceTintColor: Themes.lightred,
      ),
      drawer: const Widgets(),
      body: Container(
          width: w * 0.95,
          height: h,
          margin: EdgeInsets.only(left: w * 0.025),
          child: SingleChildScrollView(
              child: BlocProvider(
            create: (context) => CreateEventCubit(),
            child: BlocBuilder<CreateEventCubit, CreateEventState>(
                builder: (context, state) {
              if (state is CreateEventStateSubmitted) {
                // print(1);
                // print(img==null);
                // String keywordsLabel = "";
                // state.club.keywords.forEach((e) => keywordsLabel += ("$e,"));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClubProfile()));
                return Container();
              } else if (state is CreateEventStateLoading) {
                return Container(
                  width: w,
                  height: h,
                  alignment: Alignment.center,
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Themes.red, size: w / 100 * 20),
                );
              } else {
                return Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: h / 100 * 2),
                      child: Stack(children: [
                        (img.length == 0)
                            ? Icon(Icons.photo_size_select_actual_rounded,
                                size: w * 0.4, color: Themes.lightred)
                            : ImageSlideshow(
                                width: w * 0.4,
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
                                      img.length,
                                      (index) => GFImageOverlay(
                                          image: FileImage(img[index])
                                              as ImageProvider,
                                          width: w * 0.4,
                                          height: h * 0.2,
                                          boxFit: BoxFit.fill,
                                          shape: BoxShape.circle),
                                    )
                                  ]),
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
                  textFeild(w, h, "name", name),
                  textFeild(w, h, "location", location),
                  textFeild(w, h, "date", date),
                  textFeild(w, h, "time", time),
                  textFeild(w, h, "fees", fees),
                  textFeild(w, h, "category", category),
                  textFeild(w, h, "keywords", keywords),
                  textFeild(w, h, "description", description),
                  // textFeild(w, h, keywordsLabel, keywords),

                  InkWell(
                    onTap: () {
                      // s="hello";
                      // print(1);
                      context.read<CreateEventCubit>().submit({
                        'images': img,
                        'name': name.text,
                        'location': location.text,
                        'date': date.text,
                        'time': time.text,
                        'fees': fees.text,
                        'category': category.text,
                        'keywords': keywords.text,
                        'description': description.text,
                        'club': id
                        // 'keywords': (keywords.text == "") ? null : keywords.text
                      });
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
