
import '../config.dart';

class ApiRoutes {

  static final String baseUrl                    = Environment.apiUrl;
  static final String categoryGetDepartments     = '$baseUrl/category/get-departments';
  static final String assetCategories            = 'https://pamii-preproduction.s3.amazonaws.com/pamii/categories/ic_categories.svg';
  static final String getBanners                 = '$baseUrl/home/get-banners';
  static final String getBrands                  = '$baseUrl/home/get-brands';
  static final String getCategoriesByDepartment  = '$baseUrl/category/get-categories';
  static final String getSubCategoriesByCategory = '$baseUrl/category/get-subcategories';
  static final String getProducts                = '$baseUrl/product/get-products';

}