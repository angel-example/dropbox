import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/uploaded_file.dart';
export '../models/uploaded_file.dart';

configureServer(Db db) {
  return (Angel app) async {
    app.use('/api/uploaded_files', new UploadedFileService(db.collection('uploaded_files')));

    HookedService service = app.service('api/uploaded_files');
    app.container.singleton(service.inner);
  };
}

/// Manages [UploadedFile] in the database.
class UploadedFileService extends MongoTypedService<UploadedFile> {
  UploadedFileService(collection):super(collection) {
    // Your logic here!
  }
}