import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:stripes_backend_helper/RepositoryBase/SubBase/base_sub_repo.dart';
import 'package:stripes_backend_helper/stripes_backend_helper.dart' as repo;
import 'package:stripes_sandbox_aws/local_repos/local_db.dart';
import 'package:stripes_sandbox_aws/models/SubUser.dart';
import 'package:stripes_sandbox_aws/utils.dart';

class SubRepo extends SubUserRepo {
  List<repo.SubUser> subUsers = [];

  final StreamController<List<repo.SubUser>> subStream = StreamController();

  final LocalDB db = LocalDB();

  SubRepo({required super.authUser}) {
    subStream.add([]);
    init() async {
      final List<SubUser> users = await db.getSubUsers();
      subUsers = users.map((user) => toLocal(user)).toList();
      subStream.add(subUsers);
    }

    init();
  }

  @override
  Future<void> addSubUser(repo.SubUser user) async {
    try {
      final SubUser newUser = SubUser(
          name: user.name,
          gender: user.gender,
          birthYear: user.birthYear,
          isControl: user.isControl);
      final bool added = await db.addSubUser(newUser);

      if (added) {
        subUsers.add(toLocal(newUser));
        subStream.add(subUsers);
      }
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Future<void> deleteSubUser(repo.SubUser user) async {
    final id = user.uid;
    try {
      final bool removed = await db.deleteSubUser(id);
      if (removed) {
        subUsers.removeWhere((subUser) => subUser.uid == id);
        subStream.add(subUsers);
      }
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Future<void> updateSubUser(repo.SubUser user) async {
    try {
      final SubUser newUser = fromLocal(user);
      final bool updated = await db.updateSubUser(newUser);
      if (updated) {
        final int index =
            subUsers.indexWhere((subUser) => subUser.uid == newUser.id);
        if (index >= 0) {
          subUsers[index] = toLocal(newUser);
          subStream.add(subUsers);
        }
      }
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Stream<List<repo.SubUser>> get users => subStream.stream;
}
