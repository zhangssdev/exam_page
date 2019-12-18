import 'package:book_page/faiult_question/prace_test_entity.dart';
import 'package:book_page/faiult_question/question_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'fault_sliver_self_controll.dart';
import 'height_width.dart';

enum QuestionLayer{
    top,
    center,
    bottom,
}

class QuestionPage extends StatefulWidget {
  QuestionLayer questionLayer;
  SliverSelfControll selfControll;
  QuestionPage(this.questionLayer, {this.selfControll});

  @override
  State<StatefulWidget> createState() {
    return QuestionPageState();
  }
}


class QuestionPageState extends State<QuestionPage> {
  bool _isSelected = false;
  bool _isCorrect = false;
  String clickLabel = '';
  DataBean question;
  @override
  void initState() {
    super.initState();
  }
  getQuestion(questionIndex){
    question = Provider.of<QuestionSourceChange>(context).questionMap[questionIndex].question;
    _isCorrect = Provider.of<QuestionSourceChange>(context).questionMap[questionIndex].isCorrect;
    _isSelected = Provider.of<QuestionSourceChange>(context).questionMap[questionIndex].isSelected;
    clickLabel = Provider.of<QuestionSourceChange>(context).questionMap[questionIndex].clickLabel;
  }

  Widget _getImg(String url) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width_10dp),
      width: ScreenUtil.getInstance().setWidth(350),
      child: Image.network(url, fit: BoxFit.contain,),
    );
  }

  @override
  void didUpdateWidget(QuestionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.questionLayer == QuestionLayer.top){
      int questionIndex = Provider.of<QuestionSourceChange>(context).current - 1;
      if(questionIndex == -1){
        return Container();
      }
      getQuestion(questionIndex);
    }else if(widget.questionLayer == QuestionLayer.center){
      int questionIndex = Provider.of<QuestionSourceChange>(context).current;
      getQuestion(questionIndex);
    }else{
      int questionIndex = Provider.of<QuestionSourceChange>(context).current + 1;
      if(questionIndex == Provider.of<QuestionSourceChange>(context).questionMap.length){
        return Container();
      }
      getQuestion(questionIndex);
    }

    List<Widget> _list = [];
    _list.add(_question());
    _list.add(SizedBox(height: height_10dp,),);
    //存在图片
    if (question.thumb != null && question.thumb != '') {
      _list.add(_getImg(question.thumb));
    }
    //跟随答案数目，此处强制4题
    for (int i = 0; i < question.option.length; i++) {
      _list.add(_answerSelect(question.option[i]));
    }
    //答案A，您选择B
    if (_isSelected && !_isCorrect) {
      _list.add(_correntTrip());
     /* //浅底
      _list.add(Container(
          height: height_5dp,
        color: countTint,
      ));*/
      //标题  试题解析
      _list.add(Container(
        margin: EdgeInsets.only(left: width_10dp, bottom: height_10dp, top: height_10dp),
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width_5dp),
                color: Colors.blueAccent,
              ),
              height: height_20dp,
              width: width_4dp,
            ),
            SizedBox(width: width_10dp,),
            Text('试题详解', style: TextStyle(fontSize: fontSize_18sp, fontWeight: FontWeight.bold),)
          ],
        ),
      ));
      //真正解析
      _list.add(_questionAnalysis());
    }
    _list.add(Container(
      height: videoFixHeight,
    ));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _list,
        ),
      ),
    );
  }

  Widget _questionAnalysis(){
    return Container(
      padding: EdgeInsets.fromLTRB(width_10dp, height_5dp, width_10dp, height_5dp),
      child: Text(question.describe, style: TextStyle(fontSize: fontSize_14sp,), strutStyle: StrutStyle(leading: 0.5),),
    );
  }

  Widget _correntTrip() {
    return Container(
      margin: EdgeInsets.fromLTRB(width_10dp, height_5dp, width_10dp, height_5dp),
      padding: EdgeInsets.fromLTRB(width_15dp, height_7dp, width_15dp, height_7dp),
      decoration: BoxDecoration(
        color: Color(0XFFF8F6F9),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        children: <Widget>[
          Text(
            '答案', style: TextStyle(fontSize: fontSize_14sp, fontWeight: FontWeight.bold),),
          SizedBox(width: width_5dp,),
          Text(question.answer.label,
            style: TextStyle(fontSize: fontSize_14sp,color: Colors.blueAccent, fontWeight: FontWeight.bold),),
          SizedBox(width: width_10dp,),
          Text('您选择',
            style: TextStyle(fontSize: fontSize_14sp, fontWeight: FontWeight.bold),),
          SizedBox(width: width_5dp,),
          Text(clickLabel, style: TextStyle(fontSize: fontSize_14sp,color: Colors.redAccent, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget _question() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(
          width_10dp, height_10dp, width_10dp, 0),
      child: Stack(
        children: <Widget>[
          Text('         ' + question.title,
            style: TextStyle(fontSize: fontSize_18sp, fontWeight: FontWeight.w300),
            strutStyle: StrutStyle(leading: 1),
          ),
          Positioned(
            top: height_4dp,
            left: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  width_7dp, height_4dp, width_7dp, height_4dp),
              decoration: BoxDecoration(
                color: Color(0XFF0676FC),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              child: Text(
                '单选', style: TextStyle(fontSize: fontSize_11sp, color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }


  Widget _answerSelect(AnswerBean answer) {
    return !_isSelected ? GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        clickLabel = answer.label;
        _isSelected = true;
        if (answer.label == question.answer.label) {
          _isCorrect = true;
          Provider.of<QuestionSourceChange>(context).getCurrentSource(selectTrue: true);
        } else {
          _isCorrect = false;
          Provider.of<QuestionSourceChange>(context).getCurrentSource(selectTrue: false);
        }
        Provider.of<QuestionSourceChange>(context).questionMap[Provider.of<QuestionSourceChange>(context).current].isSelected = _isSelected;
        Provider.of<QuestionSourceChange>(context).questionMap[Provider.of<QuestionSourceChange>(context).current].isCorrect = _isCorrect;
        Provider.of<QuestionSourceChange>(context).questionMap[Provider.of<QuestionSourceChange>(context).current].clickLabel = clickLabel;

        setState(() {});
        //如果答对，延时1S跳到下一问题
        if (answer.label == question.answer.label) {
          Future.delayed(Duration(milliseconds: 300), () {
            if( widget.selfControll != null && Provider.of<QuestionSourceChange>(context).current != Provider.of<QuestionSourceChange>(context).questionMap.length - 1){
              widget.selfControll.next();
            }
          });
        }
      },
      child: _unClickWidget(answer),
    ) : _unClickWidget(answer);
  }

  Widget _unClickWidget(AnswerBean answer) {
    Widget _labelWidget;
    Widget _noSelectWidget = Card(
      shape: CircleBorder(),
      elevation: 5.0,
      child: Container(
        alignment: Alignment.center,
        width: width_25dp,
        height: width_25dp,
        child:Text(answer.label,
          style: TextStyle(fontSize: fontSize_18sp, fontWeight: FontWeight.w300),),
      ),
    );

    if (!_isSelected) { //未选择
      //未选择时的标签A,B,C,D
      _labelWidget = _noSelectWidget;
    } else {
      if (_isCorrect) { //选择了正确的标签
        _labelWidget = Container(
          margin: EdgeInsets.only(left: width_2dp),
          child: Image.asset('images/practice_success.png'),
          width: width_28dp,
          height: width_28dp,
        );
      } else { //选择了错误的标签
        _labelWidget = Container(
          margin: EdgeInsets.only(left: width_2dp),
          child: Image.asset('images/practice_fill.png'),
          width: width_28dp,
          height: width_28dp,
        );
      }
    }

    return Container(
        margin: EdgeInsets.fromLTRB(
          width_10dp, height_10dp, width_10dp, height_10dp),
      child: Row(
        children: <Widget>[
          _isSelected ? _isCorrect ?
          (answer.label == clickLabel ? _labelWidget : _noSelectWidget) :
          (answer.label == clickLabel ||
              answer.label == question.answer.label ? answer
              .label == clickLabel ? _labelWidget : Container(
            margin: EdgeInsets.only(left: width_2dp),
            child: Image.asset('images/practice_success.png'),
            width: width_28dp,
            height: width_28dp,
          ) : _noSelectWidget) :
          _noSelectWidget,
          SizedBox(width: width_10dp,),
          Expanded(child: Container(
            child: Text(answer.value,
              style: TextStyle(fontSize: fontSize_20sp, fontWeight: FontWeight.w300),),
          )),
        ],
      ),
    );
  }
}