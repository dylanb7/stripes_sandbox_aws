import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cog;
import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/accessed_repo.dart';
import 'package:stripes_sandbox_aws/combined_repos.dart/combined_stamp_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/auth_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/questions.dart';
import 'package:stripes_sandbox_aws/cross_repos/sub_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/test_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_stamp_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_sub_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_test_repo.dart';

const storageKey = cog.CognitoUserAttributeKey.custom("storage");

const groupKey = cog.CognitoUserAttributeKey.custom("group");

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

bool hasRemote(AuthUser user) =>
    user.attributes.containsKey(storageKey) &&
    (user.attributes[storageKey] == AccountStates.enrolled ||
        user.attributes[storageKey] == AccountStates.expired);

enum AccountStates {
  local('local'),
  invited('invited'),
  enrolled('enrolled'),
  expired('expired');

  final String value;
  const AccountStates(this.value);
}
