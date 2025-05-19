import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Instancia global de Firestore para acceder a la base de datos
final _firestore = FirebaseFirestore.instance;
//Usuario que ha iniciado sesión actualmente
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  //Identificador estático para facilitar la navegación
  static String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //Controlador para manejar el contenido del TextField donde se escribe el mensaje
  final messageTextController = TextEditingController();
  //Instancia del servicio de autenticación de Firebase
  final _auth = FirebaseAuth.instance;
  //Variable para guardar temporalmente el texto del mensaje que escribe el usuario
  String? messageText;

  @override
  void initState() {
    super.initState();
    //Obtener el usuario que ha iniciado sesión al cargar la pantalla
    getCurrentUser();
  }

  //Metodo para obtener el usuario actual desde Firebase Auth
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              //Cierra sesión cuando se presiona el botón de cerrar
              _auth.signOut();
              //Regresa a la pantalla anterior (login)
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(), //Widget que muestra el listado de mensajes
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:
                          messageTextController, //Controla el texto escrito
                      onChanged: (value) {
                        //Guardar el texto en la variable cuando cambia
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Solo enviar si hay texto no vacío
                      if (messageText != null &&
                          messageText!.trim().isNotEmpty) {
                        //Añadir el mensaje a la colección 'messages' en Firestore
                        _firestore.collection('messages').add({
                          'text': messageText!.trim(), //Mensaje escrito
                          'sender': loggedInUser!.email, //Email del remitente
                          'timestamp':
                              FieldValue.serverTimestamp(), //Marca de tiempo automática del servidor
                        });
                      }
                      //Limpiar el campo de texto después de enviar
                      messageTextController.clear();
                      messageText = null; //Resetear variable temporal
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Widget para mostrar la lista de mensajes en tiempo real
class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //Escucha la colección 'messages' ordenada por 'timestamp' para actualizaciones en tiempo real
      stream:
          _firestore
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .snapshots(),
      builder: (context, snapshot) {
        //Mostrar indicador de carga mientras no hay datos
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        //Acceder a los documentos recibidos de Firestore
        final messages =
            snapshot
                .data!
                .docs
                .reversed; //Invertir para mostrar mensajes recientes abajo
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text']; //Texto del mensaje
          final messageSender = message['sender']; //Email del remitente

          final currentUser =
              loggedInUser!.email; //Usuario actual para comparar

          //Crear burbuja de mensaje personalizada
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe:
                currentUser ==
                messageSender, //El mensaje será del usuario conectado
          );
          messageBubbles.add(messageBubble);
        }

        //Mostrar la lista de mensajes dentro de una ListView invertida para que los mensajes más recientes estén abajo
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

//Widget para mostrar cada mensaje individual con estilo diferenciado
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
  });

  final String sender; //Email del remitente
  final String text; //Contenido del mensaje
  final bool isMe; //Indica si el mensaje es del usuario actual

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        //Alinea el mensaje a la derecha si es del usuario o a la izquierda si es de otro
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          //Mostrar el email del remitente encima del mensaje
          Text(sender, style: TextStyle(fontSize: 12.0, color: Colors.black54)),
          Material(
            //Burbuja con bordes redondeados y color diferente según remitente
            borderRadius:
                isMe
                    ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    )
                    : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
