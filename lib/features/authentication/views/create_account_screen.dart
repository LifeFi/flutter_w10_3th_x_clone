import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/confirmation_code_screen.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/customizing_experience_screen.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccountScreen extends StatefulWidget {
  static const String routeName = "signup";
  static const String routeURL = "/signup";

  const CreateAccountScreen({
    super.key,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _birthdayController = TextEditingController();

  bool _isAgree = false;
  final bool _isEmail = true;
  bool _pickingDate = false;
  bool _writingEmail = false;
  DateTime initialDate = DateTime.now();
  bool _autoValidate = false;

  Map<String, String> formData = {};

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initialDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
    setState(() {
      _writingEmail = false;
      _pickingDate = false;
    });
  }

  void _showDatePicker() {
    setState(() {
      _pickingDate = true;
      _writingEmail = false;
    });
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      builder: (context) {
        return Container(
          height: 200.0,
          color: Colors.white,
          child: CupertinoDatePicker(
            maximumDate: initialDate,
            initialDateTime: initialDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: _setTextFieldDate,
            backgroundColor: Colors.white,
          ),
        );
      },
    ).then(
      (value) {
        _pickingDate = false;
      },
    );
  }

  _onSubmitTap() async {
    setState(() {
      _autoValidate = true;
    });

    if (!_isAgree) {
      _isAgree = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomizingExperienceScreen(),
            ),
          ) ??
          false;
      setState(() {});
    } else {
      if (_formKey.currentState != null) {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationCodeScreen(
                email: formData["email"]!,
              ),
            ),
          );
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       content: Text("$formData $_isAgree"),
          //     );
          //   },
          // );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 15,
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: Sizes.size20, fontWeight: FontWeight.w500),
                )),
          ),
          leadingWidth: 100,
          title: FaIcon(
            FontAwesomeIcons.twitter,
            size: Sizes.size36,
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: Sizes.size20,
              right: Sizes.size20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v32,
                  const Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: Sizes.size28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Gaps.v32,
                  TextFormField(
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                      labelText: "Name",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      suffix: formData["name"] != null &&
                              formData["name"]!.isNotEmpty
                          ? const FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: Colors.green,
                              size: Sizes.size32,
                            )
                          : null,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please write your name";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        formData['name'] = newValue;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['name'] = value;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _writingEmail = false;
                      });
                    },
                  ),
                  Gaps.v10,
                  TextFormField(
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Phone number or email address",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                      labelText: _isEmail ? "Email" : "Phone",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      suffix: formData["email"] != null &&
                              formData["email"]!.isNotEmpty
                          ? const FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: Colors.green,
                              size: Sizes.size32,
                            )
                          : null,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please write your Phone number or email address";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        formData['email'] = newValue;
                      }
                    },
                    onChanged: (value) {
                      setState(
                        () {
                          formData['email'] = value;
                        },
                      );
                    },
                    onTap: () {
                      setState(() {
                        _writingEmail = true;
                      });
                    },
                  ),
                  Gaps.v10,
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    controller: _birthdayController,
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Date of birth",
                      hintStyle: const TextStyle(
                        fontSize: Sizes.size18,
                      ),
                      labelText: "Date of birth",
                      labelStyle: const TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.normal,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please write Birthday";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        formData['birthday'] = newValue;
                      }
                    },
                    onChanged: (value) {
                      setState(
                        () {
                          formData['birthday'] = value;
                        },
                      );
                    },
                    onTap: _showDatePicker,
                  ),
                  Gaps.v12,
                  _pickingDate
                      ? Text(
                          "This will not be shown publicly. Confirm your\nown age, even if this account is for a\nbusiness, a pet, or something else.",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                        )
                      : Container(),
                  _isAgree && !_pickingDate
                      ? RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: Sizes.size14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade800,
                            ),
                            children: [
                              const TextSpan(
                                text: "By signing up, you agree to the ",
                              ),
                              TextSpan(
                                text: "Terms of Service",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const TextSpan(
                                text: " and ",
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const TextSpan(
                                text: ", including ",
                              ),
                              TextSpan(
                                text: "Cookie Use",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ". Twitter\nmay use your contact information, including your\nemail address and phone number for purposes\noutlined in our Privacy Policy, like keeping your\naccount secure and personalizing our services,\nincluding ads. ",
                              ),
                              TextSpan(
                                text: "Learn more",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ". Others will be able to\nfind you by email or phone number, when provided,\nunless you choose otherwise. ",
                              ),
                              TextSpan(
                                text: "here",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const TextSpan(text: "."),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _isAgree
                  ? GestureDetector(
                      onTap: _formKey.currentState != null &&
                              _formKey.currentState!.validate()
                          ? _onSubmitTap
                          : _onSubmitTap,
                      child: Container(
                        height: Sizes.size64,
                        // width: Sizes.size96,
                        alignment: const Alignment(0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _writingEmail
                            ? const Text(
                                "Use phone instead",
                                style: TextStyle(
                                  fontSize: Sizes.size20,
                                ),
                              )
                            : const Text(""),
                        GestureDetector(
                          onTap: _formKey.currentState != null &&
                                  _formKey.currentState!.validate()
                              ? _onSubmitTap
                              : null,
                          child: Container(
                            height: Sizes.size52,
                            width: Sizes.size96,
                            alignment: const Alignment(0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              color: _formKey.currentState != null &&
                                      _formKey.currentState!.validate()
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Sizes.size20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
