import 'package:book_page/faiult_question/practice_page.dart';
import 'package:book_page/faiult_question/question_change.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'height_width.dart';


class SliverDrawBottomControll extends ChangeNotifier{
  static int EXPEND= 0X0011;
  static int SHRINK= 0X0022;
  static int NORMAL= 0X0033;
  int active;

  void expend(){
    active = EXPEND;
    notifyListeners();
  }

  void shrink(){
    active = SHRINK;
    notifyListeners();
  }
}


class DragContainer extends StatefulWidget {
  Map<int, UserSource> questionMap;
  Function(int index) onTap;
  Function(double offset) onOffSliver;

  DragContainer(this.questionMap, this.onTap,this.onOffSliver);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DragContainerState();
  }
}

class DragContainerState extends State<DragContainer>
    with SingleTickerProviderStateMixin {
  double offsetDistance = practiceBottomDrawerHeight - videoFixHeight;

  AnimationController animalController;
  Animation<double> animation;
  CurvedAnimation curve;
  double start = 0.0;
  double end = 0.0;

  @override
  void initState() {
    super.initState();

    animalController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    ///easeOut 先快后慢
    curve =
        new CurvedAnimation(parent: animalController, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(Provider.of<SliverDrawBottomControll>(context).active == SliverDrawBottomControll.EXPEND){//展开
      Future.delayed(Duration(seconds: 0),(){
        endSliver(true);
      });
    }else if(Provider.of<SliverDrawBottomControll>(context).active == SliverDrawBottomControll.SHRINK){//回收
      Future.delayed(Duration(seconds: 0),(){
        endSliver(false);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, offsetDistance),
      child: RawGestureDetector(
        gestures: {BottomDrawerVerticalDragGestureRecognizer: getRecognizer()},
        child: _DrawerWidget(),
      ),
    );
  }

  Widget _DrawerWidget() {
    return Container(
      color: Color(0XFFF2F5FA),
      height: practiceBottomDrawerHeight,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                width_10dp, height_5dp, width_10dp, height_5dp),
            height: videoFixHeight,
            child:   _rightItem(),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.fromLTRB(
                width_10dp, height_5dp, width_10dp, height_5dp),
            color: Colors.white,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: width_15dp,
                crossAxisSpacing: width_15dp,
                childAspectRatio: 1,
              ),
              itemBuilder: _gridItem,
              itemCount: widget.questionMap.length,
            ),
          )),
        ],
      ),
    );
  }

  Widget _gridItem(BuildContext context, int index) {
    UserSource userSource = widget.questionMap[index];

    BoxDecoration boxDecoration;
    if (userSource.isSelected) {
      //已经选择过了的
      if (userSource.isCorrect) {
        //正确的
        boxDecoration = BoxDecoration(
          color: Color(0XFFDDF1FC),
          border: Border.all(
            color: Color(0XFF21ADFB),
          ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        );
      } else {
        //错误的
        boxDecoration = BoxDecoration(
          color: Color(0XFFFEE5E1),
          border: Border.all(
            color: Color(0XFFEE4B55),
          ),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        );
      }
    } else {
      //未做出选择的
      boxDecoration = BoxDecoration(
        border: Border.all(
          color: Color(0XFFF2F2F2),
        ),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      );
    }

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: boxDecoration,
        child: Text('${index + 1}'),
      ),
    );
  }



  Widget _rightItem() {
    int countTrue = Provider.of<QuestionSourceChange>(context).countTrue;
    int countFalse = Provider.of<QuestionSourceChange>(context).countFalse;
    int current = Provider.of<QuestionSourceChange>(context).current;
    int countNum = widget.questionMap.length;
    return Container(
     // width: ScreenUtil.getInstance().setWidth(180),
      child: Row(
        children: <Widget>[
         _buttonItem('images/practice_success.png', '$countTrue', true),
          Expanded(child: SizedBox(), flex: 1,),
          _buttonItem('images/practice_fill.png', '$countFalse', false),

          Expanded(child: SizedBox(), flex: 1,),
          GestureDetector(
            child: _buttonItemCount(
                'images/practice_count.png', '${current + 1}', '$countNum'),
            onTap: () {
              endSliver(true);
            },
          )
        ],
      ),
    );
  }

  Widget _buttonItemCount(
      String imageUri, String currentQuestion, String countQuestion) {
    return Row(
      children: <Widget>[
        Image.asset(
          imageUri,
          width: width_13dp,
          height: width_13dp,
        ),
        SizedBox(
          width: width_3dp,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: currentQuestion,
                style: TextStyle(fontSize: fontSize_14sp, color: Colors.black, fontWeight: FontWeight.w500)),
            TextSpan(
                text: '/$countQuestion',
                style: TextStyle(fontSize: fontSize_14sp, color: Colors.black38)),
          ]),
        ),
      ],
    );
  }

  Widget _buttonItemCollet(String imageUri, String label,) {
    return Row(
      children: <Widget>[
        Image.asset(
          imageUri,
          width: width_13dp,
          height: width_13dp,
        ),
        SizedBox(
          width: width_3dp,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: fontSize_14sp,),
        ),
      ],
    );
  }


  Widget _buttonItem(String imageUri, String label, bool isTrue) {
    return Row(
      children: <Widget>[
        Image.asset(
          imageUri,
          width: width_15dp,
          height: width_15dp,
        ),
        SizedBox(
          width: width_3dp,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: fontSize_14sp, color: isTrue ? Colors.blue : Colors.redAccent),
        ),
      ],
    );
  }

  GestureRecognizerFactoryWithHandlers<
      BottomDrawerVerticalDragGestureRecognizer> getRecognizer() {
    return GestureRecognizerFactoryWithHandlers(
        () => BottomDrawerVerticalDragGestureRecognizer(), this._initializer);
  }

  void _initializer(BottomDrawerVerticalDragGestureRecognizer instance) {
    instance
      ..onStart = _onStart
      ..onUpdate = _onUpdate
      ..onEnd = _onEnd;
  }




  ///接受触摸事件
  void _onStart(DragStartDetails details) {
    print('触摸屏幕${details.globalPosition}');
  }

  ///垂直移动
  void _onUpdate(DragUpdateDetails details) {
    print('垂直移动${details.delta}');
    offsetDistance = offsetDistance + details.delta.dy;
    print('offsetDistance=$offsetDistance');
    print('practiceBottomDrawerHeight=$practiceBottomDrawerHeight');

    if (offsetDistance <= 0) {
      //当offsetDistance<=0时，即达到最高点禁止滑动
      offsetDistance = 0;
    } else if (offsetDistance >=
        (practiceBottomDrawerHeight - videoFixHeight)) {
      //当offsetDistance<=0时，即达到最高点禁止滑动
      offsetDistance = practiceBottomDrawerHeight - videoFixHeight;
    } else {
      widget.onOffSliver(offsetDistance);
      setState(() {});
    }
  }

  ///手指离开屏幕
  void _onEnd(DragEndDetails details) {
    print('离开屏幕');
    double halfOffset = (practiceBottomDrawerHeight - videoFixHeight) / 2;
    double velocityY = details.velocity.pixelsPerSecond.dy;
    if (velocityY.abs() > 400) {
      if (velocityY > 0) {
        endSliver(false);
      } else {
        endSliver(true);
      }
    } else {
      if (offsetDistance >= halfOffset) {
        endSliver(false);
      } else {
        endSliver(true);
      }
    }
  }



  void endSliver(isShow) {
    if (isShow) {
      print('展开');
      start = offsetDistance;
      end = 0;
    } else {
      print('回收');
      start = offsetDistance;
      end = practiceBottomDrawerHeight - videoFixHeight;
    }
    animalController.value = 0.0;
    animation = Tween(begin: start, end: end).animate(curve)
      ..addListener(() {
        offsetDistance = animation.value;
        widget.onOffSliver(offsetDistance);
        setState(() {});
      });
    animalController.forward();
  }
}

class BottomDrawerVerticalDragGestureRecognizer
    extends VerticalDragGestureRecognizer {
  BottomDrawerVerticalDragGestureRecognizer({Object debugOwner})
      : super(debugOwner: debugOwner);
}
