import 'package:flutter/material.dart';

class ContainerDimensions extends StatelessWidget {
  const ContainerDimensions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Container Internal Dimensions :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dimension labels
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      SizedBox(width: 60, child: Text("Length")),
                      SizedBox(width: 10),
                      Text("39.46ft"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(width: 60, child: Text("Width")),
                      SizedBox(width: 10),
                      Text("7.70 ft"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(width: 60, child: Text("Height")),
                      SizedBox(width: 10),
                      Text("7.84 ft"),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 40),
              // Small container image
              Image.asset('img.png',
                height: 60,
                width: 180,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
