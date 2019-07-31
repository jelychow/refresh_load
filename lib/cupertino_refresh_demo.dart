// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:math' show Random;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoRefreshControlDemo extends StatefulWidget {
  static const String routeName = '/cupertino/refresh';

  @override
  _CupertinoRefreshControlDemoState createState() =>
      _CupertinoRefreshControlDemoState();
}

class _CupertinoRefreshControlDemoState
    extends State<CupertinoRefreshControlDemo> {
  List list = new List();

  @override
  void initState() {
    super.initState();
    list.add("a${DateTime.now()}");
    list.add("b${DateTime.now()}");

    list.add("c${DateTime.now()}");
    list.add("d${DateTime.now()}");
    list.add("e${DateTime.now()}");
    list.add("f${DateTime.now()}");
    list.add("g${DateTime.now()}");
    setState(() {});
  }

  Widget _getItem(int index) {
    if (list.length > 0) {
      if (index == list.length) {
        return Column(
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
    } else{
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
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Refresh'),
                // We're specifying a back label here because the previous page
                // is a Material page. CupertinoPageRoutes could auto-populate
                // these back labels.
                previousPageTitle: 'Cupertino',
              ),
              CupertinoSliverRefreshControl(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
