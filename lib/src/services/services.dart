/// Declare services here!
library angel.services;

import 'package:angel_framework/angel_framework.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'folder.dart' as Folder;
import 'uploaded_file.dart' as UploadedFile;
import 'user.dart' as User;

configureServer(Angel app) async {
  Db db = new Db(app.mongo_db);
  await db.open();

  await app.configure(User.configureServer(db));
  await app.configure(Folder.configureServer(db));
  await app.configure(UploadedFile.configureServer(db));
}
