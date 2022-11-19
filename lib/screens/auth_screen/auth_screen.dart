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
    child: Image.asset('assets/images/shopping.png'),
  );
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
    transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Layout.RADIUS * 3),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
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

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController!.dispose();
  }

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
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
				_switchAuthMode();
      }
    } on HttpException catch (httpError) {
      final error = httpError.toString();
      if (error.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use by another account';
      } else if (error.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage = 'Too many failed login attempts. Please try again later';
      } else if (error.contains('INVALID EMAIL')) {
        errorMessage = 'Please enter a valid email address';
      } else if (error.contains('WEAK_PASSWORD')) {
        errorMessage = 'Please choose a more secure password';
      } else if (error.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'There is no user record with this email address';
      } else if (error.contains('INVALID_PASSWORD')) {
        errorMessage = 'Please enter a valid password';
      } else {
        errorMessage = 'Please try again later';
      }
      showErrorDialog(
        context,
        'Authentication error',
        errorMessage,
      );
    } catch (error) {
      errorMessage = 'Please try again later.';
      showErrorDialog(
        context,
        'Server error',
        errorMessage,
      );
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
      _animationController!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
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
            confirmPasswordFormField(_authMode),
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

  Widget confirmPasswordFormField(_authMode) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      constraints: BoxConstraints(
        maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
      ),
      child: FadeTransition(
        opacity: _opacityAnimation!,
        child: SlideTransition(
          position: _slideAnimation!,
          child: TextFormField(
            enabled: _authMode == AuthMode.Signup,
            decoration: formFieldDecoration(context).copyWith(
              labelText: 'Confirm password',
            ),
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
          ),
        ),
      ),
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
      child: Text('${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
      onPressed: _switchAuthMode,
    );
  }
}
