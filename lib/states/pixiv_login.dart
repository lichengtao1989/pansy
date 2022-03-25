import 'dart:io';

import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:pansy/basic/cross.dart';
import 'package:pansy/screens/login_screen.dart';
import 'package:pansy/screens/pc_login_screen.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';

import '../ffi.dart';

bool pixivLogin = false;
Event pixivLoginEvent = Event();

void setPixivLogin(bool login) {
  pixivLogin = login;
  pixivLoginEvent.broadcast();
}

LoginUrl? verifyUrl;

StreamSubscription? _sub;

Future<void> pixivLoginAction(BuildContext context) async {
  verifyUrl = await api.createLoginUrl();
  if (Platform.isAndroid || Platform.isIOS) {
    _sub?.cancel();
    _sub = linkStream.listen((String? link) {
      if (verifyUrl != null && link != null) {
        String link1 = link.replaceAll("pixiv://account/login?code=", "");
        link1 = link1.replaceAll("&via=login", "");
        if (link1 != link) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return LoginScreen(verify: verifyUrl!.verify, code: link1);
          }));
          api.loginByCode(query: LoginByCodeQuery(code: link1, verify: verifyUrl!.verify));
        }
      }
    }, onError: (err) {
      print("ERR : $err");
    });
    openUrl(verifyUrl!.url);
  } else {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return PcLoginScreen(verifyUrl!);
    }));
  }
}
