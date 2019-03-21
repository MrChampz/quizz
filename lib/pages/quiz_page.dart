import 'package:flutter/material.dart';

import '../ui/correct_wrong_overlay.dart';
import '../ui/answer_button.dart';
import '../ui/question_text.dart';

import '../utils/question.dart';
import '../utils/quiz.dart';

import './score_page.dart';

class QuizPage extends StatefulWidget {

  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Quiz quiz = new Quiz([
    new Question("Orcas não são baleias, mas sim uma espécie de golfinho.", true),
    new Question("A profissão de cheirador de pé realmente existe.", false),
    new Question("Segurar um espirro pode até mesmo causar o rompimento de um vaso sanguíneo.", false),
    new Question("Antigamente, costumava-se escovar os dentes com urina.", true),
    new Question("A cleópatra é mais próxima à criação do McDonalds do que a construção das pirâmides do Egito.", true),
    new Question("Se você desembrulhar todo o DNA que você tem em suas células, você poderia chegar à lua vinte mil vezes.", false),
    new Question("Existem mais átomos no corpo humano do que estrelas no Universo.", true),
    new Question("A pessoa branca tem mais resistência do que a pessoa negra.", false),
    new Question("A asa de um mosquito se move 1000 vezes por segundo.", true),
    new Question("Há mais bactérias em sua boca do que pessoas no planeta Terra.", true),
    new Question("Um canhoto é mais vulnerável a doenças do que um destro.", true),
    new Question("A chance de se ter uma pessoa com uma impressão digital igual a outra é a mesma de ganhar na loteria 50 vezes.", false),
    new Question("Um estudo comprovou que a comida preferida dos ratos é queijo.", false),
    new Question("O Pernalonga não é um coelho, mas sim uma espécie de lebre.", true),
    new Question("Os golfinhos costumam dar nomes uns aos outros.", true),
  ]);

  Question currentQuestion;
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = currentQuestion.answer == answer;
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( // Main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false)),
          ],
        ),
        overlayShouldBeVisible ? new CorrectWrongOverlay(
          isCorrect,
          () {
            if (quiz.length == questionNumber) {
              Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)),
                (Route route) => route == null
              );
            } else {
              currentQuestion = quiz.nextQuestion;
              this.setState(() {
                questionText = currentQuestion.question;
                questionNumber = quiz.questionNumber;
                overlayShouldBeVisible = false;
              });
            }
          }
        ) : new Container(),
      ],
    );
  }
}