import 'package:chat_app/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    labelText: 'Enter Nickname',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("nickname can't be empty"),
                      ));
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return MainScreen(
                            nickname: int.tryParse(controller.text) ?? 0);
                      }),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward))
            ],
          ),
        ),
      ),
    );
  }
}
