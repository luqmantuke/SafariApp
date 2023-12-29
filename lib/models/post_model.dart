import 'dart:convert';

class PostModel {
  String title;
  String description;
  String image;
  String video;
  String type;
  PostModel({
    required this.title,
    required this.description,
    required this.image,
    required this.video,
    required this.type,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'video': video,
      'type': type,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      video: map['video'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source));
}
