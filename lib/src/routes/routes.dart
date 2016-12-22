/// This app's route configuration.
library angel.routes;

import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'package:random_string/random_string.dart' as rs;
import '../models/user.dart';
import '../services/uploaded_file.dart';
import 'controllers/controllers.dart' as Controllers;

configureBefore(Angel app) async {
  app.before.add(cors());
}

/// Put your app routes here!
configureRoutes(Angel app) async {
  app.get('/', (req, res) {
    if (req.user == null) {
      return res.redirect('/login');
    } else
      return res.render('index');
  });

  app.get('/login', (req, res) => res.render('login'));

  app.group('/api', (router) {
    router.chain('auth').post('/upload', (RequestContext req,
        Configuration config,
        User user,
        UploadedFileService uploadService) async {
      if (req.files.length != 1)
        throw new AngelHttpException.BadRequest(
            message: 'Please upload exactly one file.');
      else if (!req.body.containsKey('folderId')) {
        throw new AngelHttpException.BadRequest(
            message: 'Folder ID is required.');
      }

      final dir = new Directory(config.upload_path);
      final name = rs.randomAlphaNumeric(rs.randomBetween(12, 25));
      final file = new File.fromUri(dir.uri.resolve(name));
      await file.writeAsBytes(req.files.first.data);

      return await uploadService.create(new UploadedFile(
          userId: user.id,
          folderId: req.body['folderId'],
          path: name,
          size: req.files.first.data.length));
    });
  });
}

configureAfter(Angel app) async {
  // Static server, and pub serve while in development
  await app.configure(new PubServeLayer());
  await app.configure(new VirtualDirectory());

  // Set our application up to handle different errors.
  var errors = new ErrorHandler(handlers: {
    404: (req, res) async =>
        res.render('error', {'message': 'No file exists at ${req.path}.'}),
    500: (req, res) async => res.render('error', {'message': req.error.message})
  });

  errors.fatalErrorHandler = (AngelFatalError e) async {
    e.request.response
      ..statusCode = 500
      ..writeln('500 Internal Server Error: ${e.error}')
      ..writeln(e.stack);
    await e.request.response.close();
  };

  // Throw a 404 if no route matched the request
  app.after.add(errors.throwError());

  // Handle errors when they occur, based on outgoing status code.
  // By default, requests will go through the 500 handler, unless
  // they have an outgoing 200, or their status code has a handler
  // registered.
  app.after.add(errors.middleware());

  // Pass AngelHttpExceptions through handler as well
  await app.configure(errors);

  // Compress via GZIP
  app.responseFinalizers.add(gzip());
}

configureServer(Angel app) async {
  await configureBefore(app);
  await configureRoutes(app);
  await app.configure(Controllers.configureServer);
  await configureAfter(app);
}
