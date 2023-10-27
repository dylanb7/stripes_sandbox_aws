import 'package:stripes_backend_helper/stripes_backend_helper.dart';

class Accessed extends AccessCodeRepo {
  Accessed() {
    workingCode("Access");
  }

  @override
  Future<String?> codeValid(String code) async {
    return code;
  }

  @override
  Future<void> removeCode() {
    throw UnimplementedError();
  }
}
