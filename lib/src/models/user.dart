library angel.models.user;

import 'dart:convert';
import 'package:angel_mongo/model.dart';

class User extends Model {
  String googleId;

  User({String id, this.googleId}) {
    this.id = id;
  }

  factory User.fromJson(String json) => new User.fromMap(JSON.decode(json));

  factory User.fromMap(Map data) =>
      new User(id: data['id'], googleId: data['googleId']);

  Map toJson() {
    return {'id': id, 'googleId': googleId};
  }
}
