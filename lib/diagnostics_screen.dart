import 'package:flutter/material.dart';

class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final packages = [
      {
        'name': 'Basic Health Checkup',
        'tests': 'CBC, ESR, Urine R/E, RBS',
        'price': 'BDT 1,250',
      },
      {
        'name': 'Cardiac Screening',
        'tests': 'ECG, Troponin-I, Lipid Profile',
        'price': 'BDT 2,100',
      },
      {
        'name': 'Diabetes Profile',
        'tests': 'FBS, HbA1c, Creatinine, Urine ACR',
        'price': 'BDT 1,850',
      },
      {
        'name': 'Liver Function Panel',
        'tests': 'SGPT, SGOT, Bilirubin, ALP',
        'price': 'BDT 1,400',
      },
      {
        'name': 'Thyroid Profile',
        'tests': 'TSH, FT3, FT4',
        'price': 'BDT 1,300',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostics'), centerTitle: true),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Book Diagnostic Packages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Partner labs in Dhaka, Chattogram and Sylhet with fast report delivery.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final item = packages[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.biotech_outlined),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item['tests']!),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['price']!,
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Booking started for ${item['name']}',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Book Test'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
