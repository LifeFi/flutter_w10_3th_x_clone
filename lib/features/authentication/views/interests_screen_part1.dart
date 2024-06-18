import 'package:flutter/material.dart';
import 'package:flutter_w10_3th_x_clone/constants/gaps.dart';
import 'package:flutter_w10_3th_x_clone/constants/sizes.dart';
import 'package:flutter_w10_3th_x_clone/features/authentication/views/interests_screen_part2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const List<String> _interestList = [
  "Fashion & beauty",
  "Outdoors",
  "Arts & culture",
  "Animation & comics",
  "Business & finance",
  "Food",
  "Travel",
  "Entertainment",
  "Music",
  "Gaming",
  "Nomadcorders",
  "Sendquest",
  "Sendpotion",
  "FutureMe",
];

class InterestsScreenPart1 extends StatefulWidget {
  static const String routeName = "interest";
  static const String routeURL = "/interest";

  const InterestsScreenPart1({super.key});

  @override
  State<InterestsScreenPart1> createState() => _InterestsScreenPart1State();
}

class _InterestsScreenPart1State extends State<InterestsScreenPart1> {
  final List<String> _selectedInterests = [];

  void _onInterestTap(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      _selectedInterests.add(interest);
    }
    print(_selectedInterests);
    setState(() {});
  }

  _goToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InterestsScreenPart2(),
      ),
    );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.size24,
            right: Sizes.size24,
            top: Sizes.size20,
            bottom: Sizes.size10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What do you want to see on Twitter?",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gaps.v20,
              Text(
                "Select at least 3 interests to personalize your Twitter experience. They will be visible on your profile.",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.grey.shade700,
                ),
              ),
              Gaps.v20,
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var interest in _interestList)
                      GestureDetector(
                        onTap: () => _onInterestTap(interest),
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 80,
                              width: 160,
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.only(
                                left: Sizes.size10,
                                bottom: Sizes.size10,
                              ),
                              decoration: BoxDecoration(
                                  color: _selectedInterests.contains(interest)
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  border: _selectedInterests.contains(interest)
                                      ? null
                                      : Border.all(
                                          color: Colors.grey,
                                        ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                interest,
                                style: TextStyle(
                                    color: _selectedInterests.contains(interest)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: Sizes.size14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: _selectedInterests.contains(interest)
                                  ? AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: const FaIcon(
                                        FontAwesomeIcons.solidCircleCheck,
                                        color: Colors.white,
                                        size: Sizes.size18,
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        color: Colors.white,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.only(
            top: Sizes.size10,
            left: Sizes.size14,
            right: Sizes.size14,
          ),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedInterests.length >= 3
                    ? "Great work 🎉"
                    : "${_selectedInterests.length} of 3 selected",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: Sizes.size16,
                ),
              ),
              GestureDetector(
                onTap: _selectedInterests.length >= 3 ? _goToNext : () {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: Sizes.size52,
                  width: Sizes.size96,
                  alignment: const Alignment(0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: _selectedInterests.length >= 3
                        ? Colors.black
                        : Colors.grey,
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
