import 'package:flutter/material.dart';

class SuggestFoodRow extends StatelessWidget {
  const SuggestFoodRow({super.key});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = (MediaQuery.of(context).size.width - 56) / 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SuggestFoodCard(
          title: 'Breakfast',
          subtitle: '120+ Foods',
          image: Image.asset(
            'assets/foods/breakfast.png',
            width: 80,
            height: 60,
            fit: BoxFit.contain,
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          cardWidth: cardWidth,
        ),
        const SizedBox(width: 24),
        _SuggestFoodCard(
          title: 'Lunch',
          subtitle: '130+ Foods',
          image: Image.asset(
            'assets/foods/lunch.png',
            width: 80,
            height: 60,
            fit: BoxFit.contain,
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFFBC2EB), Color(0xFFA6C1EE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          cardWidth: cardWidth,
        ),
      ],
    );
  }
}

class _SuggestFoodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget image;
  final Gradient gradient;
  final double cardWidth;

  const _SuggestFoodCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.gradient,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: 180,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          // Shadow nhiều lớp kiểu neumorphism
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 16,
            offset: const Offset(-6, -6),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(8, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 0),
            spreadRadius: 4,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ảnh lớn ở góc trên phải
          Positioned(top: -18, right: -8, child: image),
          // Nội dung căn giữa
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 32, 18, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 36),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      backgroundColor: null,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => null,
                      ),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Select',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
