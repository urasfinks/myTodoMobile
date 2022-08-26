import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myTODO/AppStore/AppStore.dart';

import 'main.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Промо',
      debugShowCheckedModeBanner: false,
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LifecycleApp()),
    );
  }

  Widget _buildImage(String assetName, [double width = 250]) {
    return CachedNetworkImage(
      imageUrl: "${AppStore.host}/$assetName",
      width: width,
    );
    //return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Создай список задач",
          body:
          "К созданию списка надо подойти осознанно. Будущий список будет содержать задачи и его можно назвать например так: купить в магазине, дни рождения, взять в отпуск, дела по дому, мои идеи или что я сделал полезного. Предел фантазий ограничивается только твоим воображением!",
          image: _buildImage('list_add.png'),
        ),
        PageViewModel(
          title: "Создай в своём списке задачи",
          body:
          "Задачу, которую ты создашь, можеь пометить цветным маркером или группой, что бы тебе можно было проще ориентироваться в своём списке. В настройках списка ты можешь выбрать группировку задач по разным типам, например цвету/ группе или статусу",
          image: _buildImage('task_add.png'),
        ),
        PageViewModel(
          title: "Создай общий список",
          body:
          "Создавай общие списки со своими близкими для планирования поездки или списка покупок в магазине. Вы сможете проконтролировать, что ничего не забыли",
          image: _buildImage('share_add.png'),
        )
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Пропустить', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Готово', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding:  const EdgeInsets.all(12.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}