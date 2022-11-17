import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../providers/auth.dart';
import '../../styles/form_field_decoration.dart';
import '../../styles/layout.dart';
import '../../widgets/show_error_dialog.dart';

enum AuthMode {
  Signup,
  Login,
}

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth_screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            gradientContainer(context),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Layout.SPACING * 2),
                child: Card(
                  elevation: Layout.ELEVATION,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Layout.RADIUS),
                  ),
                  child: Container(
                    // height: deviceSize.height - Layout.SPACING * 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
											crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            titleImage(context),
                            titleBanner(context),
                          ],
                        ),
                        AuthForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gradientContainer(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.primary.withOpacity(1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
        ),
      ),
    );
  }
}

Widget titleImage(context) {
  return Padding(
      padding: const EdgeInsets.only(
        top: Layout.SPACING * 1.5,
        left: Layout.SPACING * 2,
        right: Layout.SPACING * 2,
      ),
      child: Image.asset('assets/images/shopping.png'));
}

Widget titleBanner(context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 0,
      left: Layout.SPACING * 2,
      right: Layout.SPACING * 2,
    ),
    padding: EdgeInsets.symmetric(
      vertical: Layout.SPACING * 0.75,
      horizontal: Layout.SPACING * 1.5,
    ),
    // z-axis is from your eyes through your device.
    // translate() offsets the object. If you add .translate(), the statement returns the type of the last method. In this case, .translate() returns void (ie, it does something but doesn't return anything). The ..translate() still applies the translate() method but returns what the previous method returns (ie, what rotationZ() returns).
    transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Layout.RADIUS * 3),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
      // boxShadow: [
      //   BoxShadow(
      //     blurRadius: 4,
      //     color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
      //     offset: Offset(4, 4),
      //   )
      // ],
    ),
    child: FittedBox(
      child: Text(
        'Bitches Be Shopping',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontFamily: 'Oswald',
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
      ),
    ),
  );
}

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState == null) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    
		setState(() {
      _isLoading = true;
    });

    var errorMessage = '';

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
        // This Navigator would work if the app was to start with signup/login screen everytime. But we want to check if the device user is currently with a token stored on their device.
        // // Navigator.of(context).pushReplacementNamed('/products_screen');
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      // 'on HttpException' catches an error thrown by the HttpException class.
    } on HttpException catch (httpError) {
      // An HttpException is only thrown in signup/login if the http.post() Json response contains an ['error'] key. We passed the value of the ['error']['message'] key, which we capture here as httpError object. The httpException class has an @override to convert and return the error as a String.
      final error = httpError.toString();

      if (error.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use by another account.';
      } else if (error.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage = 'Too many failed login attempts. Please try again later.';
      } else if (error.contains('INVALID EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak. Please enter another password.';
      } else if (error.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'There is no user record with this email address.';
      } else if (error.contains('INVALID_PASSWORD')) {
        errorMessage = 'The password is invalid.';
      } else {
        errorMessage = 'Authentication failed.';
      }
      showErrorDialog(context, errorMessage);
    } catch (error) {
      // This will catch all other errors (eg, no internet, socket error, etc).
      errorMessage = 'Could not authenticate you. Please try again later.';
      showErrorDialog(context, errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(
          top: Layout.SPACING * 1.5,
          bottom: Layout.SPACING * 0.5,
          left: Layout.SPACING * 1.5,
          right: Layout.SPACING * 1.5,
        ),
        child: Column(
          children: <Widget>[
            emailFormField(),
            SizedBox(height: Layout.SPACING),
            passwordFormField(),
            SizedBox(height: Layout.SPACING),
            if (_authMode == AuthMode.Signup) confirmPasswordFormField(),
            if (_authMode == AuthMode.Signup) SizedBox(height: Layout.SPACING),
            if (_isLoading) CircularProgressIndicator() else signupLoginButton(),
            switchAuthModeButton(),
          ],
        ),
      ),
    );
  }

  Widget emailFormField() {
    return TextFormField(
      decoration: formFieldDecoration(context).copyWith(
        labelText: 'Email address',
      ),
      // decoration: InputDecoration(labelText: 'E-Mail'),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null) {
          return 'Please enter your email';
        }
        if (value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _authData['email'] = value;
        }
      },
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      decoration: formFieldDecoration(context).copyWith(
        labelText: 'Password',
      ),
      // decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: _authMode == AuthMode.Login ? TextInputAction.done : TextInputAction.done,
      validator: (value) {
        if (value == null) {
          return 'Please enter your password';
        }
        if (value.isEmpty || value.length < 5) {
          return 'Please enter a password with at least 5 characters';
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          _authData['password'] = value;
        }
      },
    );
  }

  Widget confirmPasswordFormField() {
    return TextFormField(
      enabled: _authMode == AuthMode.Signup,
      decoration: formFieldDecoration(context).copyWith(
        // filled: true,
        // fillColor: Theme.of(context).colorScheme.background,
        labelText: 'Confirm password',
      ),
      // decoration: InputDecoration(labelText: 'Confirm password'),
      obscureText: true,
      controller: _confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: _authMode == AuthMode.Signup
          ? (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            }
          : null,
    );
  }

  Widget signupLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Layout.RADIUS * 2),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Layout.SPACING,
          vertical: Layout.SPACING / 2,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        textStyle: Theme.of(context).textTheme.titleLarge,
      ),
      child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
      onPressed: _submit,
    );
  }

  Widget switchAuthModeButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: Layout.SPACING,
          vertical: Layout.SPACING / 2,
        ),
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text('${_authMode == AuthMode.Login ? 'Signup' : 'Login'} Instead'),
      onPressed: _switchAuthMode,
    );
  }
}
