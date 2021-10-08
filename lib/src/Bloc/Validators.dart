
import 'dart:async';

import 'package:wawamko/src/Utils/Strings.dart';

//import 'package:nacional_licores/src/utils/strings.dart';

class Validators{

  final validateEmail = StreamTransformer<String,String>.fromHandlers(
      handleData: (email,sink){
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = new RegExp(pattern as String);
        if (regExp.hasMatch(email)){
          sink.add(email);
        }else{
          sink.addError('Email invalido');
        }

      }

  );



  final validatePassword = StreamTransformer<String,String>.fromHandlers(
      handleData: (password,sink){
        Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*)[a-zA-Z\d\W\_].{5,}$';
        RegExp regExp = new RegExp(pattern as String);


        if (regExp.hasMatch(password)){
          sink.add(password);
        }else{
          sink.addError(Strings.passwordChallenge);
        }
      }

  );

  final validateCode = StreamTransformer<String,String>.fromHandlers(
      handleData: (password,sink){
        if (password.length >= 1 ){
          sink.add(password);
        }else{
          sink.addError('Mas de 6 caracteres');
        }
      }

  );

  final validateNit = StreamTransformer<String,String>.fromHandlers(
      handleData: (nit,sink){
        if (nit.length == 10 ){
          sink.add(nit);
        }else{
          sink.addError('Debe contener 10 digitos');
        }
      }

  );


  final validatePhone = StreamTransformer<String,String>.fromHandlers(
      handleData: (phone,sink){


        Pattern pattern = r'^[0-9]{0,}$';
        RegExp regExp = new RegExp(pattern as String);


        if (phone.length ==10  && regExp.hasMatch(phone)){
          sink.add(phone);
        }else{
          sink.addError('Debe contener 10 caracteres');
        }
      }

  );



}