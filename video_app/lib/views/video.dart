import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/video.dart';
import '../controllers/auth.dart';
import 'comment.dart';

class Video extends StatelessWidget {
  final VideoController _videoController = Get.put(VideoController());

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
              ), // LinearGradient
              borderRadius: BorderRadius.circular(
                24,
              ), // BorderRadius.circular
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  24,
                ), // BorderRadius.circular
                child: Image.network(
                  profilePhoto,
                  fit: BoxFit.cover,
                ) // Image.network
                ), // ClipRRect
          ) // Container
        ],
      ), // Column
    ); // SizedBox
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return PageView.builder(
          itemCount: _videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = _videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(videoUrl: data.videoUrl),
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: () =>
                                            _videoController.likeVideo(data.id),
                                        child: Icon(
                                          Icons.favorite,
                                          color: data.likes.contains(
                                                  AuthController
                                                      .instance.user.uid)
                                              ? Colors.red
                                              : Colors.yellow,
                                          size: 40,
                                        )),
                                    Text(data.likes.length.toString(),
                                        style: TextStyle(color: Colors.amber))
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                        child: Icon(
                                      Icons.reply,
                                      color: Colors.yellow,
                                      size: 40,
                                    )),
                                    Text(data.shareCount.toString(),
                                        style: TextStyle(color: Colors.amber))
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Comment(id: data.id);
                                          })); // Material PageRoute
                                        },
                                        child: Icon(
                                          Icons.comment,
                                          color: Colors.yellow,
                                          size: 40,
                                        )),
                                    Text(data.commentCount.toString(),
                                        style: TextStyle(color: Colors.amber))
                                  ],
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                                Text(data.caption,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Row(children: [
                                  Icon(
                                    Icons.music_note,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  Text(data.songName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ])
                              ],
                            ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                alignment: Alignment.bottomRight,
                                width: 100.0,
                                height: 100.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Image.network(
                                    data.profilePhoto,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(data.username,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ]),
                      ],
                    )),
                  ],
                )
              ],
            );
          });
    })); // Scaffold
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: VideoPlayer(videoPlayerController),
    );
  }
}
