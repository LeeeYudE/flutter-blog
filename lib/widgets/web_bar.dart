import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/config/base_config.dart';
import 'package:flutter_blog/config/full_screen_dialog_util.dart';
import 'package:flutter_blog/json/article_json_bean.dart';
import 'package:flutter_blog/pages/all_pages.dart';
import 'package:flutter_blog/utils/navigator_util.dart';
import 'package:flutter_blog/widgets/search_widget.dart';
import 'package:flutter_blog/widgets/top_show_widget.dart';

import '../config/platform_type.dart';
import 'bar_button.dart';

export '../config/platform_type.dart';

class WebBar extends StatefulWidget {
  final PageType pageType;

  const WebBar({
    Key key,
    this.pageType = PageType.home,
  }) : super(key: key);

  @override
  _WebBarState createState() => _WebBarState();
}

class _WebBarState extends State<WebBar> {
  PageType pageType;

  @override
  void initState() {
    pageType = widget.pageType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isNotMobile = !PlatformType().isMobile();
    final fontSize = isNotMobile ? height * 30 / 1200 : 15.0;

    return buildAppBar(isNotMobile, width, height, fontSize, context);
  }

  Container buildAppBar(bool isNotMobile, double width, double height,
      double fontSize, BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.only(top: isNotMobile ? 0.0 : 20),
      width: isNotMobile
          ? (pageType == PageType.article ? width - 40 : 0.86 * width)
          : width,
      child: Row(
        children: <Widget>[
          if (isNotMobile)
            Row(
              children: <Widget>[
                FlutterLogo(
                  size: getScaleSizeByHeight(height, 75.0),
                  // colors: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 30.0,
                ),
                Container(
                  height: getScaleSizeByHeight(height, 50.0),
                  width: 3.0,
                  color: const Color(0xff979797),
                ),
                const SizedBox(
                  width: 30.0,
                ),
                Text(
                  'Flutter',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'huawen_kt',
                  ),
                ),
              ],
            )
          else
            Container(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: getTapChildren(isNotMobile, context, fontSize),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getTapChildren(
      bool isNotMobile, BuildContext context, num fontSize) {
    return <Widget>[
      Expanded(
        flex: isNotMobile ? 0 : 1,
        child: BarButton(
          child: Text(
            '首页',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'huawen_kt',
            ),
          ),
          onPressed: () {
            print(ModalRoute.of(context).isFirst);
            if (pageType == PageType.home) return;
            NavigatorUtil.until(HomePage.routeName);
          },
          isChecked: pageType == PageType.home,
        ),
      ),
      Expanded(
        flex: isNotMobile ? 0 : 1,
        child: BarButton(
          child: Text(
            '标签',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'huawen_kt',
            ),
          ),
          onPressed: () {
            if (pageType == PageType.tag) return;
            NavigatorUtil.pushName(TagPage.routeName);
          },
          isChecked: pageType == PageType.tag,
        ),
      ),
      Expanded(
        flex: isNotMobile ? 0 : 1,
        child: BarButton(
          child: Text(
            '归档',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'huawen_kt',
            ),
          ),
          onPressed: () {
            if (pageType == PageType.archive) return;
            pushAndRemove(context, ArchivePage.routeName);
          },
          isChecked: pageType == PageType.archive,
        ),
      ),
      Expanded(
        flex: isNotMobile ? 0 : 1,
        child: BarButton(
          child: Text(
            '友链',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'huawen_kt',
            ),
          ),
          onPressed: () {
            if (pageType == PageType.link) return;
            pushAndRemove(context, FriendLinkPage.routeName);
          },
          isChecked: pageType == PageType.link,
        ),
      ),
      Expanded(
        flex: isNotMobile ? 0 : 1,
        child: BarButton(
          child: Text(
            '关于',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'huawen_kt',
            ),
          ),
          onPressed: () {
            if (pageType == PageType.about) return;
            pushAndRemove(context, AboutPage.routeName);
          },
          isChecked: pageType == PageType.about,
        ),
      ),
      if (isNotMobile)
        IconButton(
            icon: Icon(
              Icons.search,
              size: fontSize,
            ),
            onPressed: () async {
              final dynamic data = await ArticleJson.loadArticles();
              final map = Map.from(data);

              showSearchWidget(context, map);
//              showSearch(context: context, delegate: SearchDelegateWidget(map));
            })
      else
        Container(),
    ];
  }

  void showSearchWidget(BuildContext context, Map map) {
    FullScreenDialog.getInstance().showDialog(
      context,
      TopAnimationShowWidget(
        child: SearchWidget(
          dataMap: map,
        ),
        distanceY: 100,
      ),
    );
  }

  void pushAndRemove(BuildContext context, String routeName,
      {Object argument}) {
    debugPrint('widget.pageType=${widget.pageType}');
    if (widget.pageType == PageType.home) {
      NavigatorUtil.pushName(routeName, arguments: argument);
    } else {
      NavigatorUtil.pushReplacementNamed(routeName, arguments: argument);
    }
  }

  double getScaleSizeByHeight(double height, double size) {
    return size * height / 1200;
  }
}

enum PageType { home, tag, archive, about, link, article }
