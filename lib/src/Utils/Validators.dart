
Pattern patternEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
Pattern patternPassword = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*)[a-zA-Z\d\W\_].{5,}$';//r'^(?=.*[A-Za-z])(?=.*\d)(?=.*)[a-zA-Z\d\W\_].{5,}$';
Pattern validateNum = r'^[0-9]{0,}$';

bool validateEmail(String email) {
  RegExp regExp = RegExp(patternEmail as String);
  if (regExp.hasMatch(email)) {
    return true;
  } else {
    return false;
  }
}

bool validatePwd(String password) {
  RegExp regExp = RegExp(patternPassword as String);
  if(password.isEmpty)return false;
  if(regExp.hasMatch(password)){
    return true;
  } else {
    return false;
  }
}


bool validatePhone(String phone) {
  RegExp regExp = RegExp(validateNum as String);
  if(phone.isEmpty)return false;
  if(regExp.hasMatch(phone) && phone.length == 10){
    return true;
  } else {
    return false;
  }
}
