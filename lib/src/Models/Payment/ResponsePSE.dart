class ResponsePse {
  ResponsePse({
    this.refPayco,
    this.factura,
    this.descripcion,
    this.valor,
    this.iva,
    this.baseiva,
    this.moneda,
    this.estado,
    this.respuesta,
    this.autorizacion,
    this.recibo,
    this.fecha,
    this.urlbanco,
    this.transactionId,
    this.ticketId,
  });

  String? refPayco;
  String? factura;
  String? descripcion;
  String? valor;
  String? iva;
  String? baseiva;
  String? moneda;
  String? estado;
  String? respuesta;
  String? autorizacion;
  String? recibo;
  String? fecha;
  String? urlbanco;
  String? transactionId;
  String? ticketId;

  factory ResponsePse.fromJson(Map<String, dynamic> json) => ResponsePse(
    refPayco: json["ref_payco"].toString(),
    factura: json["factura"],
    descripcion: json["descripcion"],
    valor: json["valor"].toString(),
    iva: json["iva"].toString(),
    baseiva: json["baseiva"].toString(),
    moneda: json["moneda"],
    estado: json["estado"],
    respuesta: json["respuesta"],
    autorizacion: json["autorizacion"],
    recibo: json["recibo"],
    fecha: json["fecha"],
    urlbanco: json["urlbanco"],
    transactionId: json["transactionID"],
    ticketId: json["ticketId"],
  );

  Map<String, dynamic> toJson() => {
    "ref_payco": refPayco,
    "factura": factura,
    "descripcion": descripcion,
    "valor": valor,
    "iva": iva,
    "baseiva": baseiva,
    "moneda": moneda,
    "estado": estado,
    "respuesta": respuesta,
    "autorizacion": autorizacion,
    "recibo": recibo,
    "fecha": fecha,
    "urlbanco": urlbanco,
    "transactionID": transactionId,
    "ticketId": ticketId,
  };
}
