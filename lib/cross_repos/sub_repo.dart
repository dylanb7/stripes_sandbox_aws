import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:rxdart/subjects.dart';

import 'package:stripes_backend_helper/RepositoryBase/SubBase/base_sub_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/SubBase/sub_user.dart'
    as repo;
import 'package:stripes_sandbox_aws/local_repos/local_sub_repo.dart';
import 'package:stripes_sandbox_aws/models/SubUser.dart';

import 'package:stripes_sandbox_aws/utils.dart';

class SubRepo extends SubUserRepo {
  List<repo.SubUser> subUsers = [];

  final StreamController<List<repo.SubUser>> subStream = BehaviorSubject();

  late final LocalSubRepo localSubRepo;

  SubRepo({required super.authUser}) {
    localSubRepo = LocalSubRepo(authUser: authUser);
    init() async {
      final List<SubUser> users = await _querySubs();
      subUsers = users.map((user) => toLocal(user)).toList();
      subStream.add(subUsers);
    }

    init();
  }

  String? group() =>
      authUser.attributes[const CognitoUserAttributeKey.custom("group").key];

  Future<List<SubUser>> _querySubs() async {
    try {
      final GraphQLRequest<PaginatedResult<SubUser>> request =
          ModelQueries.list<SubUser>(SubUser.classType);
      final GraphQLResponse<PaginatedResult<SubUser>> response =
          await Amplify.API.query(request: request).response;
      final List<SubUser?>? subUsers = response.data?.items;
      return subUsers?.whereType<SubUser>().toList() ?? [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addSubUser(repo.SubUser user) async {
    try {
      final SubUser newUser = SubUser(
          id: user.uid,
          name: user.name,
          gender: user.gender,
          birthYear: user.birthYear,
          isControl: user.isControl,
          group: group());
      final addRequest = ModelMutations.create(newUser);
      final response = await Amplify.API.mutate(request: addRequest).response;
      final SubUser? newSub = response.data;
      if (newSub != null) {
        subUsers.add(toLocal(newUser));
        subStream.add(subUsers);
      }
      localSubRepo.addSubUser(user);
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Future<void> deleteSubUser(repo.SubUser user) async {
    try {
      final removeRequest = ModelMutations.deleteById(
          SubUser.classType, SubUserModelIdentifier(id: user.uid));
      final response =
          await Amplify.API.mutate(request: removeRequest).response;
      final SubUser? removedSub = response.data;
      if (removedSub != null) {
        subUsers.removeWhere((subUser) => subUser.uid == removedSub.id);
        subStream.add(subUsers);
      }
      localSubRepo.deleteSubUser(user);
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Future<void> updateSubUser(repo.SubUser user) async {
    try {
      final SubUser newUser = fromLocal(user)..copyWith(group: group());
      final updateRequest = ModelMutations.update(newUser);
      final response =
          await Amplify.API.mutate(request: updateRequest).response;
      final SubUser? updatedSub = response.data;
      if (updatedSub != null) {
        final int index =
            subUsers.indexWhere((subUser) => subUser.uid == updatedSub.id);
        if (index >= 0) {
          subUsers[index] = toLocal(updatedSub);
          subStream.add(subUsers);
        }
      }
      localSubRepo.updateSubUser(user);
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Stream<List<repo.SubUser>> get users => subStream.stream;
}
