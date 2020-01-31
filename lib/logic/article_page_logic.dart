import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import '../json/article_item_bean.dart';

class ArticlePageLogic{

  Future<String> getText(String filePath) async{
    String file = "assets/$filePath";
    String json = await rootBundle.loadString(file);
    return json;
  }

}