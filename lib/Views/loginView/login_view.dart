import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_task/Controller/Repositories/user_auth_repo.dart';
import 'package:firebase_task/Views/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      // resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Form(
          key: formKey,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 70.h,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 25.sp),
                  )),
              SizedBox(
                height: 10.h,
              ),
              FlutterLogo(
                size: 150.sp,
                style: FlutterLogoStyle.stacked,
              ),
              CustomTextField(
                  inputType: TextInputType.emailAddress,
                  controler: emlCtrl,
                  prefixIcon: Icons.mail,
                  hint: 'Email'),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                  obseCure: true,
                  suffixIcon: Icon(Icons.visibility),
                  prefixIcon: Icons.lock,
                  inputType: TextInputType.visiblePassword,
                  controler: passCtrl,
                  hint: "password"),
              SizedBox(
                height: 20.h,
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
                    fixedSize: Size(150.w, 30.h), backgroundColor: Colors.blue),
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
              SizedBox(
                height: 30.h,
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
    );
  }
}
