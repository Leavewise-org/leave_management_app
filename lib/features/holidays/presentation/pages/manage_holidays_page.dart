import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_management_app/features/holidays/presentation/providers/holiday_providers.dart';

class ManageHolidaysPage extends ConsumerStatefulWidget {
  const ManageHolidaysPage({super.key});

  @override
  ConsumerState<ManageHolidaysPage> createState() => _ManageHolidaysPageState();
}

class _ManageHolidaysPageState extends ConsumerState<ManageHolidaysPage> {
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final holidaysAsync = ref.watch(holidaysByYearProvider(_selectedYear));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary, size: 28),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Manage Holidays',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedYear,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() => _selectedYear = newValue);
                }
              },
              items: [for (var i = DateTime.now().year - 2; i <= DateTime.now().year + 5; i++) i]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: holidaysAsync.when(
        data: (holidays) {
          if (holidays.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  const Text('No holidays added yet for this year', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: holidays.length,
            itemBuilder: (context, index) {
              final holiday = holidays[index];
              final isPoya = holiday.type.toLowerCase().contains('poya');
              
              return Card(
                elevation: 0,
                color: AppColors.surface,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isPoya ? Colors.indigo.withOpacity(0.1) : AppColors.primarySubtle,
                    child: Icon(
                      isPoya ? Icons.nightlight_round : Icons.flag,
                      color: isPoya ? Colors.indigo : AppColors.primary,
                    ),
                  ),
                  title: Text(holiday.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: Text(
                    '${DateFormat('EEEE, MMM d').format(holiday.date)} • ${holiday.type}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                        onPressed: () => _showAddEditHolidayDialog(context, ref, holiday: holiday),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.rejected),
                        onPressed: () => _confirmDelete(context, ref, holiday),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'importBtn',
            onPressed: () => _showImportDefaultsDialog(context, ref),
            backgroundColor: AppColors.surface,
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            label: const Text('Import Defaults', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'addBtn',
            onPressed: () => _showAddEditHolidayDialog(context, ref),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Holiday', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showImportDefaultsDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ImportDefaultHolidaysBottomSheet(selectedYear: _selectedYear),
    );
  }

  void _showAddEditHolidayDialog(BuildContext context, WidgetRef ref, {HolidayEntity? holiday}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddEditHolidayBottomSheet(
        holiday: holiday,
        selectedYear: _selectedYear,
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, HolidayEntity holiday) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Holiday'),
        content: Text('Are you sure you want to delete ${holiday.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(holidayRepositoryProvider).deleteHoliday(holiday.id).then((_) {
                ref.invalidate(holidaysByYearProvider);
                ref.invalidate(currentYearHolidaysProvider);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Holiday deleted')));
              });
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.rejected)),
          ),
        ],
      ),
    );
  }
}

class _AddEditHolidayBottomSheet extends ConsumerStatefulWidget {
  final HolidayEntity? holiday;
  final int selectedYear;

  const _AddEditHolidayBottomSheet({this.holiday, required this.selectedYear});

  @override
  ConsumerState<_AddEditHolidayBottomSheet> createState() => _AddEditHolidayBottomSheetState();
}

class _AddEditHolidayBottomSheetState extends ConsumerState<_AddEditHolidayBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late DateTime _selectedDate;
  late String _selectedType;
  bool _isLoading = false;

  final List<String> _holidayTypes = ['National', 'Poya', 'Mercantile', 'Bank'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.holiday?.name ?? '');
    _selectedDate = widget.holiday?.date ?? DateTime(widget.selectedYear, DateTime.now().month, DateTime.now().day);
    _selectedType = widget.holiday?.type ?? 'National';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.holiday == null ? 'Add Holiday' : 'Edit Holiday',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Holiday Name',
                filled: true,
                fillColor: AppColors.scaffoldBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: AppColors.primary),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  filled: true,
                  fillColor: AppColors.scaffoldBackground,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  suffixIcon: const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                ),
                child: Text(DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Holiday Type',
                filled: true,
                fillColor: AppColors.scaffoldBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              items: _holidayTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedType = v);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _saveHoliday,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Holiday', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHoliday() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final isNew = widget.holiday == null;
    final entity = HolidayEntity(
      id: isNew ? '' : widget.holiday!.id,
      name: _nameController.text.trim(),
      date: _selectedDate,
      type: _selectedType,
      year: _selectedDate.year,
      isPublicHoliday: true,
      createdAt: isNew ? DateTime.now() : widget.holiday!.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      final repo = ref.read(holidayRepositoryProvider);
      if (isNew) {
        await repo.addHoliday(entity);
      } else {
        await repo.updateHoliday(entity);
      }
      
      ref.invalidate(holidaysByYearProvider);
      ref.invalidate(currentYearHolidaysProvider);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isNew ? 'Holiday added successfully' : 'Holiday updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }
}

