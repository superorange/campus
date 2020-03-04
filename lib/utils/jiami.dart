import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class JiaMi{
  static final parser = RSAKeyParser();

    static Future<String> jm(String text)async{
      final privateKeyString = await rootBundle.loadString('assets/pem/private.pem');
//      final publicKeyString =  await rootBundle.loadString('assets/pem/public.pem');

//      final publicKey = await parseKeyFromFile<RSAPublicKey>(publicKeyString);
//      final privateKey = await parseKeyFromFile<RSAPrivateKey>(privateKeyString);

//      final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));
      final privateKey = parser.parse(privateKeyString);

      final encrypter = Encrypter(RSA(privateKey: privateKey));

            var decTetx= encrypter.decrypt64(text);

//      return encrypter.decrypt(Encrypted.fromBase64(decoded));

      print(decTetx);
      return decTetx;
    }



}


