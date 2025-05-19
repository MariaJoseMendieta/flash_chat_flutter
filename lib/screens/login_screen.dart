import 'package:flash_chat_flutter/constants.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String id = 'login_screen'; //Identificador estático para navegación

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Instancia para autenticación con Firebase
  final _auth = FirebaseAuth.instance;
  //Variable para mostrar o esconder el spinner de carga
  bool showSpinner = false;
  //Variables para guardar los valores ingresados por el usuario
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //ModalProgressHUD muestra un spinner encima del contenido cuando showSpinner es true
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                //Hero widget para animación entre pantallas
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
                  email =
                      value; //Guardar el valor ingresado en la variable email
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText:
                      'Enter your email', // Texto de sugerencia dentro del campo
                ),
              ),
              SizedBox(height: 8.0),
              //Campo para ingresar la contraseña
              TextField(
                obscureText: true, //Oculta el texto para seguridad
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value; // Guardar el valor ingresado en password
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 24.0),
              //Botón personalizado redondeado para iniciar sesión
              RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async {
                  //Mostrar spinner mientras se realiza el proceso de login
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    //Intentar hacer login con Firebase usando email y password
                    final user = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    //Si el usuario no es nulo, navegar a la pantalla de chat
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    //Ocultar spinner después de la operación
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    //En caso de error imprimir en consola
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
