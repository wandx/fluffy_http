import 'package:chopper/chopper.dart';

/// Response Extension
extension ResponseExtension on Response<dynamic> {
  /// Transform response to map
  Map<String, dynamic> toMap({bool throughData = true}) {
    if (throughData) {
      final b = body as Map;
      final data = b['data'] as Map<String, dynamic>;
      return data;
    }
    return body as Map<String, dynamic>;
  }

  /// Transform response to list
  List<dynamic> toList({bool throughData = true}) {
    if (throughData) {
      final b = body as Map;
      final data = b['data'] as List;
      return data;
    }

    return body as List;
  }
}
