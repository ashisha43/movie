import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movieshow/movieInfo.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'gener.dart';
import 'search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Movie movie;
  genre s;

  List<String> moviename=[];
  List<double> avgvote=[];
  List<String> posterlink=[];

  List<String> genrenames=[];
  List<String> movienameiteam=[];
  List<double> avgvoteiteam=[];
  List<String> posterlinkiteam=[];

  List <List> genrelists=List();
  List <List> dummygenre=List();

  ScrollController _scrollController=ScrollController();

  var imageurl="http://image.tmdb.org/t/p/w185//";
  var gettoprated="https://api.themoviedb.org/3/movie/top_rated?api_key=b1d0f6fbc8e10c5a4982776c6073f1c9&language=en-US";

  bool ontap=false;
  bool loading=true;

  @override
  void initState() {
    getapi(gettoprated);
    super.initState();
  }

  void getapi (var url)async{
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonresponce=await json.decode(response.body);
      movie = new Movie.fromJson(jsonresponce);
      print(movie.results.length);
      for(int i=0;i<movie.results.length;i++){
        await getgenapi(i,movie.results[i].searchitemid);
      }
      dummygenre.addAll(genrelists);
      for(int i=0;i<movie.results.length;i++){
        moviename.add(movie.results[i].original_title);
        posterlink.add(movie.results[i].poster_path);
        avgvote.add(movie.results[i].voteavg);
        movienameiteam.add(movie.results[i].original_title);
        posterlinkiteam.add(movie.results[i].poster_path);
        avgvoteiteam.add(movie.results[i].voteavg);
      }
      //setStates();
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      loading=false;
    });
  }
  Future<Widget> getgenapi(int index,var id) async{
    print("ID IS $id INDEX IS $index");
    final response = await http.get("https://api.themoviedb.org/3/movie/"+id.toString()+"?api_key=bc723b59e8641c4a0add655901553849");
    if (response.statusCode == 200) {
      var jsonresponce=await json.decode(response.body);
      s = new genre.fromJson(jsonresponce);
      for(int i=0;i<s.rs.length;i++){
        movie.results[index].genrename.add(s.rs[i].name);
      }

      print(movie.results[index].genrename);
      //setStates();
    } else {
      throw Exception('Failed to load data');
    }
    print(genrelists);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:35.0,left: 8.0,right: 8.0),
              child: TextField(
                  onChanged: (value) {
                    searchlist(value);
                  },
                  onTap: (){
                    ontap=true;
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(),
                  )

              ),
            ),
            loading||movienameiteam.length-1<=0?Padding(
              padding: const EdgeInsets.only(top:250.0,),
              child: CircularProgressIndicator(),
            ):
            ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: movienameiteam.length-1,
              itemBuilder: (context, index) {
                return cardview(index);
              },
            ),
          ],
        ),
      ),
    );

  }
  Widget cardview(int index) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: Stack(
        children: <Widget>[
          Container(
            width:MediaQuery.of(context).size.width*.4,
            height: MediaQuery.of(context).size.height*.28,
            //color: Colors.red,
          ),
          Positioned(
            top: 15,
            right: 5,
            left: 5,
            bottom: 0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              //margin: new EdgeInsets.symmetric(horizontal: 15.0,vertical: 6.0),
              elevation: 10.0,
              child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width*.35,
                        ),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(movienameiteam[index].toString(),style: TextStyle(
                                fontFamily: 'CM Sans Serif',
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),

                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text(ontap==true?"":movie.results[index].genrename.toString().replaceAll('[', " ").replaceAll(']', " "),
                                maxLines: 4,
                                style: TextStyle(
                                    color: Colors.grey
                                ),),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(""+avgvoteiteam[index].toString(),style:
                                  TextStyle(
                                      fontFamily: 'CM Sans Serif',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigoAccent
                                  ),),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0),
                                    child: RatingBar(
                                      initialRating: ((avgvoteiteam[index])/2),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      glow: true,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                      itemBuilder: (context, _) => new SizedBox(
                                        height: 6.0,
                                        width: 6.0,
                                        child:
                                        new Icon(Icons.star, size: 6.0,
                                            color:Color(0xFFFF6631),
                                         )
                                        ,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )

                          ],
                        )),

                      ],
                    ),
                  )
              ),
            ),
          ),    Positioned(
            left:20,
            top: 0.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(

                imageurl+posterlinkiteam[index],
                fit:BoxFit.fill,
                height: MediaQuery.of(context).size.height*.24,
                width: MediaQuery.of(context).size.width*.28,

                loadingBuilder: (context,child,progress){
                  return progress==null?child:Container(
                      height: 120.0,
                      width: 100.0,
                      child: Center(child: Icon(Icons.image)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  void searchlist(String query) async{
    String searchkey="https://api.themoviedb.org/3/search/multi?api_key=b1d0f6fbc8e10c5a4982776c6073f1c9&language=en-US&query="+query+"&include_adult=false";

    int i=0;
    print(query);
    List<String> dummydistListmoviename = [];
    List<double> dummydistListavgvote = [];
    List<String> dummydistListposterlink = [];

    dummydistListmoviename.addAll(moviename);
    dummydistListavgvote.addAll(avgvote);
    dummydistListposterlink.addAll(posterlink);

    if (query.isNotEmpty) {
      List<String> dummymoviename = [];
      List<double> dummyvote = [];
      List<String> dummyposterlink = [];
      try{
        final response = await http.get(searchkey);
        if (response.statusCode == 200) {
          setState(() {
            loading=true;
          });
          var jsonresponce=await json.decode(response.body);
          movieSearch ms = new movieSearch.fromJson(jsonresponce);
          print(ms.result.length);
          print(ms.result[i].vote_average.runtimeType);
          for(int i=0;i<ms.result.length;i++) {
            print(ms.result[i].original_title);
            if (ms.result[i].original_title.toString() =='null' || ms.result[i].poster_path==null || ms.result[i].vote_average==null) {
              print("NULL SLIPPPING");
              continue;
            }
            else{
              print(ms.result[i].vote_average.runtimeType);
              dummymoviename.add(ms.result[i].original_title);
              dummyposterlink.add(ms.result[i].poster_path);
              dummyvote.add(ms.result[i].vote_average);
            }
          }}}
      catch(e){
        print(" ");
      }

      setState(() {
        movienameiteam.clear();
        posterlinkiteam.clear();
        avgvoteiteam.clear();
        movienameiteam.addAll(dummymoviename);
        posterlinkiteam.addAll(dummyposterlink);
        avgvoteiteam.addAll(dummyvote);
        print("ITEMLENGTH");
        print(movienameiteam.length);
        print(movienameiteam);
        print(posterlinkiteam);
        print(avgvoteiteam);
        loading=false;
      });
    } else {
      setState(() {
        ontap=false;
        print("notEnter");
        movienameiteam.clear();
        posterlinkiteam.clear();
        avgvoteiteam.clear();
        movienameiteam.addAll(dummydistListmoviename);
        posterlinkiteam.addAll(dummydistListposterlink);
        avgvoteiteam.addAll(dummydistListavgvote);
        print(movienameiteam.length);
        loading=false;
      });
    }
  }
}
