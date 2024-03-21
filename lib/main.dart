import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:stripes_sandbox_aws/amplifyconfiguration.dart';
import 'package:stripes_sandbox_aws/cross_repos/configure_amplify.dart';
import 'package:stripes_sandbox_aws/cross_repos/repo_package.dart';
import 'package:stripes_ui/entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await addAmplifyCrossPugins();
  await Amplify.configure(amplifyconfig);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
        initialStep: AuthenticatorStep.signIn,
        child: StripesApp(
          hasGraphing: false,
          hasLogging: true,
          builder: Authenticator.builder(),
          strat: AuthStrat.accessCodeEmail,
          repos: CrossRepoPackage(),
          removeTrace: () async {
            await Amplify.Auth.deleteUser();
          },
        ));
  }
}
