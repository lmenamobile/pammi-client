import 'package:flutter/material.dart';


class Constants {
//EstoEsPAmii
  //*------DEV------*//*
  /*static const String baseURL = 'http://devapiappclient.pamii.com:50011/v1/';
  static const String urlBlog = 'http://devblog.pamii.com/';
  static const String urlSocket = 'http://devapisupersocket.pamii.com';
  static const String profileProvider = 'https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/chats/ic_proveedor.png';
  static const String profileAdmin = 'https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/chats/ic_pami.png';*/
  //*------------*/

  //static const Str /*------staging------*/
  /*  static const String baseURL = 'http://stagingapiappclient.pamii.com:50011/v1/';
     static const String urlBlog = 'http://stagingblog.pamii.com/';
     static const String urlSocket = 'http://stagingapisupersocket.pamii.com';
     static const String profileProvider = 'https://pamii-staging.s3.us-east-2.amazonaws.com/wawamko/chats/ic_proveedor.png';
     static const String profileAdmin = 'https://pamii-staging.s3.us-east-2.amazonaws.com/wawamko/chats/ic_pami.png';
  // /*------------*/ing baseURL = 'https://apiappclient.pamii.com/v1/';*/

    /*------Prod------*/
 static const String baseURL = 'https://apiappclient.estoespamii.com/v1/';
  static const String urlBlog = 'http://devblog.estoespamii.com/';
  static const String urlSocket = 'http://apisupersocket.estoespamii.com';
  static const String profileProvider = 'https://pamii-preproduction.s3.amazonaws.com/pamii/chats/ic_proveedor.png';
  static const String profileAdmin = 'https://pamii-preproduction.s3.amazonaws.com/pamii/chats/ic_pami.png';
     /*------------*/

  static const String key_encrypt = 'ebfe48f81df787193c75c1ffacd88a07';
  static const String googleApyKey = "AIzaSyD7A_ZNm_XLyEuB3b3euemKAdTwOtoFeHQ";
  static const String pwdSocialNetwork = 'Kubo123*';
  static const String urlGuide = 'https://www.servientrega.com/wps/portal/rastreo-envio/detalle?id=';

  static const String loginGMAIL = 'gm';
  static const String versionApp = '1.0.6';//1.1.7
  static const String loginFacebook = 'fb';
  static const String codeAccountNotValidate = '103';

  static const int isViewRegister = 0;
  static const int isViewPassword = 1;
  static const int isViewLogin = 2;
  static const int isRegisterRS = 0;

  static const String bannerGeneral = 'ex';
  static const String bannerOffer = 'in';

  static const int qualificationProvider = 0;
  static const int qualificationProduct = 1;
  static const int qualificationSeller = 2;

  /*Tipos de ofertas*/
  static const String offersUnits = 'units';
  static const String offersMix = 'mixed';

    /*payment methods*/
    static const int paymentCreditCard = 1;
    static const int paymentCash = 2;
    static const int paymentBaloto = 3;
    static const int paymentEfecty = 4;
    static const int paymentPSE = 5;
    static const int paymentADDI = 6;

    /*Status order*/
    static const String create = 'Creado';
    static const String cancel = 'Cancelado';
    static const String completed = 'Entregado';
    static const String processing = 'Alistamiento';
    static const String restored = 'Devuelto';
    static const String send = 'Enviado';
    static const String finish = 'Finalizado';

  /*Status claim*/
  static const String open = 'Pendiente';
  static const String close = 'Cerrado';
  static const String approved = 'Aprobado';
  static const String reject = 'Rechazado';
  static const String applyClaim = 'apply';


  /*Tipos de chat*/
  static const String typeSeller = 'seller';
  static const String typeProvider = 'provider';
  static const String typeAdmin = 'admin';

  /*urls transaction*/
  static const String finishTransaction = "pamii.com";

  /*Opciones Menu izquierdo*/
  static const String menuFavorites     = 'favorites';
  static const String menuProfile       = 'profile';
  static const String menuOffersTheDay  = 'offersDay';
  static const String menuHighlights    = 'highlights';
  static const String menuHome          = 'home';
  static const String menuNotifications = 'Notifications';
  static const String menuSupport       = 'support';
  static const String menuGiftCard       = 'giftCard';
  static const String menuTraining       = 'training';
  static const String menuCustomerService = 'customerService';

  /*Tipo de notificacion*/
  static const String notificationOrder     = 'order';

    /*Tipo de documento*/
    static const String cc           = 'cc';
    static const String passport     = 'pa';
    static const String ce           = 'ce';

  /*Locale*/
  static const String localeES = 'es_CO';


  static const String apiGetThemes = '';
  static const String apiGetPqrs = 'pqrs/get-pqrs';
  static const String apiCreatePqrs = 'pqrs/create-pqrs';
  static const String apiGetQuestionsBySubtheme = baseURL+'system-client-service/get-questions';

}