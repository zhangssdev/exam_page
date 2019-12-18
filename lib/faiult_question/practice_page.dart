import 'dart:convert';

import 'package:book_page/faiult_question/prace_test_entity.dart';
import 'package:book_page/faiult_question/question_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'bottom_drawer.dart';
import 'height_width.dart';
import 'pratice_sliver.dart';
import 'fault_sliver_self_controll.dart';

class ExamQuestions extends StatefulWidget {

  String id;
  ExamQuestions({this.id});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ExamQuestionsState();
  }
}

class UserSource {
  bool isCorrect;
  bool isSelected;
  String clickLabel;
  DataBean question;

  UserSource({this.isCorrect, this.isSelected, this.clickLabel, this.question});
}

class ExamQuestionsState extends State<ExamQuestions> {
  List<DataBean> _questionList = [];

  Map<int, UserSource> questionMap = {};
  QuestionSourceChange questionSourceChange;
  SliverSelfControll sliverSelfControll;
  double alpha = 0;
  bool isAllowShow = true;
  bool isAllowClick = false;
  TestAlphaChangeNotifier testAlphaChangeNotifier;
  SliverDrawBottomControll sliverDrawBottomControll;

  @override
  void initState() {
    super.initState();

    DataBean bean = DataBean();
    bean.title = 'This is my question';
    bean.answer = AnswerBean()
      ..label = 'A'
      ..value = 'Value';
    bean.describe = 'This is Describe';
    bean.option = [
      AnswerBean()
        ..label = 'A'
        ..value = 'Value',
      AnswerBean()
        ..label = 'B'
        ..value = 'Value',
      AnswerBean()
        ..label = 'C'
        ..value = 'Value',
      AnswerBean()
        ..label = 'D'
        ..value = 'Value',
    ];

    _questionList = [
      bean,
      bean..thumb = '',
      bean,
      bean,
      bean,
      bean,
      bean,
      bean,
      bean,
      bean,
    ];
    for (int i = 0; i < _questionList.length; i++) {
      questionMap[i] = UserSource(
          isSelected: false, isCorrect: false, question: _questionList[i]);
      print(questionMap[i].question);
    }
    questionSourceChange = QuestionSourceChange(questionMap);
    sliverSelfControll = SliverSelfControll();
    testAlphaChangeNotifier = TestAlphaChangeNotifier();
    sliverDrawBottomControll = SliverDrawBottomControll();

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 350, height: 750, allowFontScaling: false)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('PracticePage'),
        centerTitle: true,
      ),
      body: MultiProvider(
              providers: [
                ChangeNotifierProvider<QuestionSourceChange>.value(
                    value: questionSourceChange),
                ChangeNotifierProvider<SliverSelfControll>.value(
                    value: sliverSelfControll),
                ChangeNotifierProvider<TestAlphaChangeNotifier>.value(
                    value: testAlphaChangeNotifier),
                ChangeNotifierProvider<SliverDrawBottomControll>.value(
                    value: sliverDrawBottomControll),
              ],
              child: Stack(
                children: <Widget>[
                  PageChangeMiddle(
                    controll: sliverSelfControll,
                  ),
                  isAllowShow
                      ? SizedBox()
                      : GestureDetector(
                          onTap: isAllowClick
                              ? () {
                                  print('top');
                                    sliverDrawBottomControll.shrink();
                                }
                              : null,
                          child: TestAlphaWidget(Container(
                            color: Colors.black38,
                          )),
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DragContainer(questionMap, (int index) {
                      questionSourceChange.current = index;
                      questionSourceChange.notifyListeners();
                    }, (double veOffset) {
                      alpha = 1 - veOffset / (practiceBottomDrawerHeight - videoFixHeight);
                     testAlphaChangeNotifier.changeAlpha(alpha);
                      if (alpha == 1) {
                        //不透明，不让点击
                        isAllowShow = false;
                        setState(() {});
                      } else if (alpha == 0) {
                        isAllowShow = true;
                        setState(() {});
                      } else {
                        if (isAllowShow) {
                          isAllowShow = false;
                          setState(() {});
                        }
                      }
                      if (alpha == 1) {
                        isAllowClick = true;
                        setState(() {});
                      } else {
                        if (isAllowClick) {
                          isAllowClick = false;
                          setState(() {});
                        }
                      }
                    }),
                  ),
                ],
              ),
            ),
    );
  }
}

class TestAlphaWidget extends StatefulWidget {
  Widget child;

  TestAlphaWidget(this.child);

  @override
  State<StatefulWidget> createState() {
    return TestAlphaWidgetState();
  }
}

class TestAlphaWidgetState extends State<TestAlphaWidget> {
  @override
  Widget build(BuildContext context) {
    print('TestAlphaWidgetState Build');
    print('alphaRatio==> ${Provider.of<TestAlphaChangeNotifier>(context).alphaRatio}');
    return Opacity(
      opacity: Provider.of<TestAlphaChangeNotifier>(context).alphaRatio,
      child: widget.child,
    );
  }
}

class TestAlphaChangeNotifier extends ChangeNotifier {
  double alphaRatio = 0;

  changeAlpha(double alpha) {
    alphaRatio = alpha;
    notifyListeners();
  }
}
