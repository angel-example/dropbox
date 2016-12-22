library angel.models.uploaded_file;

import 'dart:convert';
import 'package:angel_mongo/model.dart';

class UploadedFile extends Model {
  String userId, folderId, path;
  int size;

  UploadedFile({String id, this.userId, this.folderId, this.path, this.size}) {
    this.id = id;
  }

  factory UploadedFile.fromJson(String json) =>
      new UploadedFile.fromMap(JSON.decode(json));

  factory UploadedFile.fromMap(Map data) => new UploadedFile(
      id: data['id'],
      userId: data['userId'],
      folderId: data['folderId'],
      path: data['path'],
      size: data['size']);

  Map toJson() {
    return {
      'id': id,
      'userId': userId,
      'folderId': folderId,
      'path': path,
      'size': size
    };
  }
}
