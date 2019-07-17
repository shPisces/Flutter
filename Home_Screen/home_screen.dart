import 'package:flutter/material.dart';
import 'constants.dart';
import 'conversatin_page.dart';
import 'discover_page.dart';
import 'contacts_page.dart';
import 'profile_page.dart';

/**
 * 底部选项卡：
 * 1、放置底部按钮，设置按钮默认和选中两种不同状态UI
 * 2、点击底部按钮跳转到不同的页面
 */

enum ActionItems {
  GROUP_CHAT, ADD_FRIEND, QR_SCAN, PAYMENT
}

// 设置导航Icon view（封装）
class NavigationIconView {

  // 声明相关属性
  final String _title; // 标题
  final IconData _icon; // 默认图片
  final IconData _activeIcon; // 选中图片
  final BottomNavigationBarItem item; // 底部导航选项卡item

  // 创建导航Icon view（调用方法，相关参数传递方式）
  NavigationIconView({Key key, String title, IconData icon, IconData activeIcon})
    : _title = title, // 标题赋值
      _icon = icon, // 默认图片赋值
      _activeIcon = activeIcon, // 选中图片赋值
    item = new BottomNavigationBarItem( // 创建底部导航选项卡item
        icon: Icon(icon),
        activeIcon: Icon(activeIcon),
        title: Text(title),
        backgroundColor: Colors.white
    );

}

// 创建底部选项卡页面，页面类型为 StatefulWidget
class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 声明属性
  PageController _pageController; // 页面控制器
  List<Widget> _pages; // 页面列表
  int _currentIndex = 0; // 当前选中坐标
  List<NavigationIconView> _navigationViews; // 选项卡item列表

  // 初始化状态 设置底部选项卡，页面及跳转
  @override
  void initState() {
    super.initState(); // 调用父视图的初始化状态方法
    _navigationViews = [ // 赋值选项卡item列表
      NavigationIconView(
        title: '微信',
        icon: IconData(
          0xe608,
          fontFamily: Constants.IconFontFamily
        ),
        activeIcon: IconData(
          0xe603,
          fontFamily: Constants.IconFontFamily
        ),
      ),

      NavigationIconView(
        title: '通讯录',
        icon: IconData(
            0xe601,
            fontFamily: Constants.IconFontFamily
        ),
        activeIcon: IconData(
            0xe602,
            fontFamily: Constants.IconFontFamily
        ),
      ),

      NavigationIconView(
        title: '发现',
        icon: IconData(
            0xe600,
            fontFamily: Constants.IconFontFamily
        ),
        activeIcon: IconData(
            0xe604,
            fontFamily: Constants.IconFontFamily
        ),
      ),

      NavigationIconView(
        title: '我',
        icon: IconData(
            0xe607,
            fontFamily: Constants.IconFontFamily
        ),
        activeIcon: IconData(
            0xe630,
            fontFamily: Constants.IconFontFamily
        ),
      ),
    ];

    _pageController = PageController(initialPage: _currentIndex); // 初始化控制器，设置控制器初始位置
    _pages = [
      ConversationPage(), // 聊天页面
      ContactsPage(), // 通讯录页面
      DisCoverPage(), // 发现页面
      ProfilePage(), // 我的页面
    ];
  }

  // 弹出页面菜单item（封装）
  _buildPopupMenuItem(int iconName, String title) { // 传参 图片名称 标题
    return Row( // 布局为行排列
      children: <Widget>[

        // 图片
        Icon(
          IconData(
            iconName,
            fontFamily: Constants.IconFontFamily
          ),
          size: 22.0, // 图片大小
          color: const Color(AppColors.AppBarPopupMenuColor),
        ),
        Container(width: 12.0), // 图片和文字的间隔

        // 文本
        Text(
          title, style:
          TextStyle(
            color: const Color(AppColors.AppBarPopupMenuColor)
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    // 创建底部导航bar，并被赋值
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
        items: _navigationViews.map((NavigationIconView view) {
          return view.item;
      }).toList(),
      currentIndex: _currentIndex, // 当前定位坐标
      type: BottomNavigationBarType.fixed, // 填充样式
      fixedColor: const Color(AppColors.TabIconActive),
      onTap: (int index) { // 点击事件
          setState(() { // 状态更改并刷新
            _currentIndex = index; //  重新获取坐标
            _pageController.jumpToPage(_currentIndex); // 页面跳转
          });
      },
    );

    // 页面布局
    return Scaffold(

      // 顶部导航栏布局
      appBar: AppBar(
        title: Text('微信'),
        elevation: 0.0, // 不需要阴影
        actions: <Widget>[ // 点击动作事件组
          IconButton(
            icon: Icon(IconData(
              0xe605,
              fontFamily: Constants.IconFontFamily
            )),
            onPressed: () {
              print('点击了搜索按钮');
            },
          ),
          Container(width: 16.0),

          // 创建弹出菜单
          PopupMenuButton(
            itemBuilder: (BuildContext context){
              return<PopupMenuItem<ActionItems>>[
                PopupMenuItem(
                  child: _buildPopupMenuItem(0xe606, "发起群聊"),
                  value: ActionItems.GROUP_CHAT,
                ),
                PopupMenuItem(
                  child: _buildPopupMenuItem(0xe638, "添加朋友"),
                  value: ActionItems.ADD_FRIEND,
                ),
                PopupMenuItem(
                  child: _buildPopupMenuItem(0xe79b, "扫一扫"),
                  value: ActionItems.QR_SCAN,
                ),
                PopupMenuItem(
                  child: _buildPopupMenuItem(0xe658, "收付款"),
                  value: ActionItems.PAYMENT,
                ),
              ];
            },
            icon: Icon(IconData(
              0xe66b,
              fontFamily: Constants.IconFontFamily
              ),
              size: 22.0,
            ),
            onSelected: (ActionItems selected) {
              print('点击的是$selected');
            },
          ),

          Container(width: 16.0)
        ],
      ),

      // 页面控制器展示
      body: PageView.builder(

        // 菜单展示
        itemBuilder: (BuildContext context, int index){
            return _pages[index];
        },

        controller: _pageController, // 控制器
        itemCount: _pages.length, // 控制器数组长度
        onPageChanged: (int index) { // 切换页面，更改状态并赋值
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: botNavBar, // 底部选项卡
    );
  }
}