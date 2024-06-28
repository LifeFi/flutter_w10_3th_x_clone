import 'package:flutter_w10_3th_x_clone/features/threads/models/thread_model.dart';

class ThreadActionsModel {
  bool isLiked;
  List<ThreadModel>? comments;

  ThreadActionsModel({
    required this.isLiked,
    this.comments,
  });
}
