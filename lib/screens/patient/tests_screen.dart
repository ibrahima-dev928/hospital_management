import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hospital_management/theme/app_theme.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  final List<Map<String, dynamic>> tests = const [
    {
      'name': 'Complete Blood Count',
      'date': '3 Mar 2026',
      'doctor': 'Dr. Ibrahim Al-Sallal',
      'status': 'completed',
      'file': 'cbc_result.pdf',
    },
    {
      'name': 'Liver Function Test',
      'date': '28 Feb 2026',
      'doctor': 'Dr. Yusuf Khan',
      'status': 'completed',
      'file': 'lft_result.pdf',
    },
    {
      'name': 'COVID-19 PCR',
      'date': '15 Feb 2026',
      'doctor': 'Dr. Salma Al-Sallal',
      'status': 'completed',
      'file': 'covid_result.pdf',
    },
    {
      'name': 'Lipid Profile',
      'date': '10 Feb 2026',
      'doctor': 'Dr. Ahmad Al-Saleh',
      'status': 'pending',
      'file': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tests & Checkups'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          final test = tests[index];
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.document,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Doctor: ${test['doctor']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${test['date']}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: test['status'] == 'completed'
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        test['status'].toUpperCase(),
                        style: TextStyle(
                          color: test['status'] == 'completed'
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (test['status'] == 'completed')
                      IconButton(
                        icon: const Icon(Iconsax.document_download,
                            color: AppTheme.primaryColor),
                        onPressed: () {
                          // Download file
                        },
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
