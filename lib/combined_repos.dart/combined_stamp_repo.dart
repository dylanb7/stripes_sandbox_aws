import 'package:rxdart/subjects.dart';
import 'package:stripes_backend_helper/QuestionModel/response.dart' as repo;

import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/cross_repos/stamp_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_stamp_repo.dart';

class CombinedStampRepo extends StampRepo<repo.Response> {
  late final StampRepo remote;

  late final StampRepo local;

  List<Response> localStamps = [];

  List<Response> remoteStamps = [];

  final BehaviorSubject<List<Response>> _controller = BehaviorSubject();

  CombinedStampRepo(
      {required super.authUser,
      required super.currentUser,
      required super.questionRepo,
      DateTime? earliestFetched}) {
    remote = RemoteStamps(
        authUser: authUser,
        currentUser: currentUser,
        questionRepo: questionRepo,
        earliestFetched: earliestFetched)
      ..stamps.listen((event) {
        remoteStamps = event;
        _emit();
      });
    local = LocalStamps(
        authUser: authUser,
        currentUser: currentUser,
        questionRepo: questionRepo,
        earliestFetched: earliestFetched)
      ..stamps.listen((event) {
        localStamps = event;
        _emit();
      });
  }

  _emit() {
    final List<Response> newStamps = [...localStamps, ...remoteStamps];
    newStamps.sort((a, b) => b.stamp.compareTo(a.stamp));
    _controller.add(newStamps);
  }

  @override
  Future<void> addStamp(Response<Question> stamp) async {
    await remote.addStamp(stamp);
  }

  @override
  Future<void> removeStamp(Response<Question> stamp) async {
    if (localStamps.contains(stamp)) {
      await local.removeStamp(stamp);
    } else {
      await remote.removeStamp(stamp);
    }
  }

  @override
  Stream<List<repo.Response<Question>>> get stamps => _controller.stream;

  @override
  Future<void> updateStamp(repo.Response<Question> stamp) async {
    if (localStamps.contains(stamp)) {
      await local.updateStamp(stamp);
    } else {
      await remote.updateStamp(stamp);
    }
  }
}
