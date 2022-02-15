import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/pages/home/home_page.dart';
import 'package:mottai_flutter_app/pages/not_found/not_found_page.dart';
import 'package:mottai_flutter_app/pages/second/second_page.dart';
import 'package:mottai_flutter_app/utils/types.dart';

/// ページ一覧
final routes = <String, PageBuilder>{
  HomePage.path: (_, args) => const HomePage(key: ValueKey(HomePage.name)),
  NotFoundPage.path: (_, args) => const NotFoundPage(key: ValueKey(NotFoundPage.name)),
  SecondPage.path: (_, args) =>
      SecondPage.withArgs(args: args, key: const ValueKey(SecondPage.name)),
};
