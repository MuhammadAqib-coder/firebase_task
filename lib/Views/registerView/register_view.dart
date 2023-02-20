import 'package:firebase_task/Views/Utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Controller/Repositories/user_auth_repo.dart';
import '../Widgets/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _usernameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();
  var psdVisibility = ValueNotifier<bool>(false);
  var cpsdVisibility = ValueNotifier<bool>(false);

  var btnState = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70.h,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign Up",
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
                        obseCure: false,
                        suffixIcon: Container(
                          height: 0,
                          width: 0,
                        ),
                        prefixIcon: Icons.person,
                        inputType: TextInputType.name,
                        controler: _nameController,
                        hint: "Name"),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextField(
                        obseCure: false,
                        prefixIcon: Icons.person,
                        suffixIcon: Container(
                          height: 0,
                          width: 0,
                        ),
                        inputType: TextInputType.emailAddress,
                        controler: _usernameController,
                        hint: 'username with @'),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextField(
                        obseCure: false,
                        suffixIcon: Container(
                          height: 0,
                          width: 0,
                        ),
                        prefixIcon: Icons.mail,
                        inputType: TextInputType.emailAddress,
                        controler: _emailController,
                        hint: 'Email'),
                    SizedBox(
                      height: 10.h,
                    ),
                    ValueListenableBuilder(
                        valueListenable: psdVisibility,
                        builder: (_, value, child) {
                          return CustomTextField(
                              obseCure: value,
                              inputType: TextInputType.visiblePassword,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    psdVisibility.value = !psdVisibility.value;
                                  },
                                  icon: Icon(
                                    value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.blue,
                                  )),
                              prefixIcon: Icons.lock,
                              controler: _passwordController,
                              hint: "password");
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    ValueListenableBuilder(
                        valueListenable: cpsdVisibility,
                        builder: (_, value, child) {
                          return CustomTextField(
                              obseCure: value,
                              inputType: TextInputType.visiblePassword,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cpsdVisibility.value =
                                        !cpsdVisibility.value;
                                  },
                                  icon: Icon(
                                    value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.blue,
                                  )),
                              prefixIcon: Icons.lock,
                              controler: _confirmPasswordController,
                              hint: "confirm password");
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    ElevatedButton(
                      onPressed: userRegister,
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 30)),
                      child: ValueListenableBuilder<bool>(
                          valueListenable: btnState,
                          builder: (context, value, child) {
                            if (value) {
                              return const CircularProgressIndicator(
                                color: Colors.blue,
                              );
                            } else {
                              return const Text("Register");
                            }
                          }),
                    ),
                    SizedBox(
                      height: 30.h,
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
        ),
      ),
    );
  }

  userRegister() async {
    if (formKey.currentState!.validate()) {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        btnState.value = !btnState.value;
        await UserAuthRepo.register(
            context,
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
            _usernameController.text.trim());
        _emailController.clear();
        _nameController.clear();
        _confirmPasswordController.clear();
        _passwordController.clear();
        _usernameController.clear();
        btnState.value = !btnState.value;
      } else {
        showSnackbar(context, 'password not match');
      }
    }
  }
}
