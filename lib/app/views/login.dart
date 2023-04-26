import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
        color: Colors.black, 
        fontSize: 24,),
        title: Text('iT\nServiços Itinerantes', textAlign: TextAlign.center),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 50)),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Digite seu e-mail', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Você precisa digitar um e-mail';
                  } return null;
                },
              ),
              
              Padding(padding: EdgeInsets.only(top: 50)),
              
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Digite sua senha', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Você precisa digitar uma senha';
                  }
                  if(value.length < 4) {
                    return 'Senha muito curta. (Pelo menos 5 caracteres)';
                  } 
                  return null;
                },
              ),
              
              Padding(padding: EdgeInsets.only(top: 50)),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: Text('Entrar', style: TextStyle(color: Colors.black),),
                onPressed: () {
                  if(_formKey.currentState!.validate()) {

                  }
                },
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Image(image: AssetImage('assets/image6.png'))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}