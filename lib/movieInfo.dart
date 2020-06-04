
class MovieInfo{
  var voteavg;
  var popularity;
  var searchitemid;
  var mediatype;
  var poster_path;
  List genreid=List();
 var original_title;
 List genrename=List();

  MovieInfo({
    this.voteavg,
    this.popularity,
    this.genreid,
    this.searchitemid,
    this.mediatype,
    this.poster_path,
    this.original_title


  });
  factory MovieInfo.fromJson(Map<String, dynamic> Json){
    return MovieInfo(
        voteavg:  Json["vote_average"],
        popularity: Json["popularity"],
        genreid:  Json["genre_ids"],
        searchitemid:Json["id"],
        mediatype:Json["media_type"],
         poster_path: Json["poster_path"],
        original_title:Json["original_title"]
    );
  }

}
class Movie {
  final List<MovieInfo> rs;

  Movie({
    this.rs,
  });
  factory  Movie.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;

   List<MovieInfo> indialist = list.map((i) => MovieInfo.fromJson(i)).toList();
    return Movie(
        rs: indialist,

    );

  }
}
