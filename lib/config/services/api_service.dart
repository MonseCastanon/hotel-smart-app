import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/models/room_model.dart';

/// Servicio para consultar la API del backend.
class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://10.0.2.2:3000/api',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  /// Obtiene la lista de habitaciones desde la API.
  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await _dio.get('/rooms');
      final data = response.data;
      
      final List<dynamic> jsonList = data is List
          ? data
          : data['data'] ?? data['rooms'] ?? [];

      return jsonList.map((json) => RoomModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al cargar habitaciones del API: $e');
    }
  }
}

/// Provider de la instancia de [ApiService].
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
