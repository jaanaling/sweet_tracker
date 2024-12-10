enum RouteValue {
  splash(
    path: '/',
  ),
  home(
    path: '/home',
  ),
  catalog(
    path: '/catalog',
  ),
  diary(
    path: '/diary',
  ),
  info(
    path: 'info',
  ),
  write(
    path: 'write',
  ),
  generator(
    path: '/generator',
  ),
  tamples(
    path: 'tamples',
  ),

  unknown(
    path: '',
  );

  final String path;
  const RouteValue({
    required this.path,
  });
}
