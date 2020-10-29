import 'package:flutter/material.dart';
import 'package:mooreview/dataProvider/dataService.dart';

class LoginPage extends StatefulWidget {
  Function _updateLoginState;

  LoginPage(this._updateLoginState);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _obscurePassword = true;
  var _isRegistering = false;
  var _isLoading = false;
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _firstNameTextController = TextEditingController();
  var _lastNameTextController = TextEditingController();

  void _login() async {
    // Add propper email and password checking
    setState(() {
      _isLoading = true;
    });
    var result = !_isRegistering
        ? await DataProvider()
            .login(_emailTextController.text, _passwordTextController.text)
        : await DataProvider().register(
            _emailTextController.text,
            _passwordTextController.text,
            _firstNameTextController.text,
            _lastNameTextController.text);
    if (result) {
      widget._updateLoginState();
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title:
                    Text('Unable to ${_isRegistering ? 'Register' : 'login'}'),
                content: Text('Please check your credentials'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok'))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Register' : 'Login'),
      ),
      body:_isLoading? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailTextController,
                autofocus: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'orange@mailbox.com',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email)),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _passwordTextController,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: '********',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.security),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          this._obscurePassword = !this._obscurePassword;
                        });
                      },
                    )),
              ),
              _isRegistering
                  ? SizedBox(
                      height: 8,
                    )
                  : Container(),
              _isRegistering
                  ? TextField(
                      controller: _firstNameTextController,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Orange',
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                    )
                  : Container(),
              _isRegistering
                  ? SizedBox(
                      height: 8,
                    )
                  : Container(),
              _isRegistering
                  ? TextField(
                      controller: _lastNameTextController,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Juice',
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                    )
                  : Container(),
              FlatButton(
                child: Text(
                  _isRegistering
                      ? 'Already got an account?'
                      : 'Create a new account',
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  this.setState(() {
                    this._isRegistering = !this._isRegistering;
                  });
                },
                textColor: Colors.blueAccent,
              ),
              RaisedButton(
                onPressed: _login,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.blue,
                textColor: Colors.white,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      _isRegistering ? 'Register' : 'Login',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
