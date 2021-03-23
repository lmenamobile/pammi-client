class Login{

  bool validateEmail = false;
  bool validatePassword = false;

  Login({
    this.validateEmail,
    this.validatePassword
});
}

class ForgotPass {
  bool validateEmail = false;
  ForgotPass({
    this.validateEmail

  });
}

class Register{
  bool validateEmail = false;
  bool validPass= false;
  bool validConfirmPass = false;
  Register({
    this.validateEmail,
    this.validConfirmPass,
    this.validPass
  });
}


class UpdatePass{

  bool validPass= false;
  bool validConfirmPass = false;
  UpdatePass({

    this.validConfirmPass,
    this.validPass
  });
}