import 'package:book_page/faiult_question/practice_page.dart';
import 'package:flutter/material.dart';



class QuestionSourceChange extends ChangeNotifier{
  int countTrue = 0;
  int countFalse = 0;


  Map<int, UserSource>  questionMap;
  int current = 0;
  QuestionSourceChange(this.questionMap);


  void previous(){
    current--;
    notifyListeners();
  }

  void forward(){
    current++;
    notifyListeners();
  }



  getCurrentQuestion({int currentPage}){
    if(currentPage == null){
      current++;
    }else{
      current = currentPage;
    }
    notifyListeners();
  }


  getCurrentSource({bool selectTrue}){
    if(selectTrue){
      countTrue++;
    }else{
      countFalse++;
    }

    notifyListeners();
  }


}

