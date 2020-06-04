
class MovieSearchInfo{
  var vote_average;
  var poster_path;
  var original_title;
  var searchitemid;
  List genreid=List();
  List genrename=List();


  MovieSearchInfo({
    this.vote_average,
    this.poster_path,
    this.original_title,
    this.genreid,
    this.searchitemid,

  });
  factory MovieSearchInfo.fromJson(Map<String, dynamic> Json){
   // print(Json["original_title"]);
    return MovieSearchInfo(
        vote_average: Json["vote_average"],
        poster_path: Json["poster_path"],
        original_title:Json["original_title"],
         genreid:  Json["genre_ids"],
      searchitemid:Json["id"],
    );
  }

}
class movieSearch {
  final List<MovieSearchInfo> result;

  movieSearch({
    this.result,

  });
  factory  movieSearch.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;

    List<MovieSearchInfo> indialist = list.map((i) => MovieSearchInfo.fromJson(i)).toList();
    return movieSearch(
      result: indialist,
    );
  }
}
