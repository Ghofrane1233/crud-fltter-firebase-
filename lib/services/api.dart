import 'dart:convert';

import 'package:http/http.dart';

class  ApiServices {
  getRequest()async{
     var res=await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
     var decodeData =json.decode(res.body);
     // ignore: avoid_print
     print(decodeData[0]);
  }
}