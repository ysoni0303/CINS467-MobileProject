import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../controllers/auth.dart';
import '../controllers/profile.dart';

class Profile extends StatefulWidget {
  final String uid;
  final bool isSearch;
  const Profile({
    Key? key,
    required this.isSearch,
    required this.uid,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();

    print('initState');
    print(widget.uid);
    if (widget.isSearch) {
      profileController.updateUserId(widget.uid);
    } else {
      profileController.updateUserId(AuthController.instance.user.uid);
    }
  }

  void _share(uri) async {
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/image.jpeg';
    File('${directory.path}/image.jpeg').writeAsBytesSync(bytes);
    await Share.shareFiles([path]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,
              title: Text(
                'Username- ${controller.user['name']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AvatarGlow(
                                endRadius: 70.0,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: controller.user['profilePhoto'],
                                    height: 60,
                                    width: 60,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Text(
                                    controller.user['following'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Following',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black54,
                                width: 1,
                                height: 15,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    controller.user['followers'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.black54,
                                width: 1,
                                height: 15,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    controller.user['likes'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Likes',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: 140,
                            height: 47,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () async {
                                  if (widget.isSearch != true &&
                                      widget.uid ==
                                          AuthController.instance.user.uid) {
                                    AuthController.instance.signOut();
                                  } else if (widget.isSearch == false) {
                                    AuthController.instance.signOut();
                                  } else {
                                    controller.followUser();
                                  }
                                },
                                child: Text(
                                  widget.uid == AuthController.instance.user.uid
                                      ? 'Logout'
                                      : controller.user['isFollowing']
                                          ? 'Unfollow'
                                          : 'Follow',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: 140,
                            height: 47,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  _share(Uri.parse(controller
                                      .user['profilePhoto']
                                      .toString()));
                                },
                                child: Text(
                                  'Share Profile',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Your Video List!!',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          controller.user['thumbnails'].length != 0
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.user['thumbnails'].length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 4,
                                  ),
                                  itemBuilder: (context, index) {
                                    String thumbnail =
                                        controller.user['thumbnails'][index];
                                    return CachedNetworkImage(
                                      imageUrl: thumbnail,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Text(
                                  'Nothing to display! Please start uploading.. ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
