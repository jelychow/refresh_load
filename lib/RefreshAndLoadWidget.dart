import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RefreshAndLoadWidget extends StatefulWidget {
  final RefreshCallback onRefresh;
  final RefreshCallback onRLoadMore;
  final IndexedWidgetBuilder builder;
  final RefreshAndLoadControl refreshAndLoadControl;
  ScrollController controller;

  @override
  State<StatefulWidget> createState() {
    return _RefreshAndLoadWidgetState();
  }

  RefreshAndLoadWidget(this.onRefresh, this.onRLoadMore, this.builder,
      this.refreshAndLoadControl);
}

class _RefreshAndLoadWidgetState extends State<RefreshAndLoadWidget>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = new ScrollController();
  GlobalKey _myKey = new GlobalKey();

  @override
  void initState() {
    _scrollController.addListener(() {
//      Fluttertoast.showToast(msg: "123");
      print("pixels" + _scrollController.position.pixels.toString());
      print("maxScrollExtent" +
          _scrollController.position.maxScrollExtent.toString());

      ///判断当前滑动位置是不是到达底部，触发加载更多回调
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

        if (this.widget.refreshAndLoadControl.needLoadMore) {
//          Fluttertoast.showToast(msg: "boolean" + "${(this.widget.refreshAndLoadControl.needLoadMore)}");
          handleLoadMore();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
        child: CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: handleRefresh,
          builder: buildSimpleRefreshIndicator,
        ),
        SliverSafeArea(
          key: _myKey,
          top: false,
          sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return _getItem(index, context);
          }, childCount: widget.refreshAndLoadControl.dataList.length + 1)),
        ),
      ],
    ));
  }

  Widget buildSimpleRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {

    print("state:${pulledExtent}");

    return Container(
        height: pulledExtent > 120 ? pulledExtent : 120,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 30,
              child: (pulledExtent.abs() > 30)
                  ? const m.CircularProgressIndicator()
                  : new Container(),
            )
          ],
        ));
  }

  Widget _getItem(int index, BuildContext context) {
    if (widget.refreshAndLoadControl.dataList?.length == 0) {
      return _buildEmpty();
    }

    if (index == widget.refreshAndLoadControl.dataList?.length) {
      return _buildLoadMoreIndicator();
    } else {
      return widget.builder(context, index);
    }
//    return Text("$index");
  }

  Widget _buildEmpty() {
    Widget empty = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Text("这里是空占位哦"),
      alignment: FractionalOffset(0.5, 0.4),
    );

    return empty;
  }

  Widget _buildLoadMoreIndicator() {
    Widget bottom = widget.refreshAndLoadControl.needLoadMore
        ? Text("正在加载中。。。")
        : Text("加载完毕");

    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: bottom,
        ));
  }

  Future<void> handleRefresh() async {
    if (widget.refreshAndLoadControl.isRefreshing) {
      //如果还在刷新 说明还在执行加载任务 那么不处理
      return null;
    }
    Fluttertoast.showToast(msg: "handleRefresh");

    widget.refreshAndLoadControl.isRefreshing = true;
    await widget.onRefresh?.call();
    await doDelayed();
    widget.refreshAndLoadControl.isRefreshing = false;
  }

  Future<void> handleLoadMore() async {
    if (widget.refreshAndLoadControl.isLoading) {
      //如果还在刷新 说明还在执行加载任务 那么不处理
      return null;
    }

    widget.refreshAndLoadControl.isLoading = true;
    Fluttertoast.showToast(msg: "handleLoadMore");
    await widget.onRLoadMore?.call();
    widget.refreshAndLoadControl.isLoading = false;
  }

  doDelayed() async {
    await Future.delayed(Duration(seconds: 2)).then((_) async {});
  }
}

class RefreshAndLoadControl extends ChangeNotifier {
  List _dataList = new List();

  get dataList => _dataList;

  set dataList(List value) {
    _dataList.clear();
    if (value != null) {
      _dataList.addAll(value);
      notifyListeners();
    }
  }

  loadList(List value) {
    if (value != null) {
      _dataList.addAll(value);
      notifyListeners();
    }
  }

  bool _needLoadMore = true;

  get needLoadMore => _needLoadMore;

  set needLoadMore(bool value) {
    _needLoadMore = value;
    notifyListeners();
  }

  bool _isLoading = false;

  get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isRefreshing = false;

  get isRefreshing => _isRefreshing;

  set isRefreshing(bool value) {
    _isRefreshing = value;
    notifyListeners();
  }
}

