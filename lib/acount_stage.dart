import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/auth_user.dart'
    as base;
import 'package:stripes_backend_helper/RepositoryBase/QuestionBase/question_repo_base.dart';
import 'package:stripes_backend_helper/RepositoryBase/SubBase/base_sub_repo.dart';
import 'package:stripes_backend_helper/RepositoryBase/SubBase/sub_user.dart';
import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/combined_repos.dart/repos_package.dart';
import 'package:stripes_sandbox_aws/cross_repos/stamp_repo.dart';
import 'package:stripes_sandbox_aws/cross_repos/sub_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_stamp_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_sub_repo.dart';
import 'package:stripes_sandbox_aws/models/BlueDyeResponse.dart';
import 'package:stripes_ui/Providers/auth_provider.dart';
import 'package:stripes_ui/Providers/questions_provider.dart';
import 'package:stripes_ui/Providers/sub_provider.dart';
import 'package:stripes_ui/Util/easy_snack.dart';

Widget? getStage(base.AuthUser user) {
  if (user.attributes.containsKey(storageKey.key) &&
      user.attributes.containsKey(invitedToKey.key) &&
      user.attributes[storageKey.key] == AccountStates.invited.value) {
    return InvitedIndicator(
      user: user,
    );
  }

  if (user.attributes.containsKey(storageKey.key) &&
      user.attributes[storageKey.key] == AccountStates.expired.value) {
    return ExpiredAccount(
      user: user,
    );
  }
  return null;
}

class InvitedIndicator extends ConsumerStatefulWidget {
  final base.AuthUser user;

  const InvitedIndicator({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return InvitedIndicatorState();
  }
}

class InvitedIndicatorState extends ConsumerState<InvitedIndicator> {
  bool updating = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 6.0,
      right: 6.0,
      child: Center(
        child: FilledButton(
          onPressed: updating
              ? null
              : () async {
                  _enroll();
                },
          child: const Text("Participate in blue meal study"),
        ),
      ),
    );
  }

  Future<bool> _enroll() async {
    setState(() {
      updating = true;
    });
    final Map<AuthUserAttributeKey, UpdateUserAttributeResult> result =
        await Amplify.Auth.updateUserAttributes(attributes: [
      AuthUserAttribute(
        userAttributeKey: storageKey,
        value: AccountStates.enrolled.value,
      ),
      AuthUserAttribute(
          userAttributeKey: groupKey,
          value: widget.user.attributes[invitedToKey.key]),
      const AuthUserAttribute(
        userAttributeKey: invitedToKey,
        value: "",
      ),
    ]);

    if (result.values.where((value) => !value.isUpdated).isNotEmpty) {
      if (mounted) {
        showSnack(context, "Failed to update user");
      }
      return false;
    }

    final List<SubUser> localUsers =
        await LocalSubRepo(authUser: widget.user).users.first;

    print(localUsers);

    final SubRepo remote = SubRepo(authUser: widget.user);

    for (SubUser user in localUsers) {
      await remote.addSubUser(user);
      print("created $user");
    }
    ref.invalidate(authProvider);
    ref.invalidate(subProvider);
    setState(() {
      updating = false;
    });

    return true;
  }
}

class ExpiredAccount extends ConsumerStatefulWidget {
  final base.AuthUser user;
  const ExpiredAccount({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ExpiredAccountState();
  }
}

class ExpiredAccountState extends ConsumerState<ExpiredAccount> {
  bool updating = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 6.0,
      right: 6.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1.5),
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
            color: Theme.of(context).cardColor),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "You have completed the blue dye study. Thank you for your participation! If you have no further symptoms to log for the study, click the Complete Study button.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6.0,
              ),
              FilledButton(
                  onPressed: updating
                      ? null
                      : () {
                          completeStudy();
                        },
                  child: Text(updating ? "Completing..." : "Complete Study")),
            ],
          ),
        ),
      ),
    );
  }

  completeStudy() async {
    setState(() {
      updating = true;
    });

    final QuestionRepo<QuestionHome> questions =
        await ref.read(questionsProvider.future);

    final SubUserRepo? subs = await ref.read(subProvider.future);
    if (subs == null) {
      showSnack(context, "Failed to load users");
      return false;
    }

    final List<SubUser> users = await subs.users.first;

    for (final SubUser user in users) {
      final StampRepo stampRepo = RemoteStamps(
          authUser: widget.user, currentUser: user, questionRepo: questions);
      final List<Stamp> stamps = await stampRepo.stamps.first;
      final LocalStamps localStamps = LocalStamps(
          authUser: widget.user, currentUser: user, questionRepo: questions);
      for (final Stamp stamp in stamps) {
        if (stamp is BlueDyeResponse) {
          await localStamps.addRawBlueDye(stamp as BlueDyeResponse);
        } else {
          await localStamps.addStamp(stamp);
        }
      }
    }

    final Map<AuthUserAttributeKey, UpdateUserAttributeResult> result =
        await Amplify.Auth.updateUserAttributes(attributes: [
      AuthUserAttribute(
        userAttributeKey: storageKey,
        value: AccountStates.local.value,
      ),
      AuthUserAttribute(userAttributeKey: groupKey, value: ""),
      const AuthUserAttribute(
        userAttributeKey: invitedToKey,
        value: "",
      ),
    ]);

    if (result.values.where((value) => !value.isUpdated).isNotEmpty) {
      if (mounted) {
        showSnack(context, "Failed to update user");
      }
      return false;
    }
    ref.invalidate(authProvider);
    setState(() {
      updating = false;
    });
  }
}
