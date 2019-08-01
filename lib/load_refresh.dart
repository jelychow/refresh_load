import 'package:flutter/material.dart';

import 'RefreshAndLoadWidget.dart';

class RefreshAndLoadDemo extends StatefulWidget {
  RefreshAndLoadDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RefreshAndLoadDemo> {
  int _counter = 0;
  int page = 0;
  List dataList = new List();
  RefreshAndLoadControl control = new RefreshAndLoadControl();

  @override
  void initState() {
    control.needLoadMore = true;
    control.dataList = this.dataList;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: RefreshAndLoadWidget(
          onRefresh,
          onLoadMore,
          getItem,
          control
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> onRefresh() async {
    page = 0;
    await Future.delayed(Duration(seconds: 1));
    control.dataList = new List(12);
    setState(() {

    });
    return null;
  }

  Future<void> onLoadMore() async {
    await Future.delayed(Duration(seconds: 1));
    page++;
    control.loadList(new List(6));
    setState(() {

    });
    return null;
  }

  Widget getItem(BuildContext context,int index) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
        alignment: FractionalOffset(0.5, 0.5),
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: Text("这是第$index 个item",
            style: TextStyle(color: Color(0xffffffff))));
  }
}
