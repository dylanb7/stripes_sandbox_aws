import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/auth_user.dart'
    as user_type;
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/base_auth_repo.dart';

class Auth extends AuthRepo {
  final StreamController<user_type.AuthUser> userStream = StreamController();

  late final List<AuthUserAttribute> attributes;

  Auth() {
    init();
    Amplify.Hub.listen(HubChannel.Auth, (event) {
      switch (event.type) {
        case AuthHubEventType.signedOut:
          userStream.add(const user_type.AuthUser.empty());
        case AuthHubEventType.sessionExpired:
          userStream.add(const user_type.AuthUser.empty());
        case AuthHubEventType.userDeleted:
          userStream.add(const user_type.AuthUser.empty());
        default:
          final AuthUser? user = event.payload;

          if (user != null) {
            getAttributes().then((value) => userStream
                .add(user_type.AuthUser(uid: user.userId, attributes: value)));
          }
      }
    });
  }

  init() async {
    final AuthSession sesh = await Amplify.Auth.fetchAuthSession();

    if (sesh.isSignedIn) {
      final Map<String, String> attributes = await getAttributes();

      userStream
          .add(user_type.AuthUser(uid: 'no_user_id', attributes: attributes));
    }
  }

  Future<Map<String, String>> getAttributes() async {
    final List<AuthUserAttribute> attributes =
        await Amplify.Auth.fetchUserAttributes();
    return Map.fromEntries(attributes.map((attribute) =>
        MapEntry(attribute.userAttributeKey.key, attribute.value)));
  }

  @override
  Future<void> logIn(Map<String, dynamic> params) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(Map<String, dynamic> params) {
    throw UnimplementedError();
  }

  @override
  Future<bool> resetPassword(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {
    await Amplify.Auth.signOut();
  }

  @override
  Stream<user_type.AuthUser> get user => userStream.stream;
}
