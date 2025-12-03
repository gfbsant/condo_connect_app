import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/validators.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_status.dart';
import '../../domain/enums/notice_type.dart';
import '../providers/notice_notifier.dart';
import '../providers/notice_providers.dart';

class NoticeFormPage extends ConsumerStatefulWidget {
  const NoticeFormPage({required this.apartmentId, super.key, this.notice});

  final int apartmentId;
  final NoticeEntity? notice;

  @override
  ConsumerState<NoticeFormPage> createState() => _NoticeFormPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('apartmentId', apartmentId))
      ..add(DiagnosticsProperty<NoticeEntity?>('notice', notice));
  }
}

class _NoticeFormPageState extends ConsumerState<NoticeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeInfoController = TextEditingController();

  NoticeType _selectedType = NoticeType.communication;
  NoticeStatus _selectedStatus = NoticeStatus.pending;

  bool get _isEditing => widget.notice != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final NoticeEntity notice = widget.notice!;
    _titleController.text = notice.title;
    _descriptionController.text = notice.description ?? '';
    _typeInfoController.text = notice.typeInfo ?? '';
    _selectedType = notice.noticeType;
    _selectedStatus = notice.status;
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        noticeNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen<String?>(
        noticeNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final bool isLoading = ref.read(isLoadingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: NoticeFormAppBar(isEditing: _isEditing),
      body: NoticeFormBody(
        formKey: _formKey,
        titleController: _titleController,
        descriptionController: _descriptionController,
        typeInfoController: _typeInfoController,
        selectedType: _selectedType,
        selectedStatus: _selectedStatus,
        isLoading: isLoading,
        isEditing: _isEditing,
        onTypeChange: _updateType,
        onStatusChange: _updateStatus,
        onSubmit: _handleSubmit,
      ),
    );
  }

  void _clearMessages() => ref.read(noticeNotifierAccessor).clearMessages();

  void _showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
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
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final String descriptionText = _descriptionController.text.trim();
    final String typeInfoText = _typeInfoController.text.trim();

    final notice = NoticeEntity(
      id: _isEditing ? widget.notice?.id : null,
      creatorId: _isEditing
          ? widget.notice!.creatorId
          : 1, // TODO(gfbsant): Get from auth
      title: _titleController.text.trim(),
      description: descriptionText.isNotEmpty ? descriptionText : null,
      noticeType: _selectedType,
      status: _selectedStatus,
      typeInfo: typeInfoText.isNotEmpty ? typeInfoText : null,
      apartmentId: widget.apartmentId,

      createdAt: widget.notice?.createdAt,
    );

    final NoticeNotifier notifier = ref.read(noticeNotifierAccessor);

    var success = false;

    if (_isEditing) {
      final int? id = widget.notice?.id;
      if (id != null) {
        success = await notifier.updateNotice(id, notice);
      }
    } else {
      success = await notifier.createNotice(widget.apartmentId, notice);
    }

    if (success) {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _navigateBack();
      }
    }
  }

  void _updateType(final NoticeType? newType) {
    if (newType != null) {
      setState(() {
        _selectedType = newType;
      });
    }
  }

  void _updateStatus(final NoticeStatus? newStatus) {
    if (newStatus != null) {
      setState(() {
        _selectedStatus = newStatus;
      });
    }
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _typeInfoController.dispose();
    super.dispose();
  }
}

class NoticeFormAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoticeFormAppBar({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: Text(isEditing ? 'Editar Aviso' : 'Novo Aviso'),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class NoticeFormBody extends StatelessWidget {
  const NoticeFormBody({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.typeInfoController,
    required this.selectedType,
    required this.selectedStatus,
    required this.isLoading,
    required this.isEditing,
    required this.onTypeChange,
    required this.onStatusChange,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController typeInfoController;
  final NoticeType selectedType;
  final NoticeStatus selectedStatus;
  final bool isLoading;
  final bool isEditing;
  final ValueChanged<NoticeType?> onTypeChange;
  final ValueChanged<NoticeStatus> onStatusChange;
  final Future<void> Function() onSubmit;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(isEditing: isEditing),
            const SizedBox(height: 4),
            _TitleField(controller: titleController, isEnabled: !isLoading),
            _DescriptionField(
              controller: descriptionController,
              isEnabled: !isLoading,
            ),
            _NoticeTypeDropdown(
              selectedType: selectedType,
              onChanged: onTypeChange,
              isEnabled: !isLoading,
            ),
            if (isEditing) ...[
              _NoticeStatusDropdown(
                selectedStatus: selectedStatus,
                onChanged: onStatusChange,
                isEnabled: !isLoading,
              ),
            ],
            _TypeInfoField(
              controller: typeInfoController,
              isEnabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _SubmitButton(
              isLoading: isLoading,
              isEditing: isEditing,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GlobalKey<FormState>>('formKey', formKey))
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'titleController',
          titleController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'descriptionController',
          descriptionController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'typeInfoController',
          typeInfoController,
        ),
      )
      ..add(EnumProperty<NoticeType>('selectedType', selectedType))
      ..add(EnumProperty<NoticeStatus>('selectedStatus', selectedStatus))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(
        ObjectFlagProperty<ValueChanged<NoticeType?>>.has(
          'onTypeChange',
          onTypeChange,
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<NoticeStatus>>.has(
          'onStatusChange',
          onStatusChange,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onSubmit', onSubmit),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      spacing: 12,
      children: [
        Icon(
          isEditing ? Icons.edit_outlined : Icons.notification_add_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          isEditing
              ? 'Atualize as informações do aviso'
              : 'Preencha as informações do aviso',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    validator: Validators.validateRequired,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.title),
      labelText: 'Título',
      hintText: 'Ex: Entrega de encomenda',
    ),
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.sentences,
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      labelText: 'Descrição (opcional)',
      hintText: 'Adicione detalhes sobre o aviso',
    ),
    textInputAction: TextInputAction.next,
    textCapitalization: TextCapitalization.sentences,
    maxLength: 60,
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _NoticeTypeDropdown extends StatelessWidget {
  const _NoticeTypeDropdown({
    required this.selectedType,
    required this.onChanged,
    required this.isEnabled,
  });

  final NoticeType selectedType;
  final ValueChanged<NoticeType?> onChanged;
  final bool isEnabled;

  String _typeLabel(final NoticeType type) => switch (type) {
    NoticeType.communication => 'Comunicado',
    NoticeType.delivery => 'Entrega',
    NoticeType.maintenance => 'Manutenção',
    NoticeType.visitor => 'Visitante',
  };

  @override
  Widget build(final BuildContext context) =>
      DropdownButtonFormField<NoticeType>(
        initialValue: selectedType,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.category),
          labelText: 'Tipo de Aviso',
        ),
        items: NoticeType.values
            .map(
              (final type) =>
                  DropdownMenuItem(value: type, child: Text(_typeLabel(type))),
            )
            .toList(),
        onChanged: (final value) => isEnabled ? onChanged : null,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled))
      ..add(
        ObjectFlagProperty<Function(NoticeType? value)>.has(
          'onChanged',
          onChanged,
        ),
      )
      ..add(EnumProperty<NoticeType>('selectedType', selectedType));
  }
}

class _NoticeStatusDropdown extends StatelessWidget {
  const _NoticeStatusDropdown({
    required this.selectedStatus,
    required this.onChanged,
    required this.isEnabled,
  });

  final NoticeStatus selectedStatus;
  final ValueChanged<NoticeStatus> onChanged;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) =>
      DropdownButtonFormField<NoticeStatus>(
        initialValue: selectedStatus,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.flag),
          labelText: 'Status',
        ),
        items: _getAllowedStatusTransitions()
            .map(
              (final status) => DropdownMenuItem(
                value: status,
                child: Text(_getStatusLabel(status)),
              ),
            )
            .toList(),
        onChanged: (final value) => isEnabled ? onChanged : null,
      );

  List<NoticeStatus> _getAllowedStatusTransitions() {
    final allowed = <NoticeStatus>[selectedStatus];
    for (final NoticeStatus status in NoticeStatus.values) {
      if (selectedStatus.canTransitionTo(status) && !allowed.contains(status)) {
        allowed.add(status);
      }
    }
    return allowed;
  }

  String _getStatusLabel(final NoticeStatus status) => switch (status) {
    NoticeStatus.pending => 'Pendente',
    NoticeStatus.acknowledged => 'Em Andamento',
    NoticeStatus.resolved => 'Resolvido',
    NoticeStatus.blocked => 'Bloqueado',
  };

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<NoticeStatus>('selectedStatus', selectedStatus))
      ..add(
        ObjectFlagProperty<ValueChanged<NoticeStatus>>.has(
          'onChanged',
          onChanged,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _TypeInfoField extends StatelessWidget {
  const _TypeInfoField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.info_outline),
      labelText: 'Informações Adicionais (opcional)',
      hintText: 'Ex: Nome do visitante, empresa de entrega',
    ),
    textInputAction: TextInputAction.done,
    textCapitalization: TextCapitalization.sentences,
    maxLength: 100,
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.onPressed,
    required this.isEditing,
    required this.isLoading,
  });

  final bool isLoading;
  final bool isEditing;
  final Future<void> Function() onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading
        ? null
        : () async {
            await onPressed();
          },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
    child: isLoading
        ? Center(
            child: SizedBox(
              height: 24,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          )
        : Text(
            isEditing ? 'Atualizar' : 'Criar',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<Function()>.has('onPressed', onPressed))
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}
