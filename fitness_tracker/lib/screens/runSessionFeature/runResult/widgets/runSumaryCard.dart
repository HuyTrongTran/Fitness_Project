import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/runSession.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/runViewMap.dart';

class RunSummaryCard extends StatelessWidget {
  final RunSession session;
  final DateTime selectedDate;
  const RunSummaryCard({
    Key? key,
    required this.session,
    required this.selectedDate,
  }) : super(key: key);

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : ''}${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12, width: 1.2),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hình asset bên trái
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                  ),
                  child: Center(
                    child: Image.asset(Images.map, width: 100, height: 100),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Total time',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => RunViewMapPage(session: session),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C7DFA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Run map',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTime(session.elapsedTimeInSeconds),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        session.address,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatRowIndicator(
                  assetImage: Images.distance,
                  value: session.distanceInKm.toStringAsFixed(2),
                  label: 'km',
                ),
                StatRowIndicator(
                  assetImage: Images.distance,
                  value: session.steps.toString(),
                  label: 'steps',
                ),
                StatRowIndicator(
                  assetImage: Images.calories,
                  value: session.calories.toStringAsFixed(0),
                  label: 'cal',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatRowIndicator extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final String? assetImage;

  const StatRowIndicator({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.assetImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF6C7DFA),
          ),
          child:
              assetImage != null
                  ? Image.asset(
                    assetImage!,
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                  )
                  : Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
