import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/components/radius_button.dart';
import 'package:matching_app/components/Header.dart';
import 'package:matching_app/utile/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matching_app/components/dialogs.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileImageState createState() => _ProfileImageState();
}

late double _minTextAdapt; // Declare the field with the 'late' keyword

ScreenUtil() {
  _minTextAdapt = // Initialize the field with the appropriate value
      calculateMinTextAdapt();
}

double calculateMinTextAdapt() {
  // Your calculation logic for _minTextAdapt
  return 0.0;
}

class _ProfileImageState extends State<ProfileImage> {
  final ImagePicker imgpicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              constraints: BoxConstraints(
                minHeight: vh(context, 90), // Set the minimum height here
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: vw(context, 1), right: vw(context, 1)),
                    child: const HeaderWidget(title: "プロフィール登録"),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: vh(context, 3),
                          left: vw(context, 3),
                          right: vw(context, 3)),
                      child: const Text("最後にプロフィール写真を１枚選んでください。",
                          style: TextStyle(
                              fontSize: 24,
                              color: PRIMARY_FONT_COLOR,
                              letterSpacing: -1.5))),
                  Padding(
                    padding: EdgeInsets.only(
                        top: vh(context, 1),
                        bottom: vh(context, 10),
                        left: vw(context, 3),
                        right: vw(context, 3)),
                    child: const Text(
                      "ハッキリとわかる写真を選ぶことで、マッチ率が向上します。\n本人確認の際に照合するため、正しい写真を選んでください。",
                      style: TextStyle(fontSize: 12, color: PRIMARY_FONT_COLOR),
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Stack(alignment: Alignment.center, children: [
                        const Image(
                            image: AssetImage(
                                "assets/images/profileimagebackground.png")),
                        const Image(
                            image:
                                AssetImage("assets/images/defaultimage.png")),
                        // ignore: unnecessary_null_comparison
                        appCubit.avatarImage != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(File(appCubit.avatarImage),
                                    fit: BoxFit.cover, width: 198, height: 198))
                            : Container(),
                        Padding(
                            padding: const EdgeInsets.only(top: 180, left: 180),
                            child: InkWell(
                                onTap: () async {
                                  try {
                                    var pickedFile = await imgpicker.pickImage(
                                        source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      final editedImage = await ImageCropper()
                                          .cropImage(
                                              sourcePath: pickedFile.path,
                                              aspectRatio: const CropAspectRatio(
                                                  ratioX: 1,
                                                  ratioY:
                                                      1), // Set the desired aspect ratio
                                              compressQuality:
                                                  80, // Adjust the compressed image quality as per your needs
                                              maxWidth:
                                                  800, // Adjust the maximum width of the cropped image
                                              maxHeight: 800);
                                      if (editedImage != null) {
                                        appCubit.changeAvatar(editedImage.path);
                                      }
                                    } else {
                                      showToastMessage("No image is selected.");
                                    }
                                  } catch (e) {
                                    print("error while picking file.");
                                  }
                                },
                                child: const Image(
                                    image: AssetImage(
                                        "assets/images/add_icon.png"))))
                      ])),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: vw(context, 3)),
                      child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RadiusButton(
                              id: 0,
                              color: BUTTON_MAIN,
                              text: "つぎへ",
                              goNavigation: (id) {
                                appCubit.uploadProfile().then((value) => {
                                      if (value == 1)
                                        {
                                          Navigator.pushNamed(
                                              context, "/identity_verify")
                                        }
                                    });
                                print(appCubit.avatarImage);
                              },
                              // ignore: unnecessary_null_comparison
                              isDisabled: appCubit.avatarImage == "",
                            ),
                          ))),
                  Expanded(
                    child: Container(),
                  )
                ],
              )));
    });
  }
}
