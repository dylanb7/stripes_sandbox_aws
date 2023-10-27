import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/auth_user.dart'
    as user_type;
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/base_auth_repo.dart';

class Auth extends AuthRepo {
  final StreamController<user_type.AuthUser> userStream = StreamController();

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
            userStream.add(user_type.AuthUser(uid: user.userId));
          }
      }
    });
  }

  init() async {
    userStream.add(const user_type.AuthUser.empty());
    final AuthSession sesh = await Amplify.Auth.fetchAuthSession();
    if (sesh.isSignedIn) {
      userStream.add(const user_type.AuthUser(uid: 'authed_no_token'));
    }
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
