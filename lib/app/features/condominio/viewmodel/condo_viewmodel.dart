import 'package:flutter/material.dart';

import '../../../data/interfaces/condo_service_interface.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/condo_model.dart';

class CondoViewModel extends ChangeNotifier {
  CondoViewModel({
    required final CondoServiceInterface condoService,
  }) : _condoService = condoService;

  final CondoServiceInterface _condoService;

  List<Condo> _condos = [];
  Condo? _selectedCondo;
  var _isLoading = false;
  String? _errorMessage;

  List<Condo> get condos => _condos;
  Condo? get selectedCondo => _selectedCondo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> createCondo(final Condo condo) async {
    _setLoading(true);
    if (_errorMessage != null) {
      _setErrorMsg(null);
    }

    try {
      final ApiResponse<Condo> response =
          await _condoService.createCondo(condo);

      if (response.success && response.data != null) {
        _condos.add(response.data!);
        return true;
      } else {
        _setErrorMsg(response.message ?? 'Erro ao criar condomínio');
        return false;
      }
    } on Exception catch (e) {
      _setErrorMsg('Erro inesperado: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateCondo(final int id, final Condo condo) async {
    _setLoading(true);
    if (_errorMessage != null) {
      _setErrorMsg(null);
    }

    try {
      final ApiResponse<Condo> response =
          await _condoService.updateCondo(id, condo);

      if (response.success && response.data != null) {
        final int index = _condos.indexWhere((final c) => c.id == id);
        if (index != -1) {
          _condos[index] = response.data!;
          notifyListeners();
        }
        return true;
      } else {
        _setErrorMsg(response.message ?? 'Erro ao atualizar condomínio');
        return false;
      }
    } on Exception catch (e) {
      _setErrorMsg('Erro inesperado: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getAllCondos() async {
    _setLoading(true);
    if (_errorMessage != null) {
      _setErrorMsg(null);
    }

    try {
      final ApiResponse<List<Condo>> response =
          await _condoService.getAllCondos();

      if (response.success && response.data != null) {
        _condos = response.data!;
      } else {
        _setErrorMsg(response.message ?? 'Erro ao carregar condominios');
      }
    } on Exception catch (e) {
      _setErrorMsg('Erro inesperado: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getCondoById(final int id) async {
    _setLoading(true);
    if (_errorMessage != null) {
      _setErrorMsg(null);
    }

    try {
      final ApiResponse<Condo> response = await _condoService.getCondoById(id);
      if (response.success && response.data != null) {
        _selectedCondo = response.data;
      } else {
        _setErrorMsg(response.message ?? 'Erro ao carregar condomínio');
      }
    } on Exception catch (e) {
      _setErrorMsg('Erro inesperado: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteCondo(final int id) async {
    _setLoading(true);
    if (_errorMessage != null) {
      _setErrorMsg(null);
    }

    try {
      final ApiResponse<void> response = await _condoService.deleteCondo(id);

      if (response.success) {
        _condos.removeWhere((final c) => c.id == id);
        notifyListeners();
        return true;
      } else {
        _setErrorMsg(response.message ?? 'Erro ao deletar condominio');
        return false;
      }
    } on Exception catch (e) {
      _setErrorMsg('Erro inesperado: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setErrorMsg(null);
  }

  void clearSelectedCondo() {
    _selectedCondo = null;
    notifyListeners();
  }

  void _setLoading(final bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMsg(final String? error) {
    _errorMessage = error;
    notifyListeners();
  }
}
