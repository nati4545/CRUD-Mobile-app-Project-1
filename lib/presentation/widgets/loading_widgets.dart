import 'package:flutter/material.dart';

class LoadingShimmer extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const LoadingShimmer({
    Key? key,
    this.height = 16.0,
    this.width = double.infinity,
    BorderRadius? borderRadius,
  }) : borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(8.0)),
       super(key: key);

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: const Color(0xFFE8EEF7),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [
                  (_animationController.value - 0.3).clamp(0.0, 1.0),
                  _animationController.value,
                  (_animationController.value + 0.3).clamp(0.0, 1.0),
                ],
                colors: const [
                  Colors.transparent,
                  Colors.white30,
                  Colors.transparent,
                ],
              ).createShader(bounds);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: Colors.white12,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SupplierCardLoading extends StatelessWidget {
  const SupplierCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(
                        height: 18,
                        width: 200,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                      const SizedBox(height: 8),
                      LoadingShimmer(
                        height: 14,
                        width: 150,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                      ),
                    ],
                  ),
                ),
                LoadingShimmer(
                  height: 24,
                  width: 60,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LoadingShimmer(
              height: 14,
              width: double.infinity,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingListView extends StatelessWidget {
  final int itemCount;

  const LoadingListView({
    Key? key,
    this.itemCount = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const SupplierCardLoading(),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
