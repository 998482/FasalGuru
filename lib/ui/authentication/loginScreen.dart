import 'package:fasalguru/ui/Widgets/Custom_form_field.dart';
import 'package:fasalguru/ui/Widgets/Custom_password_firld.dart';
import 'package:fasalguru/ui/Widgets/Custom_Big_Button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool obscurePassword = true;
  bool isChecked = false;
  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login(String email, String password) {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

  

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height * 0.9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    "assets/images/AppLogo.png",
                    width: 160,
                    height: 160,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Login to your account",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFormField(
                        controller: email,
                        hintText: "Email",
                        prefixicon: Image.asset(
                          "assets/images/email.png",
                          height: 17,
                          width: 18,
                        ),
                        color: colorScheme.surface,
                        obscuretext: false,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your email";
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value.trim())) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      CustomPasswordField(
                        controller: password,
                        hintText: "Password",
                        prefixicon: Image.asset(
                          "assets/images/lock.png",
                          width: 17,
                          height: 17,
                        ),
                        color: colorScheme.surface,
                        obscuretext: obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is empty";
                          } else if (value.length < 6) {
                            return "Password too weak";
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                            color: colorScheme.onSurface
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: colorScheme.primary,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text(
                      "Remember me",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.push('/forget');
                        // context.push(Approutes.forget);
                      },
                      child: Text(
                        "Forgot password?",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : CustomButton(
                        text: "Log in",
                        primaryColor: colorScheme.primary,
                        pressed: () {
                          login(email.text, password.text);
                        },
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/signup');
                        // context.push(Approutes.signup);
                      },
                      child: Text(
                        "Sign Up",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}