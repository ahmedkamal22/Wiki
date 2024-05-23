import 'package:fire/layout/cubit/cubit.dart';
import 'package:fire/models/boarding/boarding.dart';
import 'package:fire/modules/login/login.dart';
import 'package:fire/shared/components/components.dart';
import 'package:fire/shared/network/local/cache_helper.dart';
import 'package:fire/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingScreen extends StatefulWidget {
  BoardingScreen({Key? key}) : super(key: key);

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  var pageController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image:
          "https://img.freepik.com/free-photo/tea-pouring-beautiful-arab-women-meeting-cafe-restaurant-friends-business-meeting-spending-time-together-talking-laughting-muslim-lifestyle-stylish-happy-models-with-make-up_155003-45415.jpg?w=740&t=st=1666072618~exp=1666073218~hmac=43e1858e9a0ca3664b44b15180d78bf5056f94b7cc1c85a56a01f92e263ffb95",
      title: "Weki is A social media application. ",
    ),
    BoardingModel(
      image:
          "https://img.freepik.com/free-photo/sign-up-form-button-graphic-concept_53876-133556.jpg?w=740&t=st=1666072865~exp=1666073465~hmac=c9807b52bdbc0e81acdc837dab60c282899d7471cb8976e149a860d784196e26",
      title:
          "Here you can Create an account or log in to Weki to get contact with your friends. ",
    ),
    BoardingModel(
      image:
          "https://img.freepik.com/premium-photo/two-asian-children-little-girls-wear-christmas-santa-claus-chating-with-friend-digital-tablet-christmas-holiday-concept-stock-photo_258782-131.jpg?w=740",
      title:
          "A simple, fun & creative way to connect with others & messages with friends & family, Knowing world news.",
    ),
    BoardingModel(
      image:
          "https://img.freepik.com/free-photo/portrait-young-attractive-african-american-smiling-boy-sits-table-cafe-works-laptop-drinks-aromatic-coffee-looks-window_295783-2412.jpg?w=740&t=st=1666073479~exp=1666074079~hmac=8a3b4b3e97f5b11330e84ab4d24db419516aecf95c6a941413baa9904d658878",
      title:
          "Creating a powerful personal profile, \t you can delete comments & messages by swiping either left or right. ",
    ),
  ];
  bool isLast = false;

  submit() {
    CacheHelper.saveData(key: "boarding", value: true).then((value) {
      if (value) {
        navigateAndFinish(context: context, widget: LoginScreen());
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            onPressed: () {
              submit();
            },
            text: "skip",
            isUpper: true,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: defaultColor, fontSize: 17),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: pageController,
                onPageChanged: (index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(context, boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: boarding.length,
                  effect: SlideEffect(
                      spacing: 8.0,
                      radius: 8.0,
                      dotWidth: 40.0,
                      dotHeight: 16.0,
                      paintStyle: PaintingStyle.stroke,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast == true) {
                      submit();
                    } else {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  mini: true,
                  child: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(context, BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: NetworkImage("${model.image}"),
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "${model.title}",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                ),
          ),
        ],
      );
}
