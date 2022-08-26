import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import 'freelancerUploadPortfolio_screen.dart';

class FreelancerSelectPortfolioPicScreen extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const FreelancerSelectPortfolioPicScreen({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<FreelancerSelectPortfolioPicScreen> createState() =>
      _FreelancerSelectPortfolioPicScreenState();
}

class _FreelancerSelectPortfolioPicScreenState
    extends State<FreelancerSelectPortfolioPicScreen> {
  File? singleImage;

  final singlePicker = ImagePicker();
  final multiPicker = ImagePicker();
  List<XFile>? images = [];
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        email: widget.email,
        centerTitle: '',
        leading: true,
        active_id: widget.active_id,
        active_imgUrl: widget.active_imgUrl,
        active_name: widget.active_name,
        activeAcc: widget.activeAcc,
        freelancer_id: widget.freelancer_id,
        nav: false,
        notifi: false,
        no: null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: images!.isEmpty ? true : false,
                child: Column(
                  children: const [
                    Text(
                      'Project Editor',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: images!.isEmpty ? false : true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          images!.clear();
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                      iconSize: 20,
                    ),
                    const Text(
                      'Project Editor',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FreelancerUploadPortfolioScreen(
                              images: images!,
                              active_id: widget.active_id,
                              active_imgUrl: widget.active_imgUrl,
                              active_name: widget.active_name,
                              activeAcc: widget.activeAcc,
                              freelancer_id: widget.freelancer_id,
                              email: widget.email,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          color: HexColor("#60B781"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Scrollbar(
                    child: GridView.builder(
                      itemCount: images!.isEmpty ? 0 : images!.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5))),
                        child: images!.isEmpty
                            ? Icon(
                                CupertinoIcons.camera,
                                color: Colors.grey.withOpacity(0.5),
                              )
                            : Image.file(
                                File(images![index].path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                child: Column(
                  children: [
                    Text(
                      'Start a Project',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'Upload a File or Image',
                    ),
                  ],
                ),
                visible: images!.isEmpty ? true : false,
              ),
              Visibility(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: 'Password',
                    hintText: 'Add Text',
                  ),
                ),
                visible: active,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.camera_alt,
                  //     color: HexColor("#60B781"),
                  //   ),
                  //   iconSize: 40,
                  // ),
                  IconButton(
                    onPressed: () {
                      getMultiImages();
                    },
                    icon: Icon(
                      Icons.upload_file,
                      color: HexColor("#60B781"),
                    ),
                    iconSize: 40,
                  ),
                  IconButton(
                    onPressed: images!.isEmpty
                        ? null
                        : () {
                            setState(() {
                              if (active == false) {
                                active = true;
                              } else if (active == true) {
                                active = false;
                              }
                            });
                          },
                    icon: Icon(
                      Icons.text_fields,
                      color: HexColor("#60B781"),
                    ),
                    iconSize: 40,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWidgetFreelancer(
        active_id: widget.active_id,
        active_imgUrl: widget.active_imgUrl,
        active_name: widget.active_name,
        activeAcc: widget.activeAcc,
        freelancer_id: widget.freelancer_id,
        email: widget.email,
      ),
    );
  }

  Future getSingleImage() async {
    final pickedImage =
        // ignore: deprecated_member_use
        await singlePicker.getImage(source: (ImageSource.gallery));
    if (mounted) {
      setState(() {
        if (pickedImage != null) {
          singleImage = File(pickedImage.path);
        } else {}
      });
    }
  }

  Future getMultiImages() async {
    final List<XFile>? selectedImages = await multiPicker.pickMultiImage();
    if (this.mounted) {
      setState(() {
        if (selectedImages != null) {
          images!.addAll(selectedImages);
        } else {}
      });
    }
  }
}
