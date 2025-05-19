import 'package:flutter/material.dart';

//Widget personalizado para un botón con bordes redondeados
class RoundedButton extends StatelessWidget {
  //Constructor con parámetros requeridos para color, texto y función al presionar
  const RoundedButton({
    super.key,
    required this.colour,
    required this.title,
    required this.onPressed,
  });
  final Color colour; //Color del botón (fondo)
  final String title; //Texto que aparecerá dentro del botón
  final VoidCallback
  onPressed; //Función que se ejecuta cuando se presiona el botón

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      //Material widget para aplicar elevación (sombra) y color de fondo con bordes redondeados
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        //Botón material que recibe el gesto onPressed y el tamaño mínimo
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          //Texto visible dentro del botón
          child: Text(title, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
