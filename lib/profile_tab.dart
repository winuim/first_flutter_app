import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          const SizedBox(height: 80.0),
          Column(
            children: <Widget>[
              Image.asset('packages/shrine_images/diamond.png'),
              const SizedBox(height: 16.0),
              const Text('SHRINE'),
            ],
          ),
          const SizedBox(height: 120.0),
          CupertinoTextField(
            controller: _usernameController,
            placeholder: 'Username',
          ),
          const SizedBox(height: 12.0),
          CupertinoTextField(
            controller: _passwordController,
            placeholder: 'Password',
            obscureText: true,
          ),
          ButtonBar(
            children: <Widget>[
              CupertinoButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  _usernameController.clear();
                  _passwordController.clear();
                },
              ),
              CupertinoButton(
                child: const Text('SIGNIN'),
                onPressed: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return HomePage();
                  }))
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const Text('You did it!',
            style: TextStyle(fontSize: 20, color: Colors.blue)),
        CupertinoButton(
          child: const Text('SIGNOUT'),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      ])),
      resizeToAvoidBottomInset: false,
    );
  }
}
