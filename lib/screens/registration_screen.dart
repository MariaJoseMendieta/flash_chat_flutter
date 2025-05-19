import 'package:flash_chat_flutter/constants.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static String id =
      'registration_screen'; //Identificador estático para navegación

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Instancia de FirebaseAuth para usar en el registro
  final _auth = FirebaseAuth.instance;
  //Controla la visibilidad del spinner de carga
  bool showSpinner = false;
  //Variables para guardar email y contraseña ingresados por el usuario
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //ModalProgressHUD muestra spinner cuando showSpinner es true
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                //Hero para animación compartida del logo
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(height: 48.0),
              //Campo para ingresar el email
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value; //Guardar email ingresado
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 8.0),
              //Campo para ingresar la contraseña
              TextField(
                obscureText: true, //Oculta el texto (contraseña)
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value; //Guardar contraseña ingresada
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 24.0),
              //Botón personalizado para registrarse
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true; //Mostrar spinner
                  });
                  try {
                    //Crear usuario con email y contraseña en Firebase
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    //Si el registro fue exitoso, navegar a la pantalla de chat
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false; //Ocultar spinner
                    });
                  } catch (e) {
                    //En caso de error, imprimir en consola
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
