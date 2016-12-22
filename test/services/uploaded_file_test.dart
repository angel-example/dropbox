import 'dart:io';
import 'package:angel/angel.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_test/angel_test.dart';
import 'package:test/test.dart';

main() async {
  Angel app;
  TestClient client;

  setUp(() async {
    app = await createServer();
    client = await connectTo(app, saveSession: false);
  });

  tearDown(() async {
    await client.close();
    app = null;
  });

  test('index via REST', () async {
    var response = await client.get('/api/uploaded_files');
    expect(response, hasStatus(HttpStatus.OK));
  });

  test('Index uploaded_files', () async {
    var uploaded_files = await client.service('api/uploaded_files').index();
    print(uploaded_files);
  });
}