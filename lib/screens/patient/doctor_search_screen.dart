import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hospital_management/theme/app_theme.dart';
import 'package:hospital_management/providers/doctors_provider.dart';
import 'package:provider/provider.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';
  final List<String> _specialties = const [
    'All',
    'Cardiologist',
    'Dermatologist',
    'Gastroenterologist',
    'Pediatrician',
    'Dentist',
    'Ophthalmologist',
  ];

  // Méthode de filtrage adaptée au type User (à ajuster selon le modèle réel)
  List<dynamic> _getFilteredDoctors(DoctorsProvider provider) {
    if (provider.doctors.isEmpty) return [];

    return provider.doctors.where((doctor) {
      // 🔧 ADAPTEZ LES NOMS DE PROPRIÉTÉS SELON VOTRE MODÈLE User
      final specialty = doctor.specialization; // Remplacez par le champ réel
      final name = doctor.name; // Champ existant normalement
      final specialtyMatch =
          _selectedSpecialty == 'All' || specialty == _selectedSpecialty;
      final query = _searchController.text.toLowerCase();
      final searchMatch = query.isEmpty ||
          name.toLowerCase().contains(query) ||
          (specialty?.toLowerCase() ?? '').contains(query);
      return specialtyMatch && searchMatch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorsProvider>().fetchDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorsProvider = Provider.of<DoctorsProvider>(context, listen: true);
    final filteredDoctors = _getFilteredDoctors(doctorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by doctor or specialty',
                  prefixIcon: Icon(Iconsax.search_normal),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {}); // Rebuild pour filtrer
                },
              ),
            ),
          ),

          // Specialty chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _specialties.length,
              itemBuilder: (context, index) {
                final specialty = _specialties[index];
                final isSelected = _selectedSpecialty == specialty;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(specialty),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSpecialty = specialty;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Résultats
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => doctorsProvider.fetchDoctors(),
              child: doctorsProvider.isLoading &&
                      doctorsProvider.doctors.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : doctorsProvider.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.warning_2,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${doctorsProvider.error}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => doctorsProvider.fetchDoctors(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : filteredDoctors.isEmpty
                          ? const Center(child: Text('No doctors found'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredDoctors.length,
                              itemBuilder: (context, index) {
                                final doctor = filteredDoctors[index];
                                // 🔧 ADAPTEZ CES PROPRIÉTÉS SELON VOTRE MODÈLE User
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        // Remplacement de withOpacity par withValues (recommandé)
                                        backgroundColor: AppTheme.primaryColor
                                            .withValues(alpha: 0.1),
                                        child: Text(
                                          doctor.name[0], // name doit exister
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doctor.name, // name
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              doctor.specialty, // specialty
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(Iconsax.star1,
                                                    color: Colors.amber,
                                                    size: 16),
                                                const SizedBox(width: 4),
                                                Text(doctor.rating
                                                    .toString()), // rating
                                                const SizedBox(width: 16),
                                                const Icon(Iconsax.clock,
                                                    size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                    '${doctor.experience} yrs'), // experience
                                                const SizedBox(width: 16),
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: doctor
                                                            .available // available
                                                        ? Colors.green
                                                        : Colors.red,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  doctor.available
                                                      ? 'Available'
                                                      : 'Busy',
                                                  style: TextStyle(
                                                    color: doctor.available
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '\$${doctor.fee}', // fee
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: doctor
                                                    .available // available
                                                ? () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/book-appointment',
                                                      arguments: doctor['id'],
                                                    );
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(80, 35),
                                            ),
                                            child: const Text('Book'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
