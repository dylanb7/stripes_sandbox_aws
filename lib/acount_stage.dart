import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stripes_backend_helper/RepositoryBase/AuthBase/auth_user.dart'
    as base;
import 'package:stripes_backend_helper/RepositoryBase/SubBase/sub_user.dart';
import 'package:stripes_sandbox_aws/combined_repos.dart/repos_package.dart';
import 'package:stripes_sandbox_aws/cross_repos/sub_repo.dart';
import 'package:stripes_sandbox_aws/local_repos/local_sub_repo.dart';
import 'package:stripes_ui/Providers/auth_provider.dart';
import 'package:stripes_ui/Util/easy_snack.dart';

Widget? getStage(base.AuthUser user) {
  if (user.attributes.containsKey(storageKey.key) &&
      user.attributes.containsKey(invitedToKey.key) &&
      user.attributes[storageKey.key] == AccountStates.invited.value) {
    return InvitedIndicator(
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
          onPressed: () async {
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

    final SubRepo remote = SubRepo(authUser: widget.user);

    for (SubUser user in localUsers) {
      await remote.addSubUser(user);
    }
    ref.invalidate(authProvider);
    setState(() {
      updating = false;
    });

    return true;
  }
}
