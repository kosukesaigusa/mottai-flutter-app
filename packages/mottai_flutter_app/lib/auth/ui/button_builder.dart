import 'package:flutter/material.dart';

@immutable
class SignInButtonBuilder extends StatelessWidget {
  const SignInButtonBuilder({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
    this.icon,
    this.image,
    this.fontSize = 14.0,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.splashColor = Colors.white30,
    this.highlightColor = Colors.white30,
    this.padding,
    this.innerPadding,
    this.mini = false,
    this.elevation = 2.0,
    this.shape,
    this.height,
    this.width,
    this.clipBehavior = Clip.none,
    this.separator,
    this.separatorSpaceLeft,
    this.separatorSpaceRight,
  });

  /// これはサインインボタンのビルダークラスです。
  ///
  /// アイコンを使用して、サインインの方法を定義することができます。
  /// ユーザーはFlutterに組み込まれたアイコンや、font-awesome flutterのアイコンを利用できます。
  final IconData? icon;

  /// アイコンセクションを画像ロゴで上書きします。
  ///
  /// 例えば、Googleはカラーでロゴが必要ですが、FontAwesomeでは表示できません。
  /// 画像とアイコンの両方が提供された場合、画像が優先されます。
  final Widget? image;

  /// mini タグは、フル幅のサインインボタンから切り替えるために使用されます。
  final bool mini;

  /// ボタンのテキスト
  final String text;

  /// ラベルのフォントサイズ
  final double fontSize;

  /// backgroundColor は必須ですが、textColor はデフォルトで Colors.white です。
  /// splashColor はデフォルトで Colors.white30 です。
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;
  final Color splashColor;
  final Color highlightColor;

  /// onPressed はコールバックを示すために必須フィールドとして指定する必要があります。
  final Function onPressed;

  /// padding はデフォルトで EdgeInsets.all(3.0) に設定されています。
  final EdgeInsets? padding;
  final EdgeInsets? innerPadding;

  /// shape はウィジェットのカスタム形状を指定するためのものです。
  /// ただし、FlutterウィジェットにはMaterialボタンに関する制限またはバグがあるため、
  /// コメントアウトしています。
  final ShapeBorder? shape;

  /// elevation のデフォルト値は 2.0 です。
  final double elevation;

  /// ボタンの高さ
  final double? height;

  /// 幅はデフォルトで画面幅の1/1.5
  final double? width;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// デフォルトは [Clip.none] で、null であってはなりません。
  final Clip clipBehavior;

  /// アイコンとテキストを分割
  final Widget? separator;

  /// 区切りスペース（左）
  final double? separatorSpaceLeft;

  /// 区切りスペース（右）
  final double? separatorSpaceRight;

  /// サインインボタンウィジェットを構築するためのビルド関数です。
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      key: key,
      minWidth: mini ? width ?? 35.0 : null,
      height: height,
      elevation: elevation,
      padding: padding ?? EdgeInsets.zero,
      color: backgroundColor,
      onPressed: onPressed as void Function()?,
      splashColor: splashColor,
      highlightColor: highlightColor,
      shape: shape ?? ButtonTheme.of(context).shape,
      clipBehavior: clipBehavior,
      child: _getButtonChild(context),
    );
  }

  /// ボタンの内部コンテンツを取得します。
  Widget _getButtonChild(BuildContext context) {
    if (mini) {
      return SizedBox(
        width: height ?? 35.0,
        height: width ?? 35.0,
        child: _getIconOrImage(),
      );
    }
    return Container(
      constraints: BoxConstraints(
        maxWidth: width ?? 220,
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            _getIconOrImage(),
            if (separator != null) ...[
              SizedBox(
                width: separatorSpaceLeft,
              ),
              separator!,
              SizedBox(
                width: separatorSpaceRight,
              )
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// アイコンまたは画像ウィジェットを取得します。
  Widget _getIconOrImage() {
    if (image != null) {
      return image!;
    }
    return Icon(
      icon,
      size: 20,
      color: iconColor,
    );
  }
}
