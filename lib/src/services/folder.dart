import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/folder.dart';
export '../models/folder.dart';

configureServer(Db db) {
  return (Angel app) async {
    app.use('/api/folders', new FolderService(db.collection('folders')));

    HookedService service = app.service('api/folders');
    app.container.singleton(service.inner);
  };
}

/// Manages [Folder] in the database.
class FolderService extends MongoTypedService<Folder> {
  FolderService(collection):super(collection) {
    // Your logic here!
  }
}