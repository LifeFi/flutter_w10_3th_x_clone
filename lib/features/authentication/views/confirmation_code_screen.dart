import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/password_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfirmationCodeScreen extends StatefulWidget {
  final String email;
  const ConfirmationCodeScreen({
    super.key,
    this.email = "runlearn@sendpotion.com",
  });

  @override
  State<ConfirmationCodeScreen> createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  _onSubmitTap() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const PasswordScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            bottom: Sizes.size10
            // bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "We sent you a code",
                style: TextStyle(
                  fontSize: Sizes.size28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gaps.v10,
              Text(
                "Enter it below to verify",
                style: TextStyle(
                  fontSize: Sizes.size18,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "${widget.email}.",
                style: TextStyle(
                  fontSize: Sizes.size18,
                  color: Colors.grey.shade700,
                ),
              ),
              Gaps.v20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < 6; i++)
                    SizedBox(
                      width: Sizes.size28,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          // print(_formKey.currentState!.validate());

                          if (value.length == 1) {
                            i < 5
                                ? FocusScope.of(context).nextFocus()
                                : FocusScope.of(context).unfocus();
                          }
                          setState(() {});
                        },
                        style: const TextStyle(
                          fontSize: Sizes.size32,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
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
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                      ),
                    ),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                height: 60,
                alignment: Alignment.center,
                child: _formKey.currentState != null &&
                        _formKey.currentState!.validate()
                    ? const FaIcon(
                        FontAwesomeIcons.solidCircleCheck,
                        color: Colors.green,
                        size: Sizes.size32,
                      )
                    : Container(),
              ),
              const Spacer(),
              Text(
                "Did't receive email?",
                style: TextStyle(
                    fontSize: Sizes.size18,
                    color: Theme.of(context).primaryColor),
              ),
              Gaps.v10,
              GestureDetector(
                onTap: _formKey.currentState != null &&
                        _formKey.currentState!.validate()
                    ? _onSubmitTap
                    : () => {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  width: double.maxFinite,
                  alignment: const Alignment(0, 0),
                  decoration: BoxDecoration(
                    color: _formKey.currentState != null &&
                            _formKey.currentState!.validate()
                        ? Colors.black
                        : Colors.grey.shade500,
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
            ],
          ),
        ),
      ),
    );
  }
}
