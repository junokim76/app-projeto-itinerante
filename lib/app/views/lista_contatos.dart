import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ContactsPage extends StatelessWidget {
  final String currentUserUid;

  const ContactsPage({Key? key, required this.currentUserUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .where('uid', isNotEqualTo: currentUserUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final nomeUsuario = user['nomeUsuario'];
                final userId = user['uid'];

                return StreamBuilder<QuerySnapshot>(
                  stream: hasConversation(currentUserUid, userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      // Exibir apenas os contatos com conversas em andamento
                      return ListTile(
                        title: Text(nomeUsuario),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                nomeUsuario: nomeUsuario,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox(); // Se não houver conversa em andamento, retorna um widget vazio
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar os contatos');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Stream<QuerySnapshot> hasConversation(String currentUserUid, String contactUserId) {
  final conversationRef = FirebaseFirestore.instance.collection('messages');
  return conversationRef
      .where('participants', arrayContainsAny: [currentUserUid, contactUserId])
      .snapshots();
}

}
