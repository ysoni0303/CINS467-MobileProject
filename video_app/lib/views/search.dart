import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'profile.dart';
import '../controllers/profile.dart';

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  final Searching _search = Get.put(Searching());
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            controller: search,
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Enter Username',
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onFieldSubmitted: (value) => _search.searchUser(value),
          ),
        ),
        body: _search.searchedUsers.isEmpty
            ? const Center(
                child: Text(
                  'Enter Username!!',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            : Obx(() {
                return ListView.builder(
                  itemCount: _search.searchedUsers.length,
                  itemBuilder: (context, index) {
                    final searchData = _search.searchedUsers[index];
                    print("searchData");
                    print(searchData.profilePhoto);
                    return ListTile(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              Profile(isSearch: true, uid: searchData.uid),
                        ),
                      ),
                      leading: AvatarGlow(
                          endRadius: 30.0,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              searchData.profilePhoto,
                            ),
                          )),
                      title: Text(
                        searchData.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                );
              }),
      );
    });
  }
}
