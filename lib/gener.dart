

class genreInfo{
  var id;
  var name;
  genreInfo({
    this.id,
    this.name


  });
  factory genreInfo.fromJson(Map<String, dynamic> Json){
    return genreInfo(
        id:  Json["vote_average"],
         name:Json["name"]

    );
  }
}
class genre{
  final List<genreInfo> rs;
  genre({
    this.rs,
  });
  factory genre.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['genres'] as List;
    List<genreInfo> genlist= list.map((i) => genreInfo.fromJson(i)).toList();
    return genre(
      rs: genlist,
    );
  }
}


