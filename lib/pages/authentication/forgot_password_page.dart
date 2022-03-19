import 'package:flutter/material.dart';
import 'package:flutter_news_app/provider/auth_provider.dart';
import 'package:flutter_news_app/reuse_widgets/simple_snackbar.dart';
import 'package:flutter_news_app/validators/main_validator.dart';
import '../../reuse_widgets/simple_text_form_field.dart';

// ignore: must_be_immutable
class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  String? _emailFieldValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 100.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                'Forgot password',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                'Provide your email and we will send you a link to reset your password',
              ),
              SizedBox(
                height: 20.0,
              ),
              Form(
                  key: _formKey,
                  child: SimpleTextFormField(
                      labelTextValue: 'Enter your email',
                      valueSetter: (value) => _emailFieldValue = value,
                      fieldValidator: MainValidator.emailValidation)),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () => _resetPasswordAction(context),
                    child: Text(
                      'Reset password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                        side: BorderSide(
                            color: Colors.blueGrey.withOpacity(0.5),
                            width: 1.0)),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Go back',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _resetPasswordAction(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      if (_emailFieldValue != null) {
        AuthProvider().resetPassword(_emailFieldValue!).then((value) {
          if (value == null) {
            Navigator.of(context).pop();
          } else if (value.isNotEmpty) {
            showSnackBar(context, 'Error: $value', SnackBarType.error);
          }
        });
      }
    }
  }
}
