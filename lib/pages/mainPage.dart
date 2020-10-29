import 'package:flutter/material.dart';
import 'package:mooreview/dataProvider/dataService.dart';
import 'package:mooreview/dataProvider/datas/movieData.dart';
import 'package:mooreview/pages/movieDetail.dart';

class MainPage extends StatefulWidget {
  Function _updateLoginState;

  MainPage(this._updateLoginState);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _logout() {
    DataProvider().logout().then((value) => widget._updateLoginState());
  }

  List<MovieData> _data = [];
  var _loading = false;

  Future<void> _getData() async {
    setState(() {
      this._loading = true;
    });
    _data = await DataProvider().getAllMovie();
    if (_data == null) _data = [];
    setState(() {
      this._loading = false;
    });
  }

  var _newMovieTextController = TextEditingController();

  void _addMovie(BuildContext ctx1) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Add a new Movie'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: TextField(
          decoration: InputDecoration(
              labelText: 'Movie Name', hintText: 'Detective Chinatown'),
          autofocus: true,
          controller: _newMovieTextController,
          autocorrect: false,
        ),
        actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              _newMovieTextController.text = "";
            },
          ),
          FlatButton(
            child: Text('Add'),
            onPressed: () async {
              var data = _newMovieTextController.text;
              if (data.length < 3) {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text('Error'),
                          content: Text(
                              'New movie name should at least be 3 characters'),
                        ));
              } else {
                var res = await DataProvider()
                    .addNewMovie(_newMovieTextController.text);
                Navigator.of(ctx).pop();

                if (res)
                  await _getData();
                else
                  Scaffold.of(ctx1).showSnackBar(SnackBar(
                    content: Text('Cannot add new movie'),
                  ));
              }
            },
          ),
        ],
      ),
    );
  }

  void _showMovieDetails(MovieData data) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (ctx) => MovieDetail(data)));

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _loading
          ? AppBar(
              title: Text('Loading ...'),
            )
          : AppBar(
              title: Text('Mooreview'),
              actions: [
                IconButton(
                    icon: Icon(Icons.exit_to_app_rounded), onPressed: _logout),
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addMovie(ctx),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _getData,
                )
              ],
            ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(_data[index].name),
                  subtitle:
                      Text(_data[index].addedBy + '\n' + _data[index].addedOn),
                  leading: CircleAvatar(
                    child: Text(_data[index].rating.toString()),
                  ),
                  isThreeLine: true,
                  trailing: Text('${_data[index].voters} Vote(s)'),
                  onTap: () => _showMovieDetails(_data[index]),
                );
              },
            ),
    );
  }
}
