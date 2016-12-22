library angel.routes.controllers.auth;

import 'package:angel_auth_google/angel_auth_google.dart';
import 'package:angel_common/angel_common.dart';
import 'package:googleapis/plus/v1.dart';

const scopes = const [
  PlusApi.PlusMeScope,
  PlusApi.UserinfoEmailScope,
  PlusApi.UserinfoProfileScope
];

@Expose('/api/auth')
class AuthController extends Controller {
  final AngelAuth auth = new AngelAuth(allowCookie: false);

  serializer(Person person) async => person.id;

  deserializer(String id) async {
    var users = await app.service('api/users').index({'googleId': id});

    if (users.isNotEmpty)
      return users.first;
    else {
      // Create a new user, if one doesn't already exist :)
      return await app.service('api/users').create({'googleId': id});
    }
  }

  @override
  call(Angel app) async {
    auth
      ..serializer = serializer
      ..deserializer = deserializer
      ..strategies.add(new GoogleStrategy(config: app.google, scopes: scopes));

    await super.call(app);
    // await app.configure(auth);
  }

  @Expose('/google')
  login(req, res) => auth.authenticate('google')(req, res);

  @Expose('/google/callback')
  callback(req, res) => auth.authenticate('google',
          new AngelAuthOptions(callback: (req, res, jwt) async {
        return res.redirect('/?token=$jwt');
      }))(req, res);
}
