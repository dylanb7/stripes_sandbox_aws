import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:stripes_sandbox_aws/acount_stage.dart';
import 'package:stripes_sandbox_aws/amplifyconfiguration.dart';
import 'package:stripes_sandbox_aws/combined_repos.dart/repos_package.dart';
import 'package:stripes_sandbox_aws/cross_repos/configure_amplify.dart';
import 'package:stripes_ui/UI/CommonWidgets/loading.dart';

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
    /*const config.StripesConfig local = config.StripesConfig(
        hasGraphing: true,
        hasLogging: false,
        export: fileShare,
        exportType: [config.ExportType.perPage],
        authStrategy: config.AuthStrategy.accessCode);*/

    final config.StripesConfig stripesConfig = config.StripesConfig(
        hasGraphing: true,
        hasLogging: true,
        export: fileShare,
        exportType: const [config.ExportType.perPage],
        authStrategy: config.AuthStrategy.accessCodeEmail,
        builder: Authenticator.builder(),
        stageIndicator: getStage,
        onExitStudy: () async {
          await Amplify.Auth.deleteUser();
        });

    return Authenticator(
      authenticatorBuilder: (context, state) {
        switch (state.currentStep) {
          case AuthenticatorStep.loading:
            return SizedBox.expand(
              child: ColoredBox(
                color: Theme.of(context).canvasColor,
                child: LoadingWidget(),
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomSignUp(state: state);
          case AuthenticatorStep.signIn:
            return CustomSignIn(state: state);
          default:
            return null;
        }
      },
      initialStep: AuthenticatorStep.signIn,
      child: StripesApp(
        config: stripesConfig,
        repos: CombinedRepos(),
      ),
    );
  }
}

class CustomSignIn extends StatelessWidget {
  final AuthenticatorState state;

  const CustomSignIn({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return FormContainer(
        child: Column(
      children: [
        SignInForm(),
        const SizedBox(height: 16),
        const Divider(),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('Don\'t have an account?'),
            TextButton(
              onPressed: () => state.changeStep(
                AuthenticatorStep.signUp,
              ),
              child: const Text('Sign Up'),
            ),
          ],
        )
      ],
    ));
  }
}

class CustomSignUp extends StatelessWidget {
  final AuthenticatorState state;

  const CustomSignUp({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return FormContainer(
        child: Column(
      children: [
        SignUpForm(),
        const SizedBox(height: 16),
        const Divider(),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () => state.changeStep(
                AuthenticatorStep.signIn,
              ),
              child: const Text('Sign In'),
            ),
          ],
        )
      ],
    ));
  }
}

class FormContainer extends StatelessWidget {
  final Widget child;
  const FormContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Image.asset(
                    'packages/stripes_ui/assets/images/StripesLogo.png',
                    fit: BoxFit.contain,
                    height: 35,
                  ),
                ),
                child,
              ],
            ),
          );
        }
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'packages/stripes_ui/assets/images/StripesLogo.png',
                          fit: BoxFit.contain,
                          height: 35,
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        child
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
