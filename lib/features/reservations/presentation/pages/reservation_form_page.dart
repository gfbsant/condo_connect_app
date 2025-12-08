import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../facilities/domain/entities/facility_entity.dart';
import '../../../facilities/presentation/providers/facility_providers.dart'
    show facilityNotifierAccessor, facilityNotifierProvider;
import '../../../facilities/presentation/providers/facility_state.dart';
import '../../domain/entities/reservation_entity.dart';
import '../providers/reservation_notifier.dart';
import '../providers/reservation_providers.dart';

class ReservationFormPage extends ConsumerStatefulWidget {
  const ReservationFormPage({
    required this.condominiumId,
    required this.apartmentId,
    super.key,
  });

  final int apartmentId;
  final int condominiumId;

  @override
  ConsumerState<ReservationFormPage> createState() =>
      _ReservationFormPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('apartmentId', apartmentId))
      ..add(IntProperty('condominiumId', condominiumId));
  }
}

class _ReservationFormPageState extends ConsumerState<ReservationFormPage> {
  DateTime? _selectedDate;
  FacilityEntity? _selectedFacility;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(facilityNotifierAccessor)
          .getFacilitiesByCondo(widget.condominiumId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        reservationNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
          }
        },
      )
      ..listen(
        reservationNotifierProvider.select(
          (final state) => state.successMessage,
        ),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
          }
        },
      );

    final bool isLoading = ref.watch(isLoadingProvider);
    final FacilityState facilityState = ref.watch(facilityNotifierProvider);
    final List<FacilityEntity> facilities = facilityState.facilities;
    final isLoadingFacilities = facilityState.status == .searching;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const ReservationFormAppBar(),
      body: ReservationFormBody(
        selectedDate: _selectedDate,
        selectedFacility: _selectedFacility,
        facilities: facilities,
        isLoading: isLoading,
        isLoadingFacilities: isLoadingFacilities,
        onFacilitySelected: _selectFacility,
        onDateSelect: _selectDate,
        onSubmit: _handleSubmit,
      ),
    );
  }

  void _showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: .floating,
      ),
    );
  }

  void _showSuccessSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          spacing: 8,
          children: [
            const Icon(Icons.check_circle),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: .floating,
      ),
    );
  }

  void _selectFacility(final FacilityEntity? facility) {
    if (facility != null) {
      setState(() => _selectedFacility = facility);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (_selectedFacility == null) {
      _showErrorSnackBar('Por favor, selecione uma área comum');
      return;
    }

    if (_selectedDate == null) {
      _showErrorSnackBar('Por favor, selecione uma data');
      return;
    }

    final int? facilityId = _selectedFacility?.id;

    if (facilityId != null) {
      final reservation = ReservationEntity(
        facilityId: facilityId,
        apartmentId: widget.apartmentId,
        scheduledDate: _selectedDate,
      );

      final ReservationNotifier notifier = ref.read(
        reservationNotifierAccessor,
      );

      final bool success = await notifier.createReservation(
        facilityId,
        reservation,
      );

      if (success) {
        await HapticFeedback.lightImpact();
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }
}

class ReservationFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ReservationFormAppBar({super.key});

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Nova Reserva'),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ReservationFormBody extends StatelessWidget {
  const ReservationFormBody({
    required this.selectedDate,
    required this.selectedFacility,
    required this.facilities,
    required this.isLoading,
    required this.isLoadingFacilities,
    required this.onFacilitySelected,
    required this.onDateSelect,
    required this.onSubmit,
    super.key,
  });

  final DateTime? selectedDate;
  final FacilityEntity? selectedFacility;
  final List<FacilityEntity> facilities;
  final bool isLoading;
  final bool isLoadingFacilities;
  final ValueChanged<FacilityEntity?> onFacilitySelected;
  final Future<void> Function() onDateSelect;
  final Future<void> Function() onSubmit;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const .symmetric(horizontal: 24, vertical: 16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: .stretch,
        children: [
          const _Header(),
          const SizedBox(height: 16),
          _FacilityField(
            selectedFacility: selectedFacility,
            facilities: facilities,
            onChanged: onFacilitySelected,
            isEnabled: !isLoading && !isLoadingFacilities,
            isLoading: isLoadingFacilities,
          ),
          _DateField(
            selectedDate: selectedDate,
            onTap: onDateSelect,
            isEnabled: !isLoading,
          ),
          const SizedBox(height: 16),
          _SubmitButton(onPressed: onSubmit, isLoading: isLoading),
        ],
      ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('selectedDate', selectedDate))
      ..add(
        DiagnosticsProperty<FacilityEntity?>(
          'selectedFacility',
          selectedFacility,
        ),
      )
      ..add(IterableProperty<FacilityEntity>('facilities', facilities))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(
        DiagnosticsProperty<bool>('isLoadingFacilities', isLoadingFacilities),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<FacilityEntity?>>.has(
          'onFacilitySelected',
          onFacilitySelected,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'onDateSelect',
          onDateSelect,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onSubmit', onSubmit),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      spacing: 12,
      children: [
        Icon(
          Icons.event_available_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          'Preencha as informações de reserva',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: .center,
        ),
      ],
    );
  }
}

class _FacilityField extends StatelessWidget {
  const _FacilityField({
    required this.selectedFacility,
    required this.facilities,
    required this.onChanged,
    required this.isEnabled,
    required this.isLoading,
  });

  final FacilityEntity? selectedFacility;
  final List<FacilityEntity> facilities;
  final ValueChanged<FacilityEntity?> onChanged;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (isLoading) {
      return const InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.location_city),
          labelText: 'Area Comum',
        ),
        child: SizedBox(
          height: 20,
          child: Center(
            child: SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            ),
          ),
        ),
      );
    }
    if (facilities.isEmpty) {
      return InputDecorator(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.location_city),
          labelText: 'Área comum',
        ),
        child: Text(
          'Nenhuma área comum disponível',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
    return DropdownButtonFormField<FacilityEntity>(
      initialValue: selectedFacility,
      onChanged: isEnabled ? onChanged : null,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.location_city),
        labelText: 'Área Comum',
        hintText: 'Selecione',
      ),
      items: facilities
          .map(
            (final facility) => DropdownMenuItem<FacilityEntity>(
              value: facility,
              child: Text(facility.name),
            ),
          )
          .toList(),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<FacilityEntity?>(
          'selectedFacility',
          selectedFacility,
        ),
      )
      ..add(IterableProperty<FacilityEntity>('facilities', facilities))
      ..add(
        ObjectFlagProperty<ValueChanged<FacilityEntity?>>.has(
          'onChanged',
          onChanged,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.selectedDate,
    required this.onTap,
    required this.isEnabled,
  });

  final DateTime? selectedDate;
  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: .circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          labelText: 'Data da Reserva',
          hintText: 'Selecione uma data',
          enabled: isEnabled,
        ),
        child: Text(
          selectedDate != null ? dateFormat.format(selectedDate!) : '',
          style: selectedDate != null
              ? theme.textTheme.bodyLarge
              : theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
                ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DateTime?>('selectedDate', selectedDate))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onPressed, required this.isLoading});

  final Future<void> Function() onPressed;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(padding: const .symmetric(vertical: 12)),
    child: isLoading
        ? Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          )
        : const Text(
            'Criar Reserva',
            style: TextStyle(fontWeight: .bold, fontSize: 12),
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onPressed', onPressed),
      )
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}
