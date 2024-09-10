import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cog;
import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/accessed_repo.dart';
import 'package:stripes_sandbox_aws/combined_repos.dart/combined_stamp_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/auth_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/sub_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/test_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_stamp_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_sub_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_test_repo.dart';
import 'package:stripes_ui/repos/question_repo.dart';

const storageKey = cog.CognitoUserAttributeKey.custom("storage");

const groupKey = cog.CognitoUserAttributeKey.custom("group");

const invitedToKey = cog.CognitoUserAttributeKey.custom("invited_to");

class CombinedRepos extends StripesRepoPackage {
  @override
  AccessCodeRepo access() {
    return Accessed();
  }

  @override
  AuthRepo auth() {
    return Auth();
  }

  @override
  QuestionRepo<QuestionHome> questions({required AuthUser user}) {
    return Questions(authUser: user);
  }

  @override
  StampRepo<Response<Question>> stamp(
      {required AuthUser user,
      required SubUser subUser,
      required QuestionRepo<QuestionHome> questionRepo}) {
    print(user);
    if (hasRemote(user)) {
      return CombinedStampRepo(
          authUser: user, currentUser: subUser, questionRepo: questionRepo);
    }
    return LocalStamps(
        authUser: user, currentUser: subUser, questionRepo: questionRepo);
  }

  @override
  SubUserRepo sub({required AuthUser user}) {
    if (hasRemote(user)) {
      return SubRepo(authUser: user);
    }
    return LocalSubRepo(authUser: user);
  }

  @override
  TestsRepo test(
      {required AuthUser user,
      required SubUser subUser,
      required StampRepo<Stamp> stampRepo,
      required QuestionRepo<QuestionHome> questionRepo}) {
    if (hasRemote(user)) {
      return TestsRepo(tests: [
        BlueTest(
            stampRepo: stampRepo,
            authUser: user,
            subUser: subUser,
            questionRepo: questionRepo)
      ]);
    }
    return TestsRepo(tests: [
      LocalBlueTest(
        stampRepo: stampRepo,
        authUser: user,
        subUser: subUser,
        questionRepo: questionRepo,
      )
    ]);
  }
}

class LocalRepos extends StripesRepoPackage {
  @override
  AccessCodeRepo access() {
    return Accessed();
  }

  @override
  AuthRepo auth() {
    return TestAuth();
  }

  @override
  QuestionRepo<QuestionHome> questions({required AuthUser user}) {
    return Questions(authUser: user);
  }

  @override
  StampRepo<Response<Question>> stamp(
      {required AuthUser user,
      required SubUser subUser,
      required QuestionRepo<QuestionHome> questionRepo}) {
    return LocalStamps(
        authUser: user, currentUser: subUser, questionRepo: questionRepo);
  }

  @override
  SubUserRepo sub({required AuthUser user}) {
    return LocalSubRepo(authUser: user);
  }

  @override
  TestsRepo test(
      {required AuthUser user,
      required SubUser subUser,
      required StampRepo<Stamp> stampRepo,
      required QuestionRepo<QuestionHome> questionRepo}) {
    return TestsRepo(tests: [
      LocalBlueTest(
        stampRepo: stampRepo,
        authUser: user,
        subUser: subUser,
        questionRepo: questionRepo,
      )
    ]);
  }
}

class TestAuth extends AuthRepo {
  AuthUser _user = const AuthUser.empty();

  final StreamController<AuthUser> _authUser = StreamController();
  @override
  Future<void> logIn(Map<String, dynamic> params) async {
    print('Logged in');
    _user = AuthUser(
        uid: 'uid',
        attributes: {groupKey.toString(): AccountStates.invited.value});
    _authUser.add(_user);
  }

  @override
  Future<void> logOut() async {
    _user = const AuthUser.empty();
    _authUser.add(_user);
  }

  @override
  Future<bool> resetPassword(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(Map<String, dynamic> params) async {
    print('Signed up');
    _user = const AuthUser.uid(uid: 'uid');
    _authUser.add(_user);
  }

  @override
  Stream<AuthUser> get user => _authUser.stream;
}

bool hasRemote(AuthUser user) =>
    user.attributes.containsKey(storageKey.key) &&
    (user.attributes[storageKey.key] == AccountStates.enrolled.value ||
        user.attributes[storageKey.key] == AccountStates.expired.value);

enum AccountStates {
  local('local'),
  invited('invited'),
  enrolled('enrolled'),
  expired('expired');

  final String value;
  const AccountStates(this.value);
}
