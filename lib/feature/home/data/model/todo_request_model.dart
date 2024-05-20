class TodoRequestModel {
  int skip;
  int limit;

  TodoRequestModel({this.skip = 0, this.limit = 10});

  Map<String, dynamic> toJson() {
    return {'skip': skip, 'limit': limit};
  }
}
