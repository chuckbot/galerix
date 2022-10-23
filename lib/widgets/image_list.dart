import 'package:galerix/providers/galerix_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'photo_preview.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(26),
      sliver: Consumer<GalerixProvider>(builder: (_, galerixProvider, __) {
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final bool isEven = index % 2 == 0;
              return Container(
                margin: EdgeInsets.only(
                  bottom: isEven ? 26 : 0,
                  top: isEven ? 0 : 26,
                ),
                child: PhotoPreview(
                  image: galerixProvider.images[index],
                  index: index,
                ),
              );
            },
            childCount: galerixProvider.images.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .6189,
            crossAxisSpacing: 26,
          ),
        );
      }),
    );
  }
}
