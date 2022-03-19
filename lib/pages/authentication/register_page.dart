import 'package:flutter/material.dart';

import '../../provider/auth_provider.dart';
import '../../reuse_widgets/simple_snackbar.dart';
import '../../reuse_widgets/simple_text_form_field.dart';
import '../../validators/main_validator.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String? _emailFieldValue;
  String? _passwordFieldValue;
  String? _confirmPasswordFieldValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text('Welcome to News App! Please create an account to continue'),
              Row(
                children: [
                  Text(
                    'Alrealy have an account?',
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Sign in',
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
                          fieldValidator: MainValidator.emailValidation),
                      SizedBox(
                        height: 10.0,
                      ),
                      SimpleTextFormField(
                          labelTextValue: 'Password',
                          valueSetter: (value) => _passwordFieldValue = value,
                          fieldValidator: (value) =>
                              MainValidator.confirmPasswordValidation(
                                  value, _confirmPasswordFieldValue),
                          obscureText: true),
                      SizedBox(
                        height: 10.0,
                      ),
                      SimpleTextFormField(
                        labelTextValue: 'Confirm password',
                        valueSetter: (value) =>
                            _confirmPasswordFieldValue = value,
                        fieldValidator: (value) =>
                            MainValidator.confirmPasswordValidation(
                                value, _passwordFieldValue),
                        obscureText: true,
                      ),
                    ],
                  )),
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () => _registerAction(context),
                    child: Text(
                      'Register',
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

  void _registerAction(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      if (_emailFieldValue?.isNotEmpty == true &&
          _passwordFieldValue?.isNotEmpty == true &&
          _confirmPasswordFieldValue?.isNotEmpty == true) {
        AuthProvider()
            .signUp(email: _emailFieldValue!, password: _passwordFieldValue!)
            .then((value) {
          if (value == null) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', (Route<dynamic> route) => false);
          } else if (value.isNotEmpty) {
            showSnackBar(context, 'Error: $value', SnackBarType.error);
          }
        });
      }
    }
  }
}
