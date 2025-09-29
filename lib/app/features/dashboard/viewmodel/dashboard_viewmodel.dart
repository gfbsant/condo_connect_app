import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../data/interfaces/user_preferences_repository_interface.dart';
import '../../../data/models/permission.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/user_preferences.dart';
import '../../../data/models/user_role.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../model/dashboard_item.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(
    this._authViewModel,
    this._preferencesRepository,
  ) {
    _loadPreferences();
  }
  final AuthViewModel _authViewModel;
  final UserPreferencesRepositoryInterface _preferencesRepository;

  UserPreferences? _preferences;
  var _isLoading = false;
  var _isReorderMode = false;
  List<DashboardItem> _orderedItems = [];

  User? get currentUser => _authViewModel.authResponse?.user;
  String? get currentUserId => currentUser?.id;
  bool get isLoading => _isLoading;
  bool get isReorderMode => _isReorderMode;

  ThemeMode get themeMode => _preferences?.themeMode ?? ThemeMode.system;
  DashboardViewType get dashboardViewType =>
      _preferences?.dashboardViewType ?? DashboardViewType.grid;
  int get itemsPerRow => _preferences?.itemsPerRow ?? 2;
  bool get showNotificationBadges =>
      _preferences?.showNotificationBadges ?? true;
  bool get enableSounds => _preferences?.enableSounds ?? true;
  String get language => _preferences?.language ?? 'pt_BR';
  List<String> get dashboardOrder => _preferences?.dashboardOrder ?? [];
  Map<String, bool> get hiddenItems => _preferences?.hiddenItems ?? {};

  List<DashboardItem> get dashboardItems {
    final List<DashboardItem> items =
        _orderedItems.isNotEmpty ? _orderedItems : _getDefaultDashboardItems();
    return items.where((final item) => !isItemHidden(item.route)).toList();
  }

  List<DashboardItem> get allDashboardItems =>
      _orderedItems.isNotEmpty ? _orderedItems : _getDefaultDashboardItems();

  String get welcomeMessage {
    final User? user = currentUser;
    if (user == null) {
      return 'Bem-vindo!';
    }

    final int timeOfDay = DateTime.now().hour;
    String greeting;

    if (timeOfDay >= 6 && timeOfDay < 12) {
      greeting = 'Bom dia';
    } else if (timeOfDay < 18) {
      greeting = 'Boa tarde';
    } else {
      greeting = 'Boa noite';
    }
    return '$greeting, ${user.name.split(' ').first}!';
  }

  String get roleDisplayName {
    final User? user = currentUser;
    if (user == null) {
      return '';
    }

    switch (user.role) {
      case UserRole.resident:
        return 'Morador';
      case UserRole.manager:
        return 'Síndico';
      case UserRole.doorman:
        return 'Porteiro';
    }
  }

  bool hasPermission(final Permission permission) {
    final User? user = currentUser;
    if (user == null) {
      return false;
    }

    final Map<UserRole, Set<Permission>> rolePermissions = {
      UserRole.resident: {
        Permission.createTicket,
        Permission.searchCondos,
      },
      UserRole.manager: {
        Permission.manageUsers,
        Permission.manageAparments,
        Permission.viewAllTickets,
        Permission.createTicket,
        Permission.searchCondos,
        Permission.viewReports,
        Permission.manageNotifications,
        Permission.adminAccess,
      },
      UserRole.doorman: {
        Permission.viewAllTickets,
        Permission.createTicket,
        Permission.searchCondos,
        Permission.manageVisitors,
        Permission.manageMail,
      },
    };

    return rolePermissions[user.role]?.contains(permission) ?? false;
  }

  Map<String, int> get pendingCounts {
    final User? user = currentUser;
    if (user == null) {
      return {};
    }

    switch (user.role) {
      case UserRole.resident:
        return {'tickets': 2, 'notifications': 3};
      case UserRole.manager:
        return {'tickets': 3, 'users': 1, 'apartments': 8, 'notifications': 2};
      case UserRole.doorman:
        return {'tickets': 3, 'visitors': 0, 'mail': 2, 'notifications': 2};
    }
  }

  Future<void> updateThemeMode(final ThemeMode mode) async {
    await _updatePreference((final prefs) => prefs.copyWith(themeMode: mode));
  }

  Future<void> updateDashboardViewType(final DashboardViewType viewType) async {
    await _updatePreference(
      (final prefs) => prefs.copyWith(dashboardViewType: viewType),
    );
    notifyListeners();
  }

  Future<void> updateItemsPerRow(final int items) async {
    if (items < 1 || items > 4) {
      return;
    }
    await _updatePreference(
      (final prefs) => prefs.copyWith(itemsPerRow: items),
    );
  }

  Future<void> updateShowNotificationBadges(final bool show) async {
    await _updatePreference(
      (final prefs) => prefs.copyWith(showNotificationBadges: show),
    );
  }

  Future<void> updateEnableSounds(final bool enable) async {
    await _updatePreference(
      (final prefs) => prefs.copyWith(enableSounds: enable),
    );
  }

  Future<void> updateLanguage(final String lang) async {
    await _updatePreference((final prefs) => prefs.copyWith(language: lang));
  }

  Future<void> updateDashboardOrder(final List<String> order) async {
    await _updatePreference(
      (final prefs) => prefs.copyWith(dashboardOrder: order),
    );
  }

  Future<void> hideItem(final String itemRoute) async {
    final hiddenItems = Map<String, bool>.from(_preferences?.hiddenItems ?? {});
    hiddenItems.remove(itemRoute);
    await _updatePreference(
      (final prefs) => prefs.copyWith(hiddenItems: hiddenItems),
    );
  }

  Future<void> showItem(final String itemRoute) async {
    final hiddenItems = Map<String, bool>.from(_preferences?.hiddenItems ?? {});
    hiddenItems.remove(itemRoute);
    await _updatePreference(
      (final prefs) => prefs.copyWith(hiddenItems: hiddenItems),
    );
  }

  bool isItemHidden(final String itemRoute) => hiddenItems[itemRoute] ?? false;

  void toggleReorderMode() {
    _isReorderMode = !_isReorderMode;
    notifyListeners();
  }

  void exitReorderMode() {
    _isReorderMode = false;
    notifyListeners();
  }

  Future<void> reorderItems(final int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final List<DashboardItem> items = List.from(dashboardItems);
    final DashboardItem item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    _orderedItems = items;
    notifyListeners();

    await _saveDashboardOrder();
  }

  Future<void> resetToDefaultOrder() async {
    _orderedItems = _getDefaultDashboardItems();
    notifyListeners();
    await _saveDashboardOrder();
  }

  void navigateToItem(
    final DashboardItem item,
    final Function(String) navigationCallback,
  ) {
    if (!item.isEnabled) {
      return;
    }
    if (enableSounds) {
      log('Playing navigation sound');
    }
    log('Navigating to: ${item.title} - Route: ${item.route}');
    navigationCallback(item.route);
  }

  Future<void> logout() async {
    await _authViewModel.logout();
  }

  Future<void> refresh() async {
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final String? userId = currentUserId;
    if (userId == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _preferences = await _preferencesRepository.getUserPreferences(userId);

      if (_preferences != null && _preferences!.dashboardOrder.isNotEmpty) {
        _loadDashboardOrder(_preferences!.dashboardOrder);
      } else {
        _orderedItems = _getDefaultDashboardItems();
      }
    } on Exception catch (e) {
      log('Error loading user preferences: $e');
      _preferences = null;
      _orderedItems = _getDefaultDashboardItems();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _updatePreference(
    final UserPreferences Function(UserPreferences) updater,
  ) async {
    final String? userId = currentUserId;
    if (userId == null) {
      return;
    }

    final UserPreferences currentPrefs = _preferences ??
        UserPreferences(userId: userId, lastUpdated: DateTime.now());

    final UserPreferences updatedPrefs =
        updater(currentPrefs).copyWith(lastUpdated: DateTime.now());

    final bool success =
        await _preferencesRepository.saveUserPreferences(updatedPrefs);

    if (success) {
      _preferences = updatedPrefs;
      notifyListeners();
    }
  }

  Future<void> _saveDashboardOrder() async {
    final List<String> order =
        allDashboardItems.map((final item) => item.route).toList();
    await updateDashboardOrder(order);
  }

  void _loadDashboardOrder(final List<String> savedOrder) {
    final List<DashboardItem> defaultItems = _getDefaultDashboardItems();
    final orderedItems = <DashboardItem>[];

    for (final route in savedOrder) {
      final DashboardItem item = defaultItems.firstWhere(
        (final item) => item.route == route,
        orElse: () => const DashboardItem(
          title: '',
          subtitle: '',
          icon: Icons.error,
          color: Colors.grey,
          route: '',
          isEnabled: false,
        ),
      );
      if (item.route.isNotEmpty && item.isEnabled) {
        orderedItems.add(item);
      }
    }

    for (final item in defaultItems) {
      if (!savedOrder.contains(item.route)) {
        orderedItems.add(item);
      }
    }
    _orderedItems = orderedItems;
  }

  List<DashboardItem> _getDefaultDashboardItems() {
    final User? user = currentUser;
    if (user == null) {
      return [];
    }

    final baseItems = <DashboardItem>[
      const DashboardItem(
        title: 'Meu Perfil',
        subtitle: 'Central de avisos e comunicados',
        icon: Icons.person,
        color: Colors.orange,
        route: '/perfil',
      ),
    ];

    final conditionalItems = <DashboardItem>[
      if (hasPermission(Permission.viewAllTickets))
        DashboardItem(
          title: 'Chamados',
          subtitle: 'Gerenciar todos os chamados',
          icon: Icons.support_agent,
          color: Colors.blue,
          route: '/chamados',
          badgeCount: showNotificationBadges ? pendingCounts['chamados'] : null,
        ),
      if (hasPermission(Permission.createTicket))
        const DashboardItem(
          title: 'Novo Chamado',
          subtitle: 'Criar novo chamado',
          icon: Icons.add_box,
          color: Colors.green,
          route: '/novo-chamado',
        ),
      if (hasPermission(Permission.manageUsers))
        DashboardItem(
          title: 'Usuários',
          subtitle: 'Gerenciar usuarios do condomínio',
          icon: Icons.people,
          color: Colors.purple,
          route: '/usuarios',
          badgeCount: showNotificationBadges ? pendingCounts['usuarios'] : null,
        ),
      if (hasPermission(Permission.manageAparments))
        DashboardItem(
          title: 'Apartamentos',
          subtitle: 'Gerenciar apartamentos',
          icon: Icons.home,
          color: Colors.teal,
          route: '/apartamentos',
          badgeCount:
              showNotificationBadges ? pendingCounts['apartamentos'] : null,
        ),
      if (hasPermission(Permission.searchCondos))
        const DashboardItem(
          title: 'Condomínios',
          subtitle: 'Buscar condomínios',
          icon: Icons.business,
          color: Colors.indigo,
          route: '/condominios',
        ),
      if (hasPermission(Permission.manageVisitors))
        DashboardItem(
          title: 'Visitantes',
          subtitle: 'Controle de visitantes',
          icon: Icons.badge,
          color: Colors.amber,
          route: '/visitantes',
          badgeCount:
              showNotificationBadges ? pendingCounts['visitantes'] : null,
        ),
      if (hasPermission(Permission.manageMail))
        DashboardItem(
          title: 'Correspondência',
          subtitle: 'Gerenciar correspondências',
          icon: Icons.mail,
          color: Colors.red,
          route: 'correspondencia',
          badgeCount:
              showNotificationBadges ? pendingCounts['correspondencia'] : null,
        ),
      if (hasPermission(Permission.viewReports))
        const DashboardItem(
          title: 'Relatorios',
          subtitle: 'Visualizar relatórios',
          icon: Icons.assessment,
          color: Colors.brown,
          route: '/relatorios',
        ),
      DashboardItem(
        title: 'Notificações',
        subtitle: 'Minhas notificações',
        icon: Icons.notifications,
        color: Colors.deepOrange,
        route: '/notificacoes',
        badgeCount:
            showNotificationBadges ? pendingCounts['notificacoes'] : null,
      ),
    ];

    return [...baseItems, ...conditionalItems];
  }
}
