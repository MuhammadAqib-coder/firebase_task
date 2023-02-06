import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:firebase_task/Models/user_model.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:firebase_task/Views/Widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

class UserDataView extends StatefulWidget {
  UserDataView({super.key});

  @override
  State<UserDataView> createState() => _UserDataViewState();
}

class _UserDataViewState extends State<UserDataView> {
  var nameCtrl = TextEditingController();
  var desgCtrl = TextEditingController();
  String image = '';
  final formKey = GlobalKey<FormState>();
  var btnState = ValueNotifier<bool>(false);
  var imageState = ValueNotifier<String>('');
  var videoState = ValueNotifier<String>('');
  var loadingState = ValueNotifier<bool>(false);
  UserModel? data;
  var file;
  ChewieController? _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      loadingState.value = !loadingState.value;
      data = ModalRoute.of(context)!.settings.arguments as UserModel;
      nameCtrl.text =
          data!.name; //widget.userModel != null ? widget.userModel!.name : '';
      desgCtrl.text = data!
          .designation; //widget.userModel != null ? widget.userModel!.designation : '';
      networkToFileImage();
    }
  }

  networkToFileImage() async {
    final response = await http.get(Uri.parse(data!.image));
    final documentDirectory = await getApplicationDocumentsDirectory();
    file = File(path.join(documentDirectory.path, 'image.png'));
    file.writeAsBytesSync(response.bodyBytes);
    imageState.value = file.path;
    loadingState.value = !loadingState.value;
  }

  loadVideoPlayer(videoFile) {
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.file(
        File(
          videoFile,
        ),
      ),
      allowPlaybackSpeedChanging: true,
      showOptions: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.green,
        handleColor: Colors.green,
      ),
      customControls: MaterialControls(
          // showPlayButton: true,
          ),
      // systemOverlaysAfterFullScreen: [SystemUiOverlay.bottom],
      // systemOverlaysOnEnterFullScreen: [SystemUiOverlay.bottom],
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft],
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },

      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(onTap: () {}, iconData: Icons.skip_next, title: 'next')
      //   ];
      // }
      // aspectRatio: 1
    );
    videoState.value = videoFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Data"),
          centerTitle: true,
        ),
        body: ValueListenableBuilder(
          valueListenable: loadingState,
          builder: (context, value, _) {
            if (value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 110,
                          width: 110,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: imageState,
                                builder: (context, value, child) {
                                  if (value == '') {
                                    return const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: FileImage(File(value)),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Positioned(
                                  bottom: 5,
                                  right: 8,
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.yellow),
                                    child: IconButton(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      icon: const Icon(
                                        Icons.photo_library_outlined,
                                        size: 15,
                                      ),
                                      onPressed: () async {
                                        await getImage(context).then((value) {
                                          if (value.isNotEmpty) {
                                            // image = value;
                                            // setState(() {});
                                            imageState.value = value;
                                          } else {
                                            showSnackbar(
                                                context, 'No image selected');
                                          }
                                        });
                                      },
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(controler: nameCtrl, hint: 'name'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            controler: desgCtrl, hint: 'designation'),
                        const SizedBox(
                          height: 20,
                        ),
                        ValueListenableBuilder(
                            valueListenable: videoState,
                            builder: (context, value, _) {
                              if (value.isNotEmpty) {
                                return Container(
                                    // padding: EdgeInsets.all(10),
                                    height: 200,
                                    color: Colors.black,
                                    child:
                                        Chewie(controller: _chewieController!));
                              } else {
                                return TextButton.icon(
                                    onPressed: () async {
                                      await getVideo(context).then((value) {
                                        loadVideoPlayer(value);
                                      });
                                    },
                                    icon:
                                        const Icon(Icons.upload_file_outlined),
                                    label: const Text('Upload Video'));
                              }
                            }),
                        ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate() &&
                                  imageState.value.isNotEmpty) {
                                btnState.value = !btnState.value;
                                var imageList = imageState.value.split(
                                    '/data/user/0/com.example.firebase_task/cache/');
                                // var videoList = videoState.value.split(
                                //     '/data/user/0/com.example.firebase_task/cache/');
                                await storage
                                    .ref('ProfileImage/${imageList[1]}')
                                    .putFile(File(imageState.value));
                                // await storage
                                //     .ref('ProfileImage/${videoList[1]}')
                                //     .putFile(File(videoState.value));
                                var url = await storage
                                    .ref('ProfileImage/${imageList[1]}')
                                    .getDownloadURL();
                                if (data != null) {
                                  var model = UserModel(
                                      image: url,
                                      name: nameCtrl.text.trim(),
                                      designation: desgCtrl.text.trim(),
                                      id: data!.id);
                                  await ref
                                      .child(data!.id)
                                      .update(model.toJson());
                                } else {
                                  var userRef = ref.push();
                                  var model = UserModel(
                                      image: url,
                                      name: nameCtrl.text.trim(),
                                      designation: desgCtrl.text.trim(),
                                      id: userRef.key!);
                                  await userRef.set(model.toJson());
                                  if (kDebugMode) {
                                    print(userRef.key);
                                  }
                                }
                                btnState.value = !btnState.value;
                                imageState.value = '';
                                videoState.value = '';
                                nameCtrl.clear();
                                desgCtrl.clear();
                              } else {
                                showSnackbar(context, 'enter image or field');
                              }
                            },
                            child: ValueListenableBuilder<bool>(
                                valueListenable: btnState,
                                builder: (context, value, child) {
                                  if (value) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    return const Text("Submit");
                                  }
                                })),

                        // _chewieController != null
                        //     ? Chewie(controller: _chewieController!)
                        //     : Container()
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
