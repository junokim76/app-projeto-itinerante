import 'package:appprojetoitinerante/app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cadastro.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      if (userCredential.user != null) {
        // Se o login for bem-sucedido, você pode fazer qualquer processamento adicional ou navegar para a próxima tela
        print('Usuário logado com sucesso: ${userCredential.user!.uid}');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Caso contrário, exiba uma mensagem de erro
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro de Login'),
            content: const Text('Usuário ou senha inválidos. Tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Se ocorrer algum erro durante o login, você pode exibir uma mensagem de erro ou tomar outras ações
      print('Erro ao fazer login: $e');
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
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Digite seu e-mail',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Você precisa digitar um e-mail';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Digite sua senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Você precisa digitar uma senha';
                  }
                  if (value.length < 4) {
                    return 'Senha muito curta. (Pelo menos 5 caracteres)';
                  }
                  return null;
                },
                onChanged: (value) {
                  _password = value;
                },
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
              ),




              const SizedBox(height: 10),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Criar conta',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const CadastroPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
