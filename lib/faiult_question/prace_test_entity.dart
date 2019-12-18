class PraceTestEntity {
  int status;
  String msg;
  List<DataBean> data;

  static PraceTestEntity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PraceTestEntity praceTestEntityBean = PraceTestEntity();
    praceTestEntityBean.status = map['status'];
    praceTestEntityBean.msg = map['msg'];
    praceTestEntityBean.data = List()..addAll(
      (map['data'] as List ?? []).map((o) => DataBean.fromMap(o))
    );
    return praceTestEntityBean;
  }

  Map toJson() => {
    "status": status,
    "msg": msg,
    "data": data,
  };
}


class DataBean {
  String itemid;
  String catid;
  String grade;
  String title;
  AnswerBean answer;
  String describe;
  String hits;
  String addtime;
  String thumb;
  String catname;
  List<AnswerBean> option;

  static DataBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DataBean dataBean = DataBean();
    dataBean.itemid = map['itemid'];
    dataBean.catid = map['catid'];
    dataBean.grade = map['grade'];
    dataBean.title = map['title'];
    print('${map['answer']} id=${map['itemid']}');
    dataBean.answer = AnswerBean.fromMap(map['answer']);
    dataBean.describe = map['describe'];
    dataBean.hits = map['hits'];
    dataBean.addtime = map['addtime'];
    dataBean.thumb = map['thumb'];
    dataBean.catname = map['catname'];
    dataBean.option = List()..addAll(
      (map['option'] as List ?? []).map((o) => AnswerBean.fromMap(o))
    );
    return dataBean;
  }

  Map toJson() => {
    "itemid": itemid,
    "catid": catid,
    "grade": grade,
    "title": title,
    "answer": answer,
    "describe": describe,
    "hits": hits,
    "addtime": addtime,
    "thumb": thumb,
    "catname": catname,
    "option": option,
  };
}



class AnswerBean {
  String label;
  String value;

  static AnswerBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AnswerBean answerBean = AnswerBean();
    answerBean.label = map['label'];
    answerBean.value = map['value'];
    return answerBean;
  }

  Map toJson() => {
    "label": label,
    "value": value,
  };
}