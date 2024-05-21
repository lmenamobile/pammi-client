import 'package:permission_handler/permission_handler.dart';

abstract class InterfacePhoto {

  void selectCamera();

  void selectGallery();

  void validateStatusPermission(PermissionStatus status, String bandOptions);

}