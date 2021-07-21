class ResponseEfecty {
  ResponseEfecty({
    this.refPayco,
    this.factura,
    this.descripcion,
    this.valor,
    this.iva,
    this.baseiva,
    this.moneda,
    this.banco,
    this.estado,
    this.respuesta,
    this.autorizacion,
    this.recibo,
    this.fecha,
    this.tipoDoc,
    this.documento,
    this.nombres,
    this.apellidos,
    this.email,
    this.pin,
    this.codigoproyecto,
    this.fechaexpiracion,
    this.fechapago,
    this.valorPesos,
  });

  String refPayco;
  String factura;
  String descripcion;
  String valor;
  String iva;
  String baseiva;
  String moneda;
  String banco;
  String estado;
  String respuesta;
  String autorizacion;
  String recibo;
  DateTime fecha;
  String tipoDoc;
  String documento;
  String nombres;
  String apellidos;
  String email;
  String pin;
  String codigoproyecto;
  DateTime fechaexpiracion;
  DateTime fechapago;
  String valorPesos;

  factory ResponseEfecty.fromJson(Map<String, dynamic> json) => ResponseEfecty(
    refPayco: json["ref_payco"].toString(),
    factura: json["factura"].toString(),
    descripcion: json["descripcion"],
    valor: json["valor"],
    iva: json["iva"],
    baseiva: json["baseiva"].toString(),
    moneda: json["moneda"],
    banco: json["banco"],
    estado: json["estado"],
    respuesta: json["respuesta"],
    autorizacion: json["autorizacion"],
    recibo: json["recibo"].toString(),
    fecha: DateTime.parse(json["fecha"]),
    tipoDoc: json["tipo_doc"],
    documento: json["documento"],
    nombres: json["nombres"],
    apellidos: json["apellidos"],
    email: json["email"],
    pin: json["pin"].toString(),
    codigoproyecto: json["codigoproyecto"].toString(),
    fechaexpiracion: DateTime.parse(json["fechaexpiracion"]),
    fechapago: DateTime.parse(json["fechapago"]),
    valorPesos: json["valor_pesos"],
  );

  Map<String, dynamic> toJson() => {
    "ref_payco": refPayco,
    "factura": factura,
    "descripcion": descripcion,
    "valor": valor,
    "iva": iva,
    "baseiva": baseiva,
    "moneda": moneda,
    "banco": banco,
    "estado": estado,
    "respuesta": respuesta,
    "autorizacion": autorizacion,
    "recibo": recibo,
    "fecha": fecha.toIso8601String(),
    "tipo_doc": tipoDoc,
    "documento": documento,
    "nombres": nombres,
    "apellidos": apellidos,
    "email": email,
    "pin": pin,
    "codigoproyecto": codigoproyecto,
    "fechaexpiracion": fechaexpiracion.toIso8601String(),
    "fechapago": fechapago.toIso8601String(),
    "valor_pesos": valorPesos,
  };
}
