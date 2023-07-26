// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matching_app/bloc/cubit.dart';
import 'package:matching_app/screen/home_screen/home_screen_view.dart';
import 'package:matching_app/screen/login/login_check_code.dart';
import 'package:matching_app/screen/login/login_view.dart';
import 'package:matching_app/screen/login/terms_agree.dart';
import 'package:matching_app/screen/main/board_function.dart';
import 'package:matching_app/screen/main/chat_screen.dart';
import 'package:matching_app/screen/main/chatting_screen.dart';
import 'package:matching_app/screen/main/community_screen.dart';
import 'package:matching_app/screen/main/following_users.dart';
import 'package:matching_app/screen/main/like_user_profile.dart';
import 'package:matching_app/screen/main/new_post_screen.dart';
import 'package:matching_app/screen/main/nick_name_edit.dart';
import 'package:matching_app/screen/main/profile_badge_select.dart';
import 'package:matching_app/screen/main/profile_edit_screen.dart';
import 'package:matching_app/screen/main/profile_screen.dart';
import 'package:matching_app/screen/main/report_screen.dart';
import 'package:matching_app/screen/main/report_success.dart';
import 'package:matching_app/screen/main/self_introduction.dart';
import 'package:matching_app/screen/main/setting/account_close_screen.dart';
import 'package:matching_app/screen/main/setting/admin_notification_list_screen.dart';
import 'package:matching_app/screen/main/setting/admin_notification_view_screen.dart';
import 'package:matching_app/screen/main/setting/blocked_users_screen.dart';
import 'package:matching_app/screen/main/setting/notify_screen.dart';
import 'package:matching_app/screen/main/setting/privacy_setting_screen.dart';
import 'package:matching_app/screen/main/setting/setting_screen.dart';
import 'package:matching_app/screen/main/user_list_screen.dart';
import 'package:matching_app/screen/main/user_profile_chat.dart';
import 'package:matching_app/screen/main/user_profile_screen.dart';
import 'package:matching_app/screen/register/address_check.dart';
import 'package:matching_app/screen/register/b_day.dart';
import 'package:matching_app/screen/register/badge_select.dart';
import 'package:matching_app/screen/register/body_type.dart';
import 'package:matching_app/screen/register/choose_community.dart';
import 'package:matching_app/screen/register/height_select.dart';
import 'package:matching_app/screen/register/nick_name.dart';
import 'package:matching_app/screen/register/profile_image.dart';
import 'package:matching_app/screen/register/purpose_use.dart';
import 'package:matching_app/screen/verify_screen/identity_verify.dart';
import 'package:matching_app/screen/verify_screen/image_check.dart';
import 'package:matching_app/screen/main/board_res_detail.dart';
import 'package:matching_app/screen/verify_screen/image_submit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MatchingApp()));

  // runApp(const MatchingApp());
}

class MatchingApp extends StatelessWidget {
  const MatchingApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit(),
        child: MaterialApp(
          title: 'Matching App',
          supportedLocales: const [
            Locale('ja', 'JP'),
            Locale('en', 'US'),
          ],
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('ja', 'JP'),
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreenView(),
            '/phone_login': (context) => LoginView(),
            '/check_code': (context) => LoginCheckCode(),
            '/terms_agree': (context) => TermsAgree(),
            '/nick_name': (context) => NickName(),
            '/b_day': (context) => BDay(),
            '/address_check': (context) => AddressCheck(),
            '/choose_community': (context) => ChooseCommunity(),
            '/height_select': (context) => HeightSelect(),
            '/body_type': (context) => BodyType(),
            '/purpose_use': (context) => PurposeUse(),
            '/badge_select': (context) => BadgeSelect(),
            '/profile_image': (context) => const ProfileImage(),
            '/identity_verify': (context) => IdentityVerify(),
            '/image_check': (context) => ImageCheck(),
            '/image_submit': (context) => ImageSubmit(),
            '/profile_screen': (context) => ProfileScreen(),
            '/self_introduction': (context) => SelfIntroducion(),
            '/community_screen': (context) => CommunityScreen(),
            '/following_users': (context) => FollowingUser(),
            '/board_function': (context) => BoardFunction(),
            '/chat_screen': (context) => ChatScreen(),
            '/chatting_screen': (context) => ChattingScreen(),
            '/users_profile_screen': (context) => UsersProfileScreen(),
            '/report_screen': (context) => ReportScreen(),
            '/report_success': (context) => ReportSuccess(),
            '/user_profile_chat': (context) => UsersProfileChatScreen(),
            '/profile_edit_screen': (context) => ProfileEditScreen(),
            '/profile_badge_screen': (context) => ProfileBadgeSelect(),
            '/like_user_profile': (context) => LikeUserProfile(),
            '/user_list_screen': (context) => UserListScreen(),
            '/setting_screen': (context) => SettingScreen(),
            '/nick_name_edit': (context) => NickNameEdit(),
            '/admin_notification_screen': (context) =>
                AdminNotificationListScreen(),
            '/admin_notification_view_screen': (context) =>
                AdminNotificationViewScreen(),
            '/notify_screen': (context) => NotifyScreen(),
            '/blocked_users_screen': (context) => BlockedUsersScreen(),
            '/privacy_setting_screen': (context) => PrivacySettingScreen(),
            '/account_close_screen': (context) => const AccountCloseScreen(),
            '/new_post_screen': (context) => const NewPostScreen(),
            
          },
        ));
  }
}
