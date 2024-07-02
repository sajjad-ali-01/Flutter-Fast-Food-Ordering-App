import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
Container buttons(BuildContext context, bool isLogin, Function onTap, IconData? icon) {
  String buttonText = isLogin ? 'Log in' : 'Sign Up';
  Color buttonColor = isLogin ? Colors.deepPurpleAccent : Colors.cyan;

  // Define colors for Facebook and Google icons
  Color iconColor = icon == Icons.verified_outlined ? Color(0xFF4847F2) : // Facebook blue
  icon == Icons.g_translate ? Color(0xFF1877F2) : // Google blue
  Colors.white; // Default color (if no icon provided)

  // Concatenate the login method text with the button text if an icon is provided
  if (icon != null) {
    if(icon==Icons.verified_outlined){
      buttonText = 'Verify';
    }
    else if(icon == Icons.g_translate){
      buttonText = 'Continue with google';
    }

  }

  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 7, 5, 7),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
    ),
    child: ElevatedButton.icon(
      onPressed: () {
        onTap();
      },
      icon: icon != null ? Icon(
        icon,
        size: 24,
        color: iconColor,
      ) : SizedBox.shrink(),
      label: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return buttonColor;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    ),
  );
}