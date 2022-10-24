import 'package:galerix/providers/galerix_provider.dart';
import 'package:galerix/widgets/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.initialPage,
    required this.homeImages,
  });

  final int initialPage;
  final bool homeImages;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _descriptionVisible = false;
  final Duration _duration = const Duration(milliseconds: 100);
  double _opacity = 0;
  double _closeTop = 10;
  double _shadowBottom = -20;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _showOrHideDescription();
    });
  }

  void _showOrHideDescription() {
    if (_descriptionVisible) {
      setState(() {
        _descriptionVisible = false;
        _opacity = 0;
        _closeTop = 10;
        _shadowBottom = -20;
      });
    } else {
      setState(() {
        _descriptionVisible = true;
        _opacity = 1;
        _closeTop = 26;
        _shadowBottom = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _showOrHideDescription,
        child: Consumer<GalerixProvider>(builder: (_, galerixProvider, __) {
          final images = widget.homeImages
              ? galerixProvider.homeImages
              : galerixProvider.userImages;
          return CarouselSlider(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1,
              initialPage: widget.initialPage,
            ),
            items: images.map((image) {
              return CachedNetworkImage(
                fadeInDuration: const Duration(microseconds: 1),
                fadeOutDuration: const Duration(microseconds: 1),
                placeholderFadeInDuration: const Duration(microseconds: 1),
                fadeInCurve: Curves.linear,
                fadeOutCurve: Curves.linear,
                imageUrl: image.imageUrl,
                imageBuilder: (_, imageProvider) => Stack(
                  children: [
                    Hero(
                      tag: image.heroId,
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    AnimatedPositioned(
                      top: MediaQuery.of(context).padding.top + _closeTop,
                      left: 26,
                      duration: _duration,
                      child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: _duration,
                        child: GestureDetector(
                          onTap: _descriptionVisible
                              ? () => Navigator.pop(context)
                              : null,
                          child: SvgPicture.asset(
                            'assets/svg/close.svg',
                            width: 37,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      bottom: _shadowBottom,
                      duration: _duration,
                      child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: _duration,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 33,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(.2),
                                Colors.black.withOpacity(.7),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                image.description,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 42,
                                  height: 1.17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${image.likes} likes',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 26),
                              User(
                                homeImages: widget.homeImages,
                                user: image.user,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                placeholder: (_, __) => Hero(
                  tag: image.heroId,
                  child: CachedNetworkImage(
                    imageUrl: image.imagePreviewUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                errorWidget: (_, __, ___) => const Center(
                  child: Icon(Icons.error),
                ),
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
