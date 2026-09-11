enum AppRoute {
  home('/'),
  signIn('/sign-in'),
  signUp('/sign-up'),
  locationGate('/location-gate'),
  books('/books'),
  bookDetail('/books/:id');

  const AppRoute(this.path);

  final String path;

  static String bookDetailPath(int id) => '/books/$id';
}