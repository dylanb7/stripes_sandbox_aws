import 'package:stripes_backend_helper/QuestionModel/question.dart';
import 'package:stripes_backend_helper/QuestionModel/response.dart';
import 'package:stripes_backend_helper/RepositoryBase/AccessBase/base_access_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/auth_user.dart';
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/base_auth_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/QuestionBase/question_repo_base.dart';
import 'package:stripes_backend_helper/RepositoryBase/StampBase/base_stamp_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/SubBase/base_sub_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/SubBase/sub_user.dart';
import 'package:stripes_backend_helper/RepositoryBase/TestBase/BlueDye/blue_dye_impl.dart';
import 'package:stripes_backend_helper/RepositoryBase/TestBase/base_test_repo.dart';
import 'package:stripes_backend_helper/TestingReposImpl/test_question_repo.dart';
import 'package:stripes_backend_helper/repo_package.dart';
import 'package:stripes_sandbox_aws/accessed_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/stamp_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/sub_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/test_repo.dart';

import 'auth_repo.dart';

class CrossRepoPackage extends StripesRepoPackage {
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
    return TestQuestionRepo();
  }

  @override
  StampRepo<Response<Question>> stamp(
      {required AuthUser user,
      required SubUser subUser,
      required QuestionRepo questionRepo}) {
    return Stamps(
        authUser: user, currentUser: subUser, questionRepo: questionRepo);
  }

  @override
  SubUserRepo sub({required AuthUser user}) {
    return SubRepo(authUser: user);
  }

  @override
  TestRepo<BlueDyeTest> test(
      {required AuthUser user,
      required SubUser subUser,
      required StampRepo stampRepo,
      required QuestionRepo<QuestionHome> questionRepo}) {
    return Test(
        stampRepo: stampRepo,
        authUser: user,
        subUser: subUser,
        questionRepo: questionRepo);
  }
}
