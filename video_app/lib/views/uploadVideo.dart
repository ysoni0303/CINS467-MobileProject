import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../controllers/video.dart';

class AddVideo extends StatelessWidget {
  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return UploadForm(
          file: File(video.path),
          path: video.path,
        );
      }));
    }
  }

  showDialogOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
            child: SimpleDialog(
              title: Text('Choose Option:'),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    pickVideo(ImageSource.gallery, context);
                  },
                  child: const Text('Gallery'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    pickVideo(ImageSource.camera, context);
                  },
                  child: const Text('Camera'),
                ),
              ],
              elevation: 10,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.upload),
            iconSize: 40,
            color: Colors.red,
            onPressed: () => showDialogOption(context)),
        Text('Upload Video')
      ],
    )));
  }
}

class UploadForm extends StatefulWidget {
  final File file;
  final String path;

  const UploadForm({Key? key, required this.file, required this.path})
      : super(key: key);

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  late VideoPlayerController controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.file);
    });

    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final UploadVideoController _uploadVideoController =
      Get.put(UploadVideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            child: VideoPlayer(controller),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _songController,
            decoration: new InputDecoration(labelText: 'Song..'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: new InputDecoration(labelText: 'Description..'),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                _uploadVideoController.uploadVideo(_songController.text,
                    _descriptionController.text, widget.path);
              },
              child: Text('Publish'))
        ],
      ),
    ));
  }
}
