import '../../../../core/services/network_caller.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../models/product_model.dart';

class ProductService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Fetches all products from GET /products.
  /// Returns a list of [ProductModel] on success, empty list on failure.
  Future<List<ProductModel>> getAllProducts({String? token}) async {
    final response = await _networkCaller.getRequest(
      ApiConstants.products,
      token: token,
    );

    if (response.isSuccess && response.responseData != null) {
      final List data = response.responseData as List;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    }
    return [];
  }

  /// Fetches a single product by ID from GET /products/{id}.
  Future<ProductModel?> getProductById(int id, {String? token}) async {
    final response = await _networkCaller.getRequest(
      ApiConstants.getProductById(id),
      token: token,
    );

    if (response.isSuccess && response.responseData != null) {
      return ProductModel.fromJson(response.responseData);
    }
    return null;
  }
}
