import 'dart:io';

void main () async {

  String nome = "David";
  Future<String> cepFuturo = getCepName("Rua JK");
  late String cep;

//  cepFuturo.then((result) => cep =result);
cep = await cepFuturo;
  print(cep);

}


//external service
Future<String> getCepName(String nome){
  return Future.value("89478474");
}