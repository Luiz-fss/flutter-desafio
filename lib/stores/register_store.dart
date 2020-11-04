import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStore with _$RegisterStore;

abstract class _RegisterStore with Store{

  @observable
  bool loading = false;

  //observers
  @observable
  String name="";

  @action
  void setName(String value)=> name=value;

  @observable
  String email="";
  @action
  void setEmail(String value)=>email=value;
  @observable
  String password = "";

  @action
  void setPassword(String value)=> password = value;

  @computed
  String get validName{
    if(name!=null && name.length>4){
      return null;
    }else if(name == null || name.isEmpty){
      return "Campo Obrigatório";
    }else{
      return "Nome curto";
    }
  }

  @computed
  String get validEmail{
    if(email!=null && email.contains("@")){
      return null;
    }else if(email==null || email.isEmpty){
      return "Campo Obrigatório";
    }else{
      return "E-mail deve conter @";
    }
  }

  @computed
  String get validPassword{
    if(password != null && password.length > 5){
      return null;
    }else if(password == null || password.isEmpty){
      return "Campo Obrigatório";
    }else{
      return "Senha curta";
    }
  }

  @action
  void singIn(){
    loading = true;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((_){
      loading=false;

      loggedIn=true;
    });
  }

  @computed
  Function get loginPressed=>
      (validEmail == null && password == null && !loading) ? singIn : null;


  @observable
  bool passwordVisible = false;

  @action
  void togglePasswordVisibility()=>passwordVisible = !passwordVisible;

  @observable
  bool loggedIn = false;
}