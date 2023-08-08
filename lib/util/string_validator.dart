extension StringValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidName() {
    if (this.isEmpty) return false;
    return RegExp(r"^[a-zA-Z\s]*$", unicode: true).hasMatch(this);
  }

  bool isValidMobileNumber() {
    if (this.isEmpty) return false;
    if (this.length != 10) return false;

    return !(this.split('').any((element) {
          try {
            int.parse(element);
            return false;
          } catch (e) {
            return true;
          }
        })) &&
        (this.length > 5);

    // return !(RegExp(r"[a-zA-Z]+", unicode: true).hasMatch(this)) &&
    //     !(this.length < 6 || this.length > 15);
  }

  Map<String, dynamic> isValidPassword() {
    if (this.isEmpty)
      return {'isValid': false, 'message': 'Please provide a password'};
    if (this.contains(' '))
      return {
        'isValid': false,
        'message': 'Password should not contain any space'
      };
    if (this.length < 6)
      return {
        'isValid': false,
        'message': 'Password must be minimum 6 characters long'
      };

    return {'isValid': true, 'message': ''};
  }
}
