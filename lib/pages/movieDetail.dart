import 'package:flutter/material.dart';
import 'package:mooreview/dataProvider/dataService.dart';
import 'package:mooreview/dataProvider/datas/movieData.dart';
import 'package:mooreview/dataProvider/datas/reviewData.dart';

class MovieDetail extends StatefulWidget {
  final MovieData data;

  MovieDetail(this.data);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  var _loading = true;
  List<ReviewData> data = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      _loading = true;
    });
    var result = await DataProvider().getMovieReviews(widget.data.iD);
    if (result == null) {
      data = [];
    } else {
      data = result;
    }
    setState(() {
      _loading = false;
    });
  }

  var _newCommentTextController = TextEditingController();
  var _newRatingTextController = TextEditingController();

  void _addReview() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Add new review'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: ('Comment'),
                      hintText: ('Good movie'),
                    ),
                    controller: _newCommentTextController,
                    autocorrect: false,
                    autofocus: true,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: ('Rating'),
                      hintText: ('5'),
                    ),
                    controller: _newRatingTextController,
                    autocorrect: false,
                    autofocus: false,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      _newRatingTextController.text = "";
                      _newCommentTextController.text = "";
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () async {
                      var rating = _newRatingTextController.text;
                      String comment = _newCommentTextController.text;
                      var ratingInt = 0;
                      var ratingError = false;
                      try {
                        ratingInt = int.parse(rating);
                      } catch (_) {
                        ratingError = true;
                      }
                      if (ratingError ||
                          ratingInt < 0 ||
                          ratingInt > 5 ||
                          comment.length < 5) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Rating should be number between 0 and 5 and comment should be at least 5 characters'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ));
                        return;
                      }
                      var res = await DataProvider().addNewReview(comment, ratingInt, widget.data.iD);
                      Navigator.of(context).pop();
                      if(res) _getData();
                      else{
                        showDialog(context: context,builder: (ctx)=>AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          title: Text('Error'),
                          content: Text('Unable to add new review'),
                        ));
                      }
                    },
                    child: Text('Add'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data.name}(${widget.data.rating})'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addReview,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.data.voters.toString() +
                      ' Vote - ' +
                      widget.data.addedOn,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.data.addedBy,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(data[index].rating.toString()),
                        ),
                        title: Text(data[index].author),
                        subtitle: Text(data[index].comment),
                        trailing: Text(data[index].addedOn),
                      );
                    },
                    itemCount: data.length,
                  ),
          ),
        ],
      ),
    );
  }
}
