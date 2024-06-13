import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';

class FeedsData extends ChangeNotifier {
  List<Map<String, dynamic>> data = [
    for (var i = 0; i < 20; i++)
      {
        "id": random.integer(1000000),
        "user": {
          "id": random.integer(1000000),
          "name": faker.person.name(),
          // "avatar": faker.image.image(
          //   keywords: ["avatar", "profile"],
          //   height: 80,
          //   width: 80,
          //   random: true,
          // ),
          "avatar": getImage(),

          "isMe": false,
        },
        "content": faker.lorem.sentence(),
        "images": [
          for (var i = 0; i < random.integer(5); i++)
            // faker.image.image(
            //   random: true,
            // ),
            getImage(),
        ],
        "createdAt": DateTime.now().subtract(
          Duration(
            minutes: random.integer(60 * 24 * 7),
          ),
        ),
        "comments": [
          for (var i = 0; i < random.integer(10); i++)
            {
              "id": random.integer(1000000),
              "name": faker.person.name(),
              // "avatar": faker.image.image(
              //   keywords: ["avatar", "profile"],
              //   height: 80,
              //   width: 80,
              //   random: true,
              // ),
              "avatar": getImage(),
            }
        ],
        "likes": random.integer(1000),
      }
  ];

  void post({
    required int id,
    required String name,
    required String avatar,
    required String content,
  }) {
    data.add({
      "user": {
        "id": id,
        "name": name,
        "avatar": avatar,
        "isMe": true,
      },
      "content": content,
      "images": [],
      "createdAt": DateTime.now(),
      "comments": [],
      "likes": 0,
    });
    notifyListeners();
  }

  List<Map<String, dynamic>> orderedData() {
    List<Map<String, dynamic>> result = List.from(data);
    result.sort((a, b) => b["createdAt"].compareTo(a["createdAt"]));
    return result;
  }
}

final feedsData = FeedsData();
