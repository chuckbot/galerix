import 'dart:ui';
import 'dart:math' as math;
import 'package:galerix/providers/galerix_provider.dart';
import 'package:galerix/widgets/image_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _nextPage = 1;
  late GalerixProvider _galerixProvider;
  bool _loadingMoreImages = false;
  static const _topic = 'animals';

  @override
  void initState() {
    super.initState();
    _galerixProvider = Provider.of<GalerixProvider>(context, listen: false);
    _loadMoreImages();
    _scrollController.addListener(() async {
      // It starts to load the images before reaching the end of the scroll.
      if (_scrollController.offset >
              (_scrollController.position.maxScrollExtent - 512) &&
          !_scrollController.position.outOfRange &&
          !_loadingMoreImages) {
        setState(() => _loadingMoreImages = true);
        _nextPage++;
        await _loadMoreImages();
        setState(() => _loadingMoreImages = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreImages() async {
    await _galerixProvider.loadOnePageOfPhotos(
      page: _nextPage,
      urlPath: '/search/photos',
      extraQueryParameters: {'query': _topic},
      takeDataFromResultsAttribute: true,
      imagesOf: ImagesOf.homeScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = MediaQuery.of(context).padding.top + 60;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 26)),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: appBarHeight,
              maxHeight: appBarHeight,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 26),
                          child: SvgPicture.asset(
                            'assets/svg/burger.svg',
                            width: 26,
                          ),
                        ),
                        const Text(
                          'Discover',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            height: 1.17,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 52)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const ImageList(),
        ],
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(context, shrinkOffset, overlapsContent) =>
      SizedBox.expand(child: child);

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}
