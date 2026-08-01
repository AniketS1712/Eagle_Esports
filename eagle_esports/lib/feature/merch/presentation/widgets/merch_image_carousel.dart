import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';

/// Image carousel widget for merch item details screen.
class MerchImageCarousel extends StatefulWidget {
  const MerchImageCarousel({required this.images, super.key});

  final List<String> images;

  @override
  State<MerchImageCarousel> createState() => _MerchImageCarouselState();
}

class _MerchImageCarouselState extends State<MerchImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 280,
        width: double.infinity,
        color: AppColors.surfaceContainerHigh,
        child: const Icon(
          Icons.shopping_bag_outlined,
          size: AppDimensions.iconXl,
          color: AppColors.outline,
        ),
      );
    }

    if (widget.images.length == 1) {
      return Image.network(
        widget.images.first,
        height: 280,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 280,
          width: double.infinity,
          color: AppColors.surfaceContainerHigh,
          child: const Icon(
            Icons.image_outlined,
            size: AppDimensions.iconXl,
            color: AppColors.outline,
          ),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: widget.images.length,
            itemBuilder: (_, i) => Image.network(
              widget.images[i],
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 280,
                color: AppColors.surfaceContainerHigh,
                child: const Icon(
                  Icons.image_outlined,
                  size: AppDimensions.iconXl,
                  color: AppColors.outline,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppSpacing.sm,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  width: _currentPage == index ? 16 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.radiusFull,
                    color: _currentPage == index
                        ? AppColors.electricCyan
                        : AppColors.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
