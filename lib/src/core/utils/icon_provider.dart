enum IconProvider {
  splash(imageName: 'splash.png'),
  accept(imageName: 'accept.png'),
  accept_a(imageName: 'accept_a.png'),
  history(imageName: 'history.png'),
  history_a(imageName: 'history_a.png'),
  home(imageName: 'home.png'),
  home_a(imageName: 'home_a.png'),
  shop(imageName: 'shop.png'),
  shop_a(imageName: 'shop_a.png'),
  logo(imageName: 'logo.png'),
  notifications(imageName: 'notifications.png'),
  settings(imageName: 'settings.png'),
  checkBox(imageName: 'check_box.png'),
  mark(imageName: 'mark.png'),
  export(imageName: 'export.png'),
  share(imageName: 'share.png'),
  frame(imageName: 'frame.png'),
  add(imageName: 'add.png'),

  unknown(imageName: '');

  const IconProvider({
    required this.imageName,
  });

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name.png';
}
