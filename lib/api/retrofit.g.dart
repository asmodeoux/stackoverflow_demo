// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrofit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag(
    json['name'] as String,
    '',
    json['count'] as int,
  );
}

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'count': instance.count,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    json['id'] as int,
    json['title'] as String,
    json['ownerName'] as String,
    json['creationDate'] as int,
    json['body'] as String,
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'ownerName': instance.ownerName,
      'creationDate': instance.creationDate,
      'body': instance.body,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://api.stackexchange.com/2.2/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<Tag>> getTags(pagesize, page) async {
    ArgumentError.checkNotNull(pagesize, 'pagesize');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'pagesize': pagesize,
      r'page': page
    };
    print('${baseUrl}tags?order=desc&sort=popular&site=stackoverflow&filter=!4)VmdJvLRUS1RP*-5&page=$page&pagesize=$pagesize');
    final _data = <String, dynamic>{};
    final _result = await _dio.request<String>(
        '/tags?order=desc&sort=popular&site=stackoverflow&filter=!4)VmdJvLRUS1RP*-5',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = List.from(jsonDecode(_result.toString())['items'])
        .map((dynamic i) => Tag.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<Tag>> getWikis(tags) async {
    ArgumentError.checkNotNull(tags, 'tags');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<String>(
        '/tags/$tags/wikis?site=stackoverflow',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = List.from(jsonDecode(_result.toString())['items'])
        .map((dynamic i) => Tag.fromWikiJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<Question>> getQuestions(tagged) async {
    ArgumentError.checkNotNull(tagged, 'tagged');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'tagged': tagged};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/search/advanced?order=desc&sort=activity&site=stackoverflow&filter=!)Q2ANGPYCfBr(YC9YNizawue',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Question.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
