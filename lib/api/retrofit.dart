import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';
import 'package:stackoverflow/model/model.dart';
import 'package:stackoverflow/redux/reducers.dart';
import 'package:stackoverflow/tools/html_decoder.dart';

part 'retrofit.g.dart';

@RestApi(baseUrl: "https://api.stackexchange.com/2.2/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/tags?order=desc&sort=popular&site=stackoverflow&filter=!4)VmdJvLRUS1RP*-5")
  Future<List<Tag>> getTags(@Query("pagesize") int pagesize, @Query("page") int page); // gets tags without wikis

  @GET("/tags/{tags}/wikis?site=stackoverflow")
  Future<List<Tag>> getWikis(@Path() String tags); // gets wikis for tags, 20 per request is the limit — tags are divided by semicolons

  @GET("/search/advanced?order=desc&sort=creation&site=stackoverflow&filter=!Fcb3plNOK_c(XFHn(fm1upY_nq")
  Future<List<Question>> getQuestions(@Query("tagged") String tagged, @Query("tagged") int page); // gets questions with a required tag

  // the weird-looking filters are used to disable unrequired fields in order to reduce data consumption
}

@JsonSerializable()
class Tag extends Equatable {
  final String name;
  final String description;
  final int count;

  Tag(this.name, this.description, this.count);

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  factory Tag.fromWikiJson(Map<String, dynamic> json) {
    return Tag(
      json['tag_name'] as String,
      json['excerpt'] as String,
      0
    );
  }

  Map<String, dynamic> toJson() => _$TagToJson(this);

  // to format text or adapt to it's absence
  String get formattedDescription => description == '' || description == null ?
    'Description is not available at the moment' : HtmlUnescape().convert(description); // decoding HTML entitites
  String get formattedCount => count == null ? 'N/A' : (count > 10000 ? '${(count/1000).toStringAsFixed(1)}k' : count.toString());

  @override
  List<Object> get props => [name, description, count];

  @override
  String toString() {
    return 'Tag{name: $name, description: $description, count: $count}';
  }
}

@JsonSerializable()
class Question extends Equatable {
  final int id;
  final String title;
  final String ownerName;
  final int creationDate; // unix timestamp, ms
  final String body; // used to generate question's description

  String get titleFormatted => title == '' || title == null ? 'N/A' : HtmlUnescape().convert(title); // decoding HTML entitites
  String get dateFormatted => DateFormat.yMMMd().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(creationDate*1000)); // human-readable format, API returns seconds

  // to parse HTML body to a shorter human-readable format
  String bodyFormatted() {
    String bodyDecoded = HtmlTags().removeTag(htmlString: body.replaceAll('\n', ' '));
    List<String> cut = bodyDecoded.split(' ');

    try {
      if (cut.length <= Constants.QUESTION_BODY_WORD_LIMIT) {
        return bodyDecoded;
      } else {
        return cut.getRange(0, Constants.QUESTION_BODY_WORD_LIMIT).join(' ');
      }
    } catch (e) {
      logger.e(e);
      return 'N/A';
    }
  }

  Question(this.id, this.title, this.ownerName, this.creationDate, this.body);

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  List<Object> get props => [id, title, ownerName, creationDate, body];

  @override
  String toString() {
    return 'Question{id: $id, title: $title, ownerName: $ownerName, creationDate: $creationDate, body: $body}';
  }
}
