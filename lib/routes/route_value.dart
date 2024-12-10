enum RouteValue {
  splash(
    path: '/',
  ),
  home(
    path: '/home',
  ),
  confirmation(
    path: '/confirmation',
  ),
  add(
    path: 'add',
  ),
  notification(
    path: 'notification',
  ),
  shopping(
    path: '/shopping',
  ),
  history(
    path: '/history',
  ),

  unknown(
    path: '',
  );

  final String path;
  const RouteValue({
    required this.path,
  });
}
