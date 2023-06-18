import 'package:appprojetoitinerante/app/views/cadastro.dart';
import 'package:appprojetoitinerante/app/views/home_page.dart';
import 'package:appprojetoitinerante/app/views/lista_contatos.dart';
import 'package:appprojetoitinerante/app/views/login.dart';
import 'package:appprojetoitinerante/app/views/perfil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/views/lista_ordem_servico.dart';
import 'app/views/resultado_busca.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    if(Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'appprojetoitinerante',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home_page':(context) => const HomePage(),
        '/login':(context) => const LoginPage(),
        '/cadastro':(context) => const CadastroPage(),
        '/busca':(context) => BuscaPage(buscar: '', selectedService: '',),
        '/lista_contatos':(context) => ContactsPage(currentUserUid: '',),
        'lista_ordem_servico':(context) => ListaOrdensServicoPage(userId: '',),
        '/perfil':(context) => PerfilPage(),
        
      },
      initialRoute: '/login',
    );
    
  }
  
}