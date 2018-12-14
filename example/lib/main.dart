import 'package:flutter/material.dart';
import 'package:pandora/pandora.dart';

void main() {
  Pandora.injectModule(AppModule());
  runApp(MyApp());
}

class AppModule extends Module {
  AppModule()
      : super([
          CounterSingletonProvider(),
          TextFactoryProvider(),
          OverviewTextFactory(),
        ]);
}

class CounterSingletonProvider extends SingletonComponentProvider<Counter> {
  @override
  void dispose() {}

  @override
  Counter inject(PandoraInjector injector) {
    return Counter();
  }
}

class TextFactoryProvider extends FactoryComponentProvider<String> {
  @override
  void dispose() {}

  @override
  String inject(PandoraInjector injector) {
    return "You clicked ${injector.provide<Counter>().value} times.";
  }
}

class OverviewTextFactory extends FactoryComponentProvider<String> {
  @override
  void dispose() {}

  @override
  String inject(PandoraInjector injector) {
    return "Total times you did click: ${injector.provide<Counter>().value}";
  }

  @override
  // TODO: implement name
  String get name => "overview";
}

class Counter {
  int value;

  Counter({this.value = 0});

  void increment() => value++;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {
      Pandora.provide<Counter>().increment();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Pandora.provide<String>(),
              style: Theme.of(context).textTheme.headline,
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OverviewScreen())),
              child: Text("Overview"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Pandora.provide<String>(named: "overview"),
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    );
  }
}
