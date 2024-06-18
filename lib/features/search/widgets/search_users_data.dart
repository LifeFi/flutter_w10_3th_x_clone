import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';

class SearchUsersData extends ChangeNotifier {
  List<Map<String, dynamic>> data = [
    for (var i = 0; i < 50; i++)
      {
        "id": random.integer(1000000),
        "name": faker.person.name(),
        "bio": faker.job.title(),
        // "avatar": faker.image.image(
        //   keywords: ["avatar", "profile"],
        //   height: 80,
        //   width: 80,
        //   random: true,
        // ),
        "avatar": getImage(),
        "followers": random.integer(2000),
      }
  ];

  void follow(int id) {
    var index = data.indexWhere((element) => element["id"] == id);
    if (index == -1) return;
    data[index]["followers"] += 1;
    notifyListeners();
  }

  void unfollow(int id) {
    var index = data.indexWhere((element) => element["id"] == id);
    if (index == -1) return;
    data[index]["followers"] -= 1;
    notifyListeners();
  }
}

final searchUsersData = SearchUsersData();
