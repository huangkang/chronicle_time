import 'package:get/get_navigation/src/routes/get_route.dart';
import '../pages/history_page/history_binding.dart';
import '../pages/history_page/history_view.dart';
import '../pages/home_page/home_binding.dart';
import '../pages/home_page/home_view.dart';
import '../pages/recording_page/recording_binding.dart';
import '../pages/recording_page/recording_view.dart';
import '../pages/video_page/video_binding.dart';
import '../pages/waiting_page/waiting_binding.dart';
import '../pages/waiting_page/waiting_view.dart';
import '../pages/video_page/video_view.dart';

abstract class Routes {
  Routes._();

  static const String home = "/home";
  static const String history = "/history";
  static const String recording = "/recording";
  static const String video = "/video";
  static const String waiting = "/waiting";

  static const initial = home;

  static final routes = [
    GetPage(
      name: home,
      page: () => HomePage(),
      bindings: [HomeBinding()],
      // participatesInRootNavigator默认为true；
      // 表示该页面是否要参与到路由栈的控制中，如果设置为false，则该页面不会被Get路由管理，也就不能使用Get.to()、Get.off()等方法进行页面跳转。
      participatesInRootNavigator: true,
      // preventDuplicates默认为false；
      // 表示是否允许同一个路由被多次打开。如果设置为true，则会判断该路由是否已经在路由栈中存在，如果已经存在，则不会再次打开该路由。
      // 这个属性在一些特定场景下很有用，比如防止用户重复点击按钮重复打开同一个弹窗。
      preventDuplicates: true,
    ),
    GetPage(
      name: history,
      page: () => HistoryPage(),
      bindings: [HistoryBinding()],
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
    GetPage(
      name: recording,
      page: () => RecordingPage(),
      bindings: [RecordingBinding()],
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
    GetPage(
      name: video,
      page: () => VideoPage(),
      bindings: [VideoBinding()],
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
    GetPage(
      name: waiting,
      page: () => WaitingPage(),
      bindings: [WaitingBinding()],
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
  ];
//
// GetPage(
//   name: _Paths.login,
//   page: () => LoginPage(),
//   bindings: [LoginBinding()],
//   participatesInRootNavigator: true,
//   preventDuplicates: true,
// ),
// GetPage(
//     preventDuplicates: true,
//     name: _Paths.home,
//     page: () => HomePage(),
//     bindings: [
//       HomeBinding(),
//     ],
//     middlewares: [
//       //only enter this route when not authed
//       EnsureStartMiddleware(),
//       EnsureAuthMiddleware(),
//     ],
//     title: "首页",
//     children: [
//       GetPage(
//         preventDuplicates: true,
//         name: _Paths.dashboard,
//         page: () => const DashboardPage(),
//       ),
//       GetPage(
//         preventDuplicates: true,
//         name: _Paths.function,
//         page: () => const FunctionPage(),
//       ),
//       GetPage(
//         preventDuplicates: true,
//         name: _Paths.me,
//         page: () => const MePage(),
//       ),
//     ]),
// GetPage(
//   preventDuplicates: true,
//   name: _Paths.guide,
//   page: () => GuidePage(),
//   bindings: [
//     GuideBinding(),
//   ],
// ),
// GetPage(
//     preventDuplicates: true,
//     name: _Paths.settings,
//     page: () => SettingsPage(),
//     bindings: [
//       SettingsBinding(),
//     ],
//     children: [
//       GetPage(
//         preventDuplicates: true,
//         name: _Paths.fontSize,
//         page: () => FontSizePage(),
//         bindings: [
//           FontSizeBinding(),
//         ],
//       ),
//       GetPage(
//         preventDuplicates: true,
//         name: _Paths.themeMode,
//         page: () => ThemeModePage(),
//         bindings: [
//           ThemeModeBinding(),
//         ],
//       ),
//     ]),
// GetPage(
//     preventDuplicates: true,
//     name: _Paths.debug,
//     page: () => DebugPage(),
//     bindings: [
//       DebugBinding(),
//     ],
//     children: [
//       GetPage(
//         preventDuplicates: true,
//         name: _Paths.domainSettings,
//         page: () => DomainSettingsPage(),
//         bindings: [
//           DomainSettingsBinding(),
//         ],
//       ),
//       GetPage(
//         preventDuplicates: true,
//         name: _Paths.log,
//         page: () => LogPage(),
//         bindings: [
//           LogBinding(),
//         ],
//       ),
//     ]),
}
