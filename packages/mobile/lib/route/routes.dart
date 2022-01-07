import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/pages/home/home_page.dart';
import 'package:mottai_flutter_app/utils/types.dart';

/// ページ一覧
final routeDict = <String, PageBuilder>{
  HomePage.path: (_, args) => HomePage.withArgs(args: args, key: const ValueKey(HomePage.name)),
};
