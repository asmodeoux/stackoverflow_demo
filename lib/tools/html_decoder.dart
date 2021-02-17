import 'package:html/parser.dart';

class HtmlTags {

  String removeTag({ htmlString, callback }){
    var document = parse(htmlString);
    return parse(document.body.text).documentElement.text;
  }
}