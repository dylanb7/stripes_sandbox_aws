import 'package:flutter/material.dart';
import 'package:stripes_backend_helper/TestingReposImpl/test_question_repo.dart';
import 'package:stripes_backend_helper/stripes_backend_helper.dart';
import 'package:stripes_sandbox_aws/cross_repos/test_repo.dart';
import 'package:stripes_ui/UI/History/EventView/entry_display.dart';
import 'package:stripes_ui/UI/Record/question_screen.dart';

class Questions extends QuestionRepo {
  Questions({required super.authUser});

  @override
  QuestionHome get questions => Home();

  @override
  Map<String, QuestionEntry>? get entryOverrides => {
        q4: QuestionEntry(
            isSeparateScreen: true,
            entryBuilder: (listener, context, question) {
              return BMSlider(
                listener: listener,
                question: question as Numeric,
              );
            }),
        blueQuestionId: QuestionEntry(
            isSeparateScreen: true,
            entryBuilder: (listener, context, question) {
              return BlueDyeEntry(
                  listener: listener, question: question as MultipleChoice);
            })
      };

  @override
  Map<String, DisplayBuilder<Response<Question>>>? get displayOverrides => {
        q4: <Numeric>(context, numeric) => SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: BMRow(response: numeric)),
      };
}

class Home extends QuestionHome {
  @override
  Map<String, Question> get all => QuestionHomeInst().all;

  @override
  Map<String, Question> get additons => {
        blueQuestionId: const MultipleChoice(
            id: blueQuestionId,
            isRequired: true,
            prompt: "Did this bowel movement contain any blue color?",
            type: Symptoms.BM,
            choices: ['Yes', 'No'])
      };
}
