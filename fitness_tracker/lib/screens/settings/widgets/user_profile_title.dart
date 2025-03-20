import 'package:fitness_tracker/common/widgets/custome_shape/containers/circular_image.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({super.key, required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircularImage(
        image: Images.profile,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text(
        name,
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.apply(color: TColors.white),
      ),
      subtitle: Text(
        email,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.apply(color: TColors.white),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Iconsax.edit, color: TColors.white),
      ),
    );
  }
}
