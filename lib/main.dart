import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:stripes_backend_helper/QuestionModel/question.dart';
import 'package:stripes_backend_helper/TestingReposImpl/test_question_repo.dart';
import 'package:stripes_sandbox_aws/amplifyconfiguration.dart';
import 'package:stripes_sandbox_aws/cross_repos/configure_amplify.dart';
import 'package:stripes_sandbox_aws/cross_repos/repo_package.dart';
import 'package:stripes_ui/UI/History/EventView/entry_display.dart';
import 'package:stripes_ui/UI/Record/question_screen.dart';
import 'package:stripes_ui/entry.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
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
          builder: Authenticator.builder(),
          strat: AuthStrat.accessCodeEmail,
          repos: CrossRepoPackage(),
          entryOverrides: {
            q4: QuestionEntry(
                isSeparateScreen: true,
                entryBuilder: (listener, question) {
                  return BMSlider(
                    listener: listener,
                    question: question as Numeric,
                  );
                }),
          },
          displayOverrides: {
            q4: <Numeric>(numeric) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BMRow(response: numeric)),
          },
        ));
  }
}
