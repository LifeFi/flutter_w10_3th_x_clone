import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/interests_screen_part1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isEyeOn = false;

  _onEyeTap() {
    setState(() {
      _isEyeOn = !_isEyeOn;
    });
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  bool _passwordValidator() {
    if (_passwordController.value.text.length >= 8) {
      return true;
    }
    return false;
  }

  _onSubmitTap() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const InterestsScreenPart1(),
        ),
        (route) => false);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: FaIcon(
            FontAwesomeIcons.twitter,
            size: Sizes.size36,
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              left: Sizes.size24,
              right: Sizes.size24,
              top: Sizes.size20,
              bottom: Sizes.size10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You'll need a password",
                style: TextStyle(
                  fontSize: Sizes.size28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gaps.v10,
              Text(
                "Make sure it's 8 characters or more.",
                style: TextStyle(
                  fontSize: Sizes.size18,
                  color: Colors.grey.shade700,
                ),
              ),
              Gaps.v20,
              TextField(
                controller: _passwordController,
                obscureText: !_isEyeOn,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(
                    fontSize: Sizes.size24,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorStyle: const TextStyle(height: 0),
                  suffix: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _onEyeTap,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                padding: EdgeInsets.symmetric(horizontal: 5),
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
              ),
              const Spacer(),
              GestureDetector(
                onTap: _passwordValidator() ? _onSubmitTap : () => {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  width: double.maxFinite,
                  alignment: const Alignment(0, 0),
                  decoration: BoxDecoration(
                    color: _passwordValidator() ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gaps.v10,
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
