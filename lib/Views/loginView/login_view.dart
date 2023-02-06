import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_task/Controller/Repositories/user_auth_repo.dart';
import 'package:firebase_task/Views/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final emlCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  var state = ValueNotifier<bool>(false);
  var googleState = ValueNotifier<bool>(false);
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
                      "Sign In",
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
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      state.value = !state.value;
                      await UserAuthRepo.login(
                          context, emlCtrl.text.trim(), passCtrl.text.trim());
                      emlCtrl.clear();
                      passCtrl.clear();
                      state.value = !state.value;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 30),
                      backgroundColor: Colors.blue),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: state,
                      builder: (context, value, child) {
                        if (value) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else {
                          return const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          );
                        }
                      }),
                ),
                const SizedBox(
                  height: 30,
                ),
                ValueListenableBuilder(
                    valueListenable: googleState,
                    builder: (context, value, _) {
                      return GoogleAuthButton(
                        isLoading: value,
                        onPressed: () async {
                          googleState.value = !googleState.value;
                          await UserAuthRepo.googleAuth(context);
                          googleState.value = !googleState.value;
                        },
                      );
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("don't have an account? "),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register_view');
                        },
                        child: const Text('Register'))
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
