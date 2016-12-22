library angel.models.folder;

import 'dart:convert';
import 'package:angel_mongo/model.dart';

class Folder extends Model {
  String userId, name;

  Folder({String id, this.name, this.userId}) {
    this.id = id;
  }

  factory Folder.fromJson(String json) => new Folder.fromMap(JSON.decode(json));

  factory Folder.fromMap(Map data) => new Folder(
      id: data['id'],
      name: data['name'],
      userId: data['desc']);

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'desc': userId
    };
  }
}