import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';


part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;


abstract class _LoginStore with Store{




  //email
  @observable
  String email="";

  @action
  void setEmail(String value)=> email=value;

  //senha
  @observable
  String password="";

  @action
  void setPassword(String value)=>password=value;

  //visibilidade da senha
  @observable
  bool passwordVisible = false;

  @action
  void togglePasswordVisibility()=>passwordVisible = !passwordVisible;

  //loading
  @observable
  bool loading = false;

  @action
  void login(){
    loading=true;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password).then((_){
          loading=false;
          loggedIn=true;
    });
  }

  //loggedin
  @observable
  bool loggedIn =false;

  //validação
  @computed
  String get isPasswordValid {
    if(password != null && password.length >5){
      return null;
    }else if(password==null||password.isEmpty){
      return "Campo Obrigatório";
    }else{
      return "Senha muito curta";
    }
  }

  @computed
  String get isEmailValid{
    if(email!=null && email.contains("@")){
      return null;
    }else if(email==null || email.isEmpty){
      return "Campo Obrigatório";
    }else{
      return "E-mail deve conter @";
    }
  }


  @computed
  Function get loginPressed=>
      (isEmailValid == null && isPasswordValid == null && !loading) ? login : null;

}