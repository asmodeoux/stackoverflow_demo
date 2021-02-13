import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';

part 'retrofit.g.dart';

@RestApi(baseUrl: "https://api.stackexchange.com/2.2/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/tags?order=desc&sort=popular&site=stackoverflow&filter=!4)VmdJvLRUS1RP*-5")
  Future<List<Tag>> getTags(@Query("pagesize") int pagesize, @Query("page") int page); // gets tags without wikis

  @GET("/tags/{tags}/wikis?site=stackoverflow")
  Future<List<Tag>> getWikis(@Path() String tags); // gets wikis for tags, 20 per request is the limit — tags are divided by semicolons

  @GET("/search/advanced?order=desc&sort=activity&site=stackoverflow&filter=!)Q2ANGPYCfBr(YC9YNizawue")
  Future<List<Question>> getQuestions(@Query("tagged") String tagged); // gets questions with a required tag

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
      0,
    );
  }

  Map<String, dynamic> toJson() => _$TagToJson(this);

  String get formattedDescription => description == '' || description == null ? 'Description is not available at the moment' : description; // to format text or adapt to it's absence

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

  String get dateFormatted => DateFormat.yMMMd().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(creationDate)); // human-readable format
  String get bodyFormatted => body ?? 'The description is empty'; // to format the HTML-markdown body as required

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
