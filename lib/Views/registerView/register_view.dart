import 'package:flutter/material.dart';

import '../../Controller/Repositories/user_auth_repo.dart';
import '../Widgets/custom_text_field.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final formKey = GlobalKey<FormState>();
  final emlCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confpassCrtl = TextEditingController();
  var btnState = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 25),
                    )),
                const SizedBox(
                  height: 10,
                ),
                const FlutterLogo(
                  size: 150,
                  style: FlutterLogoStyle.stacked,
                ),
                CustomTextField(controler: emlCtrl, hint: 'Email'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(controler: passCtrl, hint: "password"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controler: confpassCrtl, hint: "confirm password"),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      btnState.value = !btnState.value;
                      await UserAuthRepo.register(
                          context, emlCtrl.text.trim(), passCtrl.text.trim());
                      emlCtrl.clear();
                      passCtrl.clear();
                      confpassCrtl.clear();
                      btnState.value = !btnState.value;
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(150, 30)),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: btnState,
                      builder: (context, value, child) {
                        if (value) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else {
                          return const Text("Register");
                        }
                      }),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("already have an account? "),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Login'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
