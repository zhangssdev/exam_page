import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'fault_sliver_self_controll.dart';
import 'question_change.dart';
import 'question_page.dart';

class PageChangeMiddle extends StatefulWidget {
  SliverSelfControll controll;
  PageChangeMiddle({this.controll});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PageChangeMiddleState();
  }
}

class PageChangeMiddleState extends State<PageChangeMiddle> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPageSelf(
        topChild: QuestionPage(QuestionLayer.top),
        centerChild: QuestionPage(QuestionLayer.center, selfControll: widget.controll),
        bottomChild: QuestionPage(QuestionLayer.bottom),
        controll: widget.controll,
    );

  }
}

class SliverPageSelf extends StatefulWidget {
  Widget topChild;
  Widget centerChild;
  Widget bottomChild;
  SliverSelfControll controll;

  SliverPageSelf({this.topChild, this.centerChild, this.bottomChild, this.controll});

  @override
  State<StatefulWidget> createState() {
    return SliverPageSelfState();
  }
}

class SliverPageSelfState extends State<SliverPageSelf>
    with TickerProviderStateMixin {
  double leftOffsetDistance;

  double centerOffsetDistance = 0;

  AnimationController animalController1;
  Animation<double> animation1;
  CurvedAnimation curve1;
  double start = 0.0;
  double end = 0.0;

  AnimationController animalController2;
  Animation<double> animation2;
  CurvedAnimation curve2;

  bool topShowShadow = false;
  bool centerShowShadow = false;

  @override
  void dispose() {
    animalController1.dispose();
    animalController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    leftOffsetDistance = -ScreenUtil.getInstance().setWidth(350);

    animalController1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    curve1 =
        new CurvedAnimation(parent: animalController1, curve: Curves.easeOut);

    animalController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    curve2 =
        new CurvedAnimation(parent: animalController2, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(widget.controll.self  == SliverSelf.next){
      _nextviewAnimation();
      widget.controll.self = SliverSelf.init;
    }else if(widget.controll.self  == SliverSelf.previous){
      _previewAnimation();
      widget.controll.self = SliverSelf.init;
    }

  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SliverSelfControll>(context).self == SliverSelf.next;
    return _mainWidget();
  }

  void _previewAnimation(){
    endSliver(false);
  }

  //下一个页面
  void _nextviewAnimation(){
    centerEndSliver(true);
  }


  Widget _mainWidget() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: widget.bottomChild,
          ),
          Transform.translate(
            offset: Offset(centerOffsetDistance, 0.0),
            child: _centerLayer(),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(leftOffsetDistance, 0.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: (leftOffsetDistance != -ScreenUtil.getInstance().setWidth(350) ) ? [
                    BoxShadow(
                        color: Colors.black54, blurRadius: 10.0, spreadRadius: 2.0)
                  ] : null,
                  color: Colors.white,
                ),
                child: widget.topChild,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerLayer() {
    return RawGestureDetector(
      gestures: {CenterPicDragGestureRecognizer: getRecognizer()},
      child: Container(
          width: double.infinity,
          height: double.infinity,
          child: widget.centerChild,
          decoration: BoxDecoration(
            boxShadow: (centerOffsetDistance != 0) ? [
              BoxShadow(
                  color: Colors.black54, blurRadius: 10.0, spreadRadius: 2.0)
            ] : null,
            color: Colors.white,
          )),
    );
  }

  GestureRecognizerFactoryWithHandlers<CenterPicDragGestureRecognizer>
      getRecognizer() {
    return GestureRecognizerFactoryWithHandlers(
        () => CenterPicDragGestureRecognizer(), this._initializer);
  }

  void _initializer(CenterPicDragGestureRecognizer instance) {
    instance
      ..onStart = _onStart
      ..onUpdate = _onUpdate
      ..onEnd = _onEnd;
  }

  ///接受触摸事件
  void _onStart(DragStartDetails details) {
    print('触摸屏幕${details.globalPosition}');
    currentDrag = 0;
  }

  double currentDrag = 0;

  ///垂直移动
  void _onUpdate(DragUpdateDetails details) {
    print('垂直移动${details.delta}');
    currentDrag = currentDrag + details.delta.dx;
    if (currentDrag >= 0) {
      //向右滑动
      if (Provider.of<QuestionSourceChange>(context).current == 0) {
        //如果当前图为第一张则不让右滑
        currentDrag = -1;
        return;
      }
      leftOffsetDistance = leftOffsetDistance + details.delta.dx;
    } else {
      //向左滑动
      if (Provider.of<QuestionSourceChange>(context).current ==
          Provider.of<QuestionSourceChange>(context).questionMap.length - 1) {
        //如果当前图为第一张则不让右滑
        currentDrag = 1;
        print(
            'current = ${Provider.of<QuestionSourceChange>(context).current}');
        print(
            'length - 1 =${Provider.of<QuestionSourceChange>(context).questionMap.length - 1}');

        return;
      }
      centerOffsetDistance = centerOffsetDistance + details.delta.dx;
    }
    setState(() {});
  }

  ///手指离开屏幕
  void _onEnd(DragEndDetails details) {
    print('离开屏幕');
    double halfOffset = MediaQuery.of(context).size.width / 2;
    double velocityX = details.velocity.pixelsPerSecond.dx;
    if (currentDrag > 0) {
      //向右滑动,动leftOffsetDistance
      if (velocityX.abs() > 400) {
        if (velocityX > 0) {
          endSliver(false);
        } else {
          endSliver(true);
        }
      } else {
        if (leftOffsetDistance >= -halfOffset) {
          endSliver(false);
        } else {
          endSliver(true);
        }
      }
    } else {
      //向左滑动,动centerOffsetDistance
      if (velocityX.abs() > 400) {
        if (velocityX > 0) {
          //还原，即中间的图回退到0，0的位置
          centerEndSliver(false);
        } else {
          centerEndSliver(true);
        }
      } else {
        if (centerOffsetDistance >= -halfOffset) {
          //还原，即中间的图回退到0，0的位置
          centerEndSliver(false);
        } else {
          centerEndSliver(true);
        }
      }
    }
  }

  void centerEndSliver(bool isShow) {
    if (isShow) {
      print('左平移');
      start = centerOffsetDistance;
      end = -ScreenUtil.getInstance().setWidth(350);
      animalController2.value = 0.0;
      animation2 = Tween(begin: start, end: end).animate(curve2)
        ..addListener(() {
          centerOffsetDistance = animation2.value;
          setState(() {});
        });
      animalController2.forward().then((_) {
        Provider.of<QuestionSourceChange>(context).forward();
        centerOffsetDistance = 0;
      });
    } else {
      //还原0，0
      print('还原');
      start = centerOffsetDistance;
      end = 0;

      animalController2.value = 0.0;
      animation2 = Tween(begin: start, end: end).animate(curve2)
        ..addListener(() {
          centerOffsetDistance = animation2.value;
          setState(() {});
        });
      animalController2.forward();
    }
  }

  void endSliver(bool isShow) {
    if (isShow) {
      print('展开');
      start = leftOffsetDistance;
      end = -ScreenUtil.getInstance().setWidth(350);
      animalController1.value = 0.0;
      animation1 = Tween(begin: start, end: end).animate(curve1)
        ..addListener(() {
          leftOffsetDistance = animation1.value;
          setState(() {});
        });
      animalController1.forward();
    } else {
      print('回收');
      start = leftOffsetDistance;
      end = 0;

      animalController1.value = 0.0;
      animation1 = Tween(begin: start, end: end).animate(curve1)
        ..addListener(() {
          leftOffsetDistance = animation1.value;
          setState(() {});
        });
      animalController1.forward().then((_) {

        Provider.of<QuestionSourceChange>(context).previous();
        leftOffsetDistance = -ScreenUtil.getInstance().setWidth(350);
      });
    }
  }
}

class CenterPicDragGestureRecognizer extends HorizontalDragGestureRecognizer {
  CenterPicDragGestureRecognizer({Object debugOwner})
      : super(debugOwner: debugOwner);
}
