import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:stripes_sandbox_aws/acount_stage.dart';
import 'package:stripes_sandbox_aws/amplifyconfiguration.dart';
import 'package:stripes_sandbox_aws/combined_repos.dart/repos_package.dart';
import 'package:stripes_sandbox_aws/cross_repos/configure_amplify.dart';

import 'package:stripes_ui/UI/History/EventView/export.dart';
import 'package:stripes_ui/config.dart' as config;
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
    const config.StripesConfig local = config.StripesConfig(
        hasGraphing: true,
        hasLogging: false,
        export: fileShare,
        exportType: [config.ExportType.perPage],
        authStrategy: config.AuthStrategy.accessCode);

    final config.StripesConfig stripesConfig = config.StripesConfig(
        hasGraphing: true,
        hasLogging: false,
        export: fileShare,
        exportType: const [config.ExportType.perPage],
        authStrategy: config.AuthStrategy.accessCodeEmail,
        builder: Authenticator.builder(),
        stageIndicator: getStage,
        onExitStudy: () async {
          await Amplify.Auth.deleteUser();
        });

    return Authenticator(
      initialStep: AuthenticatorStep.signIn,
      child: StripesApp(
        config: stripesConfig,
        repos: CombinedRepos(),
      ),
    );
  }
}
