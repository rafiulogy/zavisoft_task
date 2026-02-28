class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String login = '$baseUrl/auth/login';
  static const String users = '$baseUrl/users';
  static const String products = '$baseUrl/products';

  static String getUserById(int id) => '$users/$id';
  static String getProductById(int id) => '$products/$id';
}
