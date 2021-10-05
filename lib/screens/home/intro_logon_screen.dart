import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/user.dart';
import 'package:my_fintech_app/screens/home/home_screen.dart';
import 'package:my_fintech_app/services/auth_service.dart';

class IntroLogonScreen extends StatelessWidget {
  const IntroLogonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 150, 10, 0),
            child: Text(
              'FinChat',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(70, 20, 70, 80),
            child: Image(image: AssetImage('assets/chat.png')),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // background
                    onPrimary: Colors.yellow, // foreground
                  ),
                  onPressed: () {
                    _authenticate(context);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login using your OAuth2 Provider',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ]))),
        ],
      ),
    );
  }

  Future<void> _authenticate(BuildContext context) async {
    try {
      User user = await AuthService().authenticate();
      await user.saveToFromLocalStorage();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (er) {}
  }
}
