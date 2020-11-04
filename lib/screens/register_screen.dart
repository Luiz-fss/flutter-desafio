
import 'package:flutter/material.dart';
import 'package:flutter_desafio/screens/home_screen.dart';
import 'package:flutter_desafio/screens/login_screen.dart';
import 'package:flutter_desafio/stores/register_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ReactionDisposer disposer;

  RegisterStore registerStore = RegisterStore();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    disposer = autorun((_){
      if(registerStore.loggedIn==true){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context)=>HomeScreen())
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Fazer Cadastro"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Observer(
                  builder: (_){
                    return TextField(
                      decoration: InputDecoration(
                          hintText: "Nome",
                          errorText: registerStore.validName
                      ),
                      onChanged: registerStore.setName,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Observer(
                  builder: (_){
                    return TextField(
                      decoration: InputDecoration(
                          hintText: "E-mail",
                          errorText: registerStore.validEmail
                      ),
                      onChanged: registerStore.setEmail,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Observer(
                  builder: (_){
                    return TextField(
                      enabled: !registerStore.loading,
                      obscureText: registerStore.passwordVisible ==true ? false : true,
                      decoration: InputDecoration(
                          hintText: "Senha",
                          errorText: registerStore.validPassword,
                          suffix: IconButton(
                            onPressed: registerStore.togglePasswordVisibility,
                            icon: registerStore.passwordVisible == true ? Icon(Icons.visibility)
                                :Icon(Icons.visibility_off),
                          )
                      ),
                      onChanged: registerStore.setPassword,
                    );
                  },
                ),
              ),
              Observer(
                builder: (_){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: registerStore.loading ?CircularProgressIndicator() : Text(
                        "Cadastrar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: registerStore.loginPressed,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
