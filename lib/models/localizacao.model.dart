class Localizacao {
  final int codLocalizacao;
  final double latitude;
  final double longitude;
  final String codUsuario;
  final DateTime dataHoraCad;
  final double velocidade;

  const Localizacao(
      {required this.codLocalizacao,
      required this.latitude,
      required this.longitude,
      required this.codUsuario,
      required this.dataHoraCad,
      required this.velocidade});

  factory Localizacao.fromJson(Map<String, dynamic> json) {
    return Localizacao(
      codLocalizacao: json['codLocalizacao'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      codUsuario: json['codUsuario'],
      dataHoraCad: json['dataHoraCad'],
      velocidade: json['velocidade'],
    );
  }
}
