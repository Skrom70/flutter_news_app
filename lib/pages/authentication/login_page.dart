import 'package:flutter/material.dart';
import 'package:flutter_news_app/provider/auth_provider.dart';
import 'package:flutter_news_app/reuse_widgets/simple_text_form_field.dart';
import 'package:flutter_news_app/validators/main_validator.dart';
import '../../reuse_widgets/simple_snackbar.dart';

final _defaultLogin = 'skrom70@gmail.com';
final _defaultPassword = '0955978485b';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String? _emailFieldValue;
  String? _passwordFieldValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headline5,
              ),
              Row(
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register', (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SimpleTextFormField(
                        labelTextValue: 'Enter your email',
                        valueSetter: (value) => _emailFieldValue = value,
                        fieldValidator: MainValidator.emailValidation,
                        initialValue: _defaultLogin,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SimpleTextFormField(
                        labelTextValue: 'Password',
                        valueSetter: (value) => _passwordFieldValue = value,
                        fieldValidator: MainValidator.simpleValidation,
                        initialValue: _defaultPassword,
                        obscureText: true,
                      ),
                    ],
                  )),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/forgot_password');
                      },
                      child: Text(
                        'Forget password?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () => _loginAction(context),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                        side: BorderSide(
                            color: Colors.blueGrey.withOpacity(0.5),
                            width: 1.0)),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginAction(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      if (_emailFieldValue?.isNotEmpty == true &&
          _passwordFieldValue?.isNotEmpty == true) {
        AuthProvider()
            .signIn(email: _emailFieldValue!, password: _passwordFieldValue!)
            .then((value) {
          if (value == null) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          } else if (value.isNotEmpty) {
            showSnackBar(context, 'Error: $value', SnackBarType.error);
          }
        });
      }
    }
  }
}
