import 'package:flutter/material.dart';

class Video {
  String videoId;
  String site;

  Video({@required this.videoId, @required this.site});

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      videoId: map['key'],
      site: map['site'],
    );
  }

  @override
  String toString() => 'Video(videoId: $videoId, site: $site)';
}
