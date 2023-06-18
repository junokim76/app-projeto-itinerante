import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ordem_servico.dart';


class ChatPage extends StatefulWidget {
  final String nomeUsuario;
  final String userId;

  const ChatPage({Key? key, required this.nomeUsuario, required this.userId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserUid => _auth.currentUser!.uid;
  String get recipientUserId => widget.userId;

  Future<void> _sendMessage() async {
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('messages').add({
        'message': message,
        'participants': [currentUserUid, recipientUserId],
        'timestamp': FieldValue.serverTimestamp(), // Adiciona o campo de timestamp com o valor do servidor
      });

      setState(() {
        _messageController.clear();
      });
    }
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  void _goToOrderServicePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdemServicoPage(userId: recipientUserId,), // Substitua OrderServicePage pelo nome da sua página de ordem de serviço
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _clearMessages(); // Limpar as mensagens ao iniciar a conversa
  }

  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != recipientUserId) {
      _clearMessages(); // Limpar as mensagens ao alterar o usuário
    }
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
        title: const Text('iT\nServiços Itinerantes', textAlign: TextAlign.center),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('participants', arrayContains: currentUserUid)
                  .orderBy('timestamp') // Ordena as mensagens pelo campo de timestamp
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;

                  _messages = messages
                      .where((doc) {
                    final participants = doc['participants'] as List<dynamic>;
                    return participants.length == 2 &&
                        participants.contains(currentUserUid) &&
                        participants.contains(recipientUserId);
                  })
                      .map((doc) => Map<String, dynamic>.from(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> message = _messages[index];
                      bool isCurrentUserMessage = message['participants'][0] == currentUserUid;

                      return Align(
                        alignment: isCurrentUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isCurrentUserMessage ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message['message'] as String,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox(); // Retorna um widget vazio se não houver dados
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Enviar mensagem',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _goToOrderServicePage,
                  child: Text('Ir para a ordem de serviço', style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
