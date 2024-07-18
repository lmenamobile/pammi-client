
import '../config.dart';

class ApiRoutes {

  static final String baseUrl                  = Environment.apiUrl;
  static final String categoryGetDepartments   = '$baseUrl/category/get-departments';
  static final String assetCategories          = 'https://pamii-preproduction.s3.amazonaws.com/pamii/categories/ic_categories.svg';
  static final String getBanners               = '$baseUrl/home/get-banners';


}