class _ImportDefaultHolidaysBottomSheet extends ConsumerStatefulWidget {
  final int selectedYear;
  const _ImportDefaultHolidaysBottomSheet({required this.selectedYear});

  @override
  ConsumerState<_ImportDefaultHolidaysBottomSheet> createState() => _ImportDefaultHolidaysBottomSheetState();
}

class _ImportDefaultHolidaysBottomSheetState extends ConsumerState<_ImportDefaultHolidaysBottomSheet> {
  bool _isLoading = false;
  bool _isFetching = true;
  final Set<int> _selectedIndices = {};
  List<HolidayEntity>? _defaults;

  @override
  void initState() {
    super.initState();
    _fetchSriLankanHolidays(widget.selectedYear);
  }

  Future<void> _fetchSriLankanHolidays(int year) async {
    try {
      final response = await http.get(
        Uri.parse('https://calendar.google.com/calendar/ical/en.lk%23holiday%40group.v.calendar.google.com/public/basic.ics'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final lines = const LineSplitter().convert(response.body);
        final List<HolidayEntity> fetchedHolidays = [];
        
        String? currentSummary;
        DateTime? currentDate;
        
        for (final line in lines) {
          if (line.startsWith('BEGIN:VEVENT')) {
            currentSummary = null;
            currentDate = null;
          } else if (line.startsWith('DTSTART;VALUE=DATE:')) {
            final dateStr = line.substring(19);
            if (dateStr.length == 8) {
              final y = int.tryParse(dateStr.substring(0, 4));
              final m = int.tryParse(dateStr.substring(4, 6));
              final d = int.tryParse(dateStr.substring(6, 8));
              if (y != null && m != null && d != null) {
                currentDate = DateTime(y, m, d);
              }
            }
          } else if (line.startsWith('SUMMARY:')) {
            currentSummary = line.substring(8);
          } else if (line.startsWith('END:VEVENT')) {
            if (currentSummary != null && currentDate != null && currentDate.year == year) {
              String type = 'National';
              if (currentSummary.toLowerCase().contains('poya')) type = 'Poya';
              else if (currentSummary.toLowerCase().contains('mercantile')) type = 'Mercantile';
              else if (currentSummary.toLowerCase().contains('bank')) type = 'Bank';

              // Prevent duplicates (sometimes Google Calendar has overlapping events)
              if (!fetchedHolidays.any((h) => h.name == currentSummary && h.date == currentDate)) {
                fetchedHolidays.add(HolidayEntity(
                  id: '',
                  name: currentSummary,
                  date: currentDate,
                  type: type,
                  year: year,
                  isPublicHoliday: true,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ));
              }
            }
          }
        }
        
        if (fetchedHolidays.isNotEmpty) {
          fetchedHolidays.sort((a, b) => a.date.compareTo(b.date));
          if (mounted) {
            setState(() {
              _defaults = fetchedHolidays;
              _isFetching = false;
              for (int i = 0; i < _defaults!.length; i++) _selectedIndices.add(i);
            });
          }
          return; // Success
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch from Google Calendar API: $e');
    }

    // Fallback to static list if API fails
    if (mounted) {
      setState(() {
        _defaults = _getStaticFallbackHolidays(year);
        _isFetching = false;
        for (int i = 0; i < _defaults!.length; i++) _selectedIndices.add(i);
      });
    }
  }

  List<HolidayEntity> _getStaticFallbackHolidays(int year) {
    return [
      // January
      HolidayEntity(id: '', name: 'Tamil Thai Pongal Day', date: DateTime(year, 1, 15), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Duruthu Full Moon Poya Day', date: DateTime(year, 1, 25), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // February
      HolidayEntity(id: '', name: 'Independence Day', date: DateTime(year, 2, 4), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Navam Full Moon Poya Day', date: DateTime(year, 2, 23), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // March
      HolidayEntity(id: '', name: 'Mahasivarathri Day', date: DateTime(year, 3, 8), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Madin Full Moon Poya Day', date: DateTime(year, 3, 24), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Good Friday', date: DateTime(year, 3, 29), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // April
      HolidayEntity(id: '', name: 'Id-Ul-Fitr (Ramazan Festival)', date: DateTime(year, 4, 11), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Sinhala & Tamil New Year Eve', date: DateTime(year, 4, 13), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Sinhala & Tamil New Year Day', date: DateTime(year, 4, 14), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Bak Full Moon Poya Day', date: DateTime(year, 4, 23), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // May
      HolidayEntity(id: '', name: 'May Day', date: DateTime(year, 5, 1), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Vesak Full Moon Poya Day', date: DateTime(year, 5, 23), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Day following Vesak', date: DateTime(year, 5, 24), type: 'Bank', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // June
      HolidayEntity(id: '', name: 'Id-Ul-Alha (Haj Festival)', date: DateTime(year, 6, 17), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Poson Full Moon Poya Day', date: DateTime(year, 6, 21), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // July
      HolidayEntity(id: '', name: 'Esala Full Moon Poya Day', date: DateTime(year, 7, 20), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // August
      HolidayEntity(id: '', name: 'Nikini Full Moon Poya Day', date: DateTime(year, 8, 19), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // September
      HolidayEntity(id: '', name: 'Milad-Un-Nabi (Holy Prophet\'s Birthday)', date: DateTime(year, 9, 16), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Binara Full Moon Poya Day', date: DateTime(year, 9, 17), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // October
      HolidayEntity(id: '', name: 'Vap Full Moon Poya Day', date: DateTime(year, 10, 17), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Deepavali Festival Day', date: DateTime(year, 10, 31), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // November
      HolidayEntity(id: '', name: 'Il Full Moon Poya Day', date: DateTime(year, 11, 15), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      
      // December
      HolidayEntity(id: '', name: 'Unduvap Full Moon Poya Day', date: DateTime(year, 12, 14), type: 'Poya', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
      HolidayEntity(id: '', name: 'Christmas Day', date: DateTime(year, 12, 25), type: 'National', year: year, isPublicHoliday: true, createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Import Default Holidays (${widget.selectedYear})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the standard holidays you want to add. You can customize them later.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isFetching 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _defaults!.length,
                  itemBuilder: (context, index) {
                    final holiday = _defaults![index];
                    return CheckboxListTile(
                      title: Text(holiday.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(DateFormat('EEEE, MMM d').format(holiday.date), style: const TextStyle(fontSize: 12)),
                      value: _selectedIndices.contains(index),
                      activeColor: AppColors.primary,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) _selectedIndices.add(index);
                          else _selectedIndices.remove(index);
                        });
                      },
                    );
                  },
                ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading || _isFetching || _selectedIndices.isEmpty ? null : _importSelected,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Import ${_selectedIndices.length} Holidays', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _importSelected() async {
    setState(() => _isLoading = true);
    final repo = ref.read(holidayRepositoryProvider);
    
    try {
      for (int i in _selectedIndices) {
        await repo.addHoliday(_defaults![i]);
      }
      ref.invalidate(holidaysByYearProvider);
      ref.invalidate(currentYearHolidaysProvider);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully imported ${_selectedIndices.length} holidays')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }
}
