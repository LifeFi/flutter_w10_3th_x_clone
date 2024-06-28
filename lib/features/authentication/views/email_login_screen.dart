import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/view_models/email_login_view_model.dart';
import 'package:flutter_w10_3th_x_clone/features/settings/view_models/settings_view_model.dart';
import 'package:flutter_w10_3th_x_clone/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  EmailLoginScreenState createState() => EmailLoginScreenState();
}

class EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};
  bool _isEyeOn = false;
  bool _autoValidate = false;

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  _onEyeTap() {
    setState(() {
      _isEyeOn = !_isEyeOn;
    });
  }

  bool _emailValidator() {
    if (formData["email"] == null) return false;
    if (formData["email"]!.isNotEmpty) return true;

    return false;
  }

  bool _passwordValidator() {
    if (formData["password"] == null) return false;
    if (formData["password"]!.length >= 8) return true;

    return false;
  }

  void _onLoginTap() {
    setState(() {
      _autoValidate = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    print(formData);
    ref.read(emailLoginProvider.notifier).emailLogin(
          formData["email"]!,
          formData["password"]!,
          context,
        );
    setState(() {
      _autoValidate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref.watch(settingsProvider).themeMode);
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.only(
              left: Sizes.size20, right: Sizes.size20, bottom: Sizes.size32
              // bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: ListView(
                  children: [
                    const Center(
                      child: Opacity(
                        opacity: 0.7,
                        child: Text(
                          "English (US)",
                          style: TextStyle(
                            fontSize: Sizes.size18,
                          ),
                        ),
                      ),
                    ),
                    Gaps.v44,
                    Center(
                      child: Container(
                        width: Sizes.size80,
                        height: Sizes.size80,
                        padding: const EdgeInsets.all(Sizes.size12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(Sizes.size20),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/thread.svg',
                          colorFilter: ColorFilter.mode(
                            isDark ? Colors.black : Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    Gaps.v52,
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: "Mobile number or email",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                        labelText: "Mobile number or email",
                        labelStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(Sizes.size6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        suffix: _emailValidator()
                            ? const FaIcon(
                                FontAwesomeIcons.solidCircleCheck,
                                color: Colors.green,
                                size: Sizes.size32,
                              )
                            : null,
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      validator: (value) {
                        if (_autoValidate) {
                          if (value == null || value.isEmpty) {
                            return "Please write your email";
                          }
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null) {
                          formData["email"] = newValue;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          formData["email"] = value;
                        });
                      },
                    ),
                    Gaps.v16,
                    TextFormField(
                      textInputAction: TextInputAction.go,
                      obscureText: !_isEyeOn,
                      style: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        suffix: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: _onEyeTap,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: FaIcon(
                                    _isEyeOn
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    color: Colors.grey,
                                    size: Sizes.size28,
                                  ),
                                ),
                              ),
                              _passwordValidator()
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: FaIcon(
                                        FontAwesomeIcons.solidCircleCheck,
                                        color: Colors.green,
                                        size: Sizes.size28,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      validator: (value) {
                        if (_autoValidate) {
                          if (!_passwordValidator()) {
                            return "Please write your password";
                          }
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null) {
                          formData["password"] = newValue;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          formData["password"] = value;
                        });
                      },
                      onFieldSubmitted: (value) => _onLoginTap(),
                    ),
                    Gaps.v10,
                    GestureDetector(
                      onTap: _emailValidator() && _passwordValidator()
                          ? _onLoginTap
                          : null,
                      child: Stack(
                        children: [
                          Container(
                            height: Sizes.size64,
                            // width: Sizes.size96,
                            alignment: const Alignment(0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Sizes.size6),
                              color:
                                  !(_emailValidator() && _passwordValidator())
                                      ? Colors.grey.withOpacity(0.5)
                                      : ref.watch(emailLoginProvider).isLoading
                                          ? Colors.grey.withOpacity(0.5)
                                          : Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                color: _emailValidator() && _passwordValidator()
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: Sizes.size24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (ref.watch(emailLoginProvider).isLoading)
                            const Positioned(
                              left: Sizes.size20,
                              top: 0,
                              bottom: 0,
                              child: CircularProgressIndicator.adaptive(),
                            )
                        ],
                      ),
                    ),
                    Gaps.v10,
                    const Center(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // const Spacer(),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: Sizes.size80,
                  child: Column(
                    children: [
                      Container(
                        height: Sizes.size36,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          borderRadius: BorderRadius.circular(Sizes.size6),
                        ),
                        child: const Text(
                          "Create new Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Gaps.v10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.meta,
                            size: Sizes.size14,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          Text(
                            " Meta",
                            style: TextStyle(
                              fontSize: Sizes.size16,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        //
        /* bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: Sizes.size20,
            right: Sizes.size20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Sizes.size36,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size6),
                ),
                child: const Text(
                  "Create new Account",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Gaps.v10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.meta,
                    size: Sizes.size14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  Text(
                    " Meta",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Gaps.v32,
            ],
          ),
        ), */
      ),
    );
  }
}
