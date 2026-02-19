import 'package:fit_flow/core/utils/app_text_styles.dart';
import 'package:fit_flow/features/auth/presentation/controllers/login_controller/login_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/utils/app_colors.dart';
import '../../../../core/components/custom_app_bar.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_progress_hud.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/components/custom_text_form_field.dart';
import '../../../../core/route/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isObsecure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          showErrorSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
          inAsyncCall: state is LoginLoading,
          child: Scaffold(
            appBar: buildCustomAppBar(context, title: "Login"),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        CustomTextFormField(
                          label: "Email",
                          controller: emailController,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextFormField(
                          label: "Password",
                          controller: passwordController,
                          obscureText: isObsecure,
                          suffixIcon: IconButton(
                            icon: isObsecure
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: AppColors.primaryColor,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: AppColors.primaryColor,
                                  ),
                            onPressed: () {
                              setState(() {
                                isObsecure = !isObsecure;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Reset Password?",
                              style: AppTextStyles.bold13.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        CustomButton(
                          text: "Login",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Don’t have an account? ',
                                style: AppTextStyles.bold16.copyWith(
                                  color: const Color(0xFF949D9E),
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.signup,
                                    );
                                  },
                                text: 'Sign Up',
                                style: AppTextStyles.bold16.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
