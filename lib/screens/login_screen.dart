
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desafio/google_sign_in.dart';
import 'package:flutter_desafio/screens/home_screen.dart';
import 'package:flutter_desafio/screens/register_screen.dart';
import 'package:flutter_desafio/stores/login_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginStore loginStore = LoginStore();

  bool _passVisible = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
   /* autorun((_){
      if(loginStore.loggedIn){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_)=>HomeScreen())
        );
      }
    });
    
    */
    //1 monitorar valro
    disposer = reaction((_)=>loginStore.loggedIn,
        (loggedIn){
          if(loginStore.loggedIn){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_)=>HomeScreen())
            );
          }
        });
  }

  ReactionDisposer disposer;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.brown[200]
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: Image.asset(
                      "assets/logo-small.png",fit: BoxFit.cover,

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Observer(
                      builder: (_){
                        return TextField(
                          enabled: !loginStore.loading,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "E-mail",
                              filled: true,
                              fillColor: Colors.white,
                              errorText: loginStore.isEmailValid,
                              border: OutlineInputBorder()
                          ),
                          onChanged: loginStore.setEmail,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Observer(
                              builder: (_){
                                return TextField(
                                  enabled: !loginStore.loading,
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  obscureText: loginStore.passwordVisible ==true ? false : true,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      errorText: loginStore.isPasswordValid,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      suffix: IconButton(
                                        onPressed: loginStore.togglePasswordVisibility,
                                        icon: loginStore.passwordVisible == true ? Icon(Icons.visibility)
                                            :Icon(Icons.visibility_off),
                                      )
                                  ),
                                  onChanged: loginStore.setPassword,
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  Observer(
                    builder: (_){
                      return SizedBox(
                        width: 100,
                        child: FlatButton(
                          color: Colors.white,
                          child: loginStore.loading ? CircularProgressIndicator() :Text(
                            "Entrar",
                            style: TextStyle(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          onPressed: loginStore.loginPressed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)
                          ),
                        ),
                      );
                    },
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => RegisterScreen()
                      ));
                    },
                    child: Text(
                      "Não tem conta? cadastre-se",
                      style: TextStyle(
                          color: Colors.indigoAccent
                      ),
                    ),
                  ),
                  //botão de logar com google
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: (){
                        signInWithGoogle().whenComplete((){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context)=> HomeScreen()
                              )
                          );
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(color: Colors.black)
                      ),
                      highlightElevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(image: AssetImage("assets/google_logo.png"),height: 35,),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Login com Google",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
