// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:math' show Random;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CupertinoRefreshControlDemo extends StatefulWidget {
  static const String routeName = '/cupertino/refresh';

  @override
  _CupertinoRefreshControlDemoState createState() =>
      _CupertinoRefreshControlDemoState();
}

class _CupertinoRefreshControlDemoState
    extends State<CupertinoRefreshControlDemo> {
  List list = new List();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    list.length = 16;

    setState(() {});

    _scrollController.addListener(() {
      print("${_scrollController.position.viewportDimension}");
      print("${_scrollController.position.maxScrollExtent}");

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("${_scrollController.position.viewportDimension}");
        print("触发加载更多");
        print("${MediaQuery.of(context).size.height}");

        print("${_scrollController.position.pixels}");
        handleLoadMore();
        Fluttertoast.showToast(msg: "触发加载更多");
      }
    });
  }

  Future<void> handleLoadMore() async{
    list.length = list.length + 6;
    setState(() {

    });
    print("handleLoadMore1${DateTime.now()}");
    doDelay();
    print("handleLoadMore2${DateTime.now()}");

    return null;
  }

  // 添加打印日志方便理解Future方法的执行顺序
  doDelay() async {
    await Future.delayed(Duration(seconds: 2), ()async{
      print("doDelay1 ${DateTime.now()}");
      await Future.delayed(Duration(seconds: 1));
      print("doDelay2 ${DateTime.now()}");


    }).then( (_) async{
      print("doDelay3 ${DateTime.now()}");
      await Future.delayed(Duration(seconds: 1));
    }).whenComplete((){
      print("doDelay4 ${DateTime.now()}");
    });

  }

  Widget _getItem(int index) {
    if (list.length > 0) {
      if (index == list.length) {
        return Container(
          color: Colors.grey,
          child: Column(
            children: <Widget>[
              Container(
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  alignment: FractionalOffset(0.5, 0.5),
                  child: Text("这里是加载更多哦。。",
                      style: TextStyle(color: Color(0xffffffff)))),
              Divider(
                height: 0.5,
                color: Colors.white,
              )
            ],
          ),
        );
      }
      return Column(
        children: <Widget>[
          Container(
              color: Colors.blue,
              alignment: FractionalOffset(0.5, 0.5),
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: Text("这是第$index 个item",
                  style: TextStyle(color: Color(0xffffffff)))),
          Divider(
            height: 0.5,
            color: Colors.grey[350],
          )
        ],
      );
    } else {
      return Text("empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.textStyle,
      child: CupertinoPageScaffold(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).brightness == Brightness.light
                ? CupertinoColors.extraLightBackgroundGray
                : CupertinoColors.darkBackgroundGray,
          ),
          child: CustomScrollView(
            // If left unspecified, the [CustomScrollView] appends an
            // [AlwaysScrollableScrollPhysics]. Behind the scene, the ScrollableState
            // will attach that [AlwaysScrollableScrollPhysics] to the output of
            // [ScrollConfiguration.of] which will be a [ClampingScrollPhysics]
            // on Android.
            // To demonstrate the iOS behavior in this demo and to ensure that the list
            // always scrolls, we specifically use a [BouncingScrollPhysics] combined
            // with a [AlwaysScrollableScrollPhysics]
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Refresh'),
                // We're specifying a back label here because the previous page
                // is a Material page. CupertinoPageRoutes could auto-populate
                // these back labels.
                previousPageTitle: 'Cupertino',
              ),
              CupertinoSliverRefreshControl(
                // 替换成我们自己的方法
                onRefresh: () {
                  return Future<void>.delayed(const Duration(seconds: 2))
                    ..then<void>((_) {
                      if (mounted) {}
                    });
                },
              ),
              SliverSafeArea(
                top: false, // Top safe area is consumed by the navigation bar.
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return _getItem(index);
                    },
                    childCount: list.length + 1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
