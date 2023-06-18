import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUserName(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('usuarios').doc(userId).get();

    String nomeUsuario = snapshot.get('nome');

    return nomeUsuario;
  }
}
