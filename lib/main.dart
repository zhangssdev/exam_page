import 'package:flutter/material.dart';

import 'faiult_question/practice_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookPage',
      home: ExamQuestions(),
    );
  }

}

