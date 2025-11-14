import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/car.dart';
import '../bloc/car_bloc.dart';
import '../bloc/car_event.dart';
import '../bloc/car_state.dart';

class CarFormScreen extends StatefulWidget {
  const CarFormScreen({super.key, this.carId});

  final String? carId;

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _initialized = false;
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _registrationController;
  late final TextEditingController _mileageController;
  late final TextEditingController _colorController;
  late final TextEditingController _ownerController;
  late final TextEditingController _notesController;
  late final TextEditingController _tagsController;
  bool _isFavorite = false;
  CarStatus _status = CarStatus.inProgress;
  int? _rating;
  DateTime? _scheduledAt;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController();
    _modelController = TextEditingController();
    _yearController = TextEditingController();
    _registrationController = TextEditingController();
    _mileageController = TextEditingController();
    _colorController = TextEditingController();
    _ownerController = TextEditingController();
    _notesController = TextEditingController();
    _tagsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    if (widget.carId != null) {
      final state = context.read<CarBloc>().state;
      final car = state.cars.firstWhere((element) => element.id == widget.carId);
      _brandController.text = car.brand;
      _modelController.text = car.model;
      _yearController.text = car.year.toString();
      _registrationController.text = car.registrationNumber;
      _mileageController.text = car.mileage.toString();
      _colorController.text = car.color;
      _ownerController.text = car.owner;
      _notesController.text = car.notes;
      _tagsController.text = car.tags.join(', ');
      _isFavorite = car.isFavorite;
      _status = car.status;
      _rating = car.rating;
      _scheduledAt = car.scheduledAt;
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _registrationController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _ownerController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _scheduledAt ?? now;
    final picked = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      initialDate: initial,
    );
    if (picked != null) {
      setState(() => _scheduledAt = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final year = int.parse(_yearController.text.trim());
    final mileage = int.parse(_mileageController.text.trim());
    context.read<CarBloc>().add(
          CarSaved(
            id: widget.carId,
            brand: _brandController.text.trim(),
            model: _modelController.text.trim(),
            year: year,
            registrationNumber: _registrationController.text.trim(),
            mileage: mileage,
            color: _colorController.text.trim(),
            owner: _ownerController.text.trim(),
            notes: _notesController.text.trim(),
            status: _status,
            isFavorite: _isFavorite,
            rating: _rating,
            scheduledAt: _scheduledAt,
            tags: _tagsController.text
                .split(',')
                .map((value) => value.trim())
                .toList(),
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.carId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактирование авто' : 'Добавление авто'),
      ),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildField('Бренд', _brandController),
                _buildField('Модель', _modelController),
                _buildField(
                  'Год выпуска',
                  _yearController,
                  keyboardType: TextInputType.number,
                  numeric: true,
                ),
                _buildField('Гос. номер', _registrationController),
                _buildField(
                  'Пробег',
                  _mileageController,
                  keyboardType: TextInputType.number,
                  numeric: true,
                ),
                _buildField('Цвет', _colorController),
                _buildField('Ответственный', _ownerController),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Теги (через запятую)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Заметки'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Добавить в избранное'),
                  value: _isFavorite,
                  onChanged: (value) => setState(() => _isFavorite = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CarStatus>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Статус'),
                  items: const [
                    DropdownMenuItem(
                      value: CarStatus.planned,
                      child: Text('Запланировано'),
                    ),
                    DropdownMenuItem(
                      value: CarStatus.inProgress,
                      child: Text('В работе'),
                    ),
                    DropdownMenuItem(
                      value: CarStatus.completed,
                      child: Text('Готово'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _status = value ?? CarStatus.inProgress),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Плановая дата'),
                  subtitle: Text(
                    _scheduledAt == null
                        ? 'Не выбрано'
                        : '${_scheduledAt!.day}.${_scheduledAt!.month}.${_scheduledAt!.year}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickDate,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Оценка'),
                    Expanded(
                      child: Slider(
                        value: (_rating ?? 0).toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: (_rating ?? 0).toString(),
                        onChanged: (value) => setState(() => _rating = value.toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: Text(isEdit ? 'Сохранить' : 'Добавить'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool numeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Обязательное поле';
          }
          if (numeric && int.tryParse(value.trim()) == null) {
            return 'Введите число';
          }
          return null;
        },
      ),
    );
  }
}
