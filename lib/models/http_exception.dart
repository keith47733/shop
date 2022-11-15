// Exception is an abstract Dart class (ie, can't be instantiated). Int his case, 'implements' assign all fucntions/methods that Exception has to your custom named class. The Exception basically takes an error message object and passes it to another class _Exception which, in turn, returns the error as a String.

// abstract class Exception {
//   factory Exception([var message]) => _Exception(message);
// }

// /// Default implementation of [Exception] which carries a message.
// class _Exception implements Exception {
//   final dynamic message;

//   _Exception([this.message]);

//   String toString() {
//     Object? message = this.message;
//     if (message == null) return "Exception";
//     return "Exception: $message";
//   }
// }

// Object is the base class in Dart. All class, by default, extends Object. Object has a method .toString(). So we need to @override Object's .toString() message in our custom HttpException class.
class HttpException implements Exception {
  final String message;

  HttpException(this.message);
	
  @override
  String toString() {
    return message;
  }
}
