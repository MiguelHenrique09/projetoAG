import 'dart:convert';

import 'package:projeto/model/classes/auth.dart';
import 'package:projeto/model/localstorage.dart';

class AuthController {
  static Future<void> gravaAutorizacao(String usuario, String token) async {
    Auth auth = new Auth(usuario: usuario, senha: '', token_autorizacao: token);
    //salvando produto na lista persistida
    await LocalStorageService.salvarAutorizacao(auth);
  }

  static Future<void> desgravaAutorizacao() async {
    await LocalStorageService.desgravarAutorizacao();
  }

  /**
   * função fake de autenticação na api de forma positiva
   */
  static Future<bool> verificaAutorizacaoOnline(Auth auth) async {
    //faço a chamada à API enviando o json do meu objeto de autorizacao
    //envio este json para a API para obter o token
    //json.encode(auth.toMap());

    //simula o retorno da api
    if (auth.usuario == '123456' && auth.senha == '123456') {
      Auth authApiRetorno = Auth(
        usuario: "fera",
        senha: '',
        token_autorizacao: "çalskdfsoiu23j́bdçvocuiyvhkjqerb-iudfhnsbdkljqghoi",
      );
      gravaAutorizacao(
        authApiRetorno.usuario,
        authApiRetorno.token_autorizacao,
      );
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> verificaAutorizacaoOffline() async {
    Auth? auth = await LocalStorageService.carregarAutorizacao();
    if (auth == null) return false;
    return true;
  }
}
