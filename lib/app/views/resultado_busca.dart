import 'package:appprojetoitinerante/app/models/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:appprojetoitinerante/app/views/chat_page.dart';
import 'package:appprojetoitinerante/app/models/chat_service.dart';

import '../componentes/menu_inferior.dart';

class BuscaPage extends StatefulWidget {
  final String buscar;

  const BuscaPage({Key? key, required this.buscar, required String selectedService}) : super(key: key);

  @override
  _BuscaPageState createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    buscarPorServico(widget.buscar);
  }

  void buscarPorServico(String nome) {
    if (nome.isEmpty) {
      _stream = _firestore.collection('usuarios').snapshots();
    } else {
      _stream = _firestore
          .collection('usuarios')
          .where('servico', isEqualTo: nome)
          .snapshots();
    }
  }

  void iniciarChat(String userId) async {
    ChatService chatService = ChatService();
    String nomeUsuario = await chatService.getUserName(userId);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(nomeUsuario: nomeUsuario, userId: userId,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
        title: const Text(
          'iT\nServiços Itinerantes',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.search),
                const SizedBox(
                  width: 8.0,
                ),
                const Text(
                  'Resultado da busca',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> usuarios = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      var nome = usuarios[index]['nome'];
                      var userId = usuarios[index].id;

                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Nome: $nome'),
                        onTap: () {
                          iniciarChat(userId);
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar os dados');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
