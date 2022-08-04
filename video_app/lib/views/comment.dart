import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/video.dart';

class Comment extends StatelessWidget {
  final String id;
  final TextEditingController _commentController = TextEditingController();
  final CommentController commentController = Get.put(CommentController());

  Comment({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    commentController.updatePostId(id);

    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(child: Obx(() {
              return ListView.builder(
                  itemCount: commentController.commentList.length,
                  itemBuilder: (context, index) {
                    final comments = commentController.commentList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: NetworkImage(comments.profilePhoto),
                      ),
                      title: Row(
                        children: [
                          Text(
                            comments.username.toString(),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            comments.comment.toString(),
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            timeago.format(
                              comments.datepublished.toDate(),
                            ),
                            style: TextStyle(fontSize: 15, color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  });
            })),
            Divider(),
            ListTile(
              title: TextFormField(
                controller: _commentController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              trailing: TextButton(
                onPressed: () {
                  commentController.postComment(_commentController.text);
                  _commentController.clear();
                },
                child: const Text(
                  'Publish',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
