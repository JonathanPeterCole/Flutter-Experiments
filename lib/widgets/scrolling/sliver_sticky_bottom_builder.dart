import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A sliver with a widget that sticks to the bottom until it's scrolled to.
///
/// Unlike [SliverStickyBottom], this widget rebuilds the bottom widget when the scroll offset
/// changes and provides additional params.
///
/// The height constraints for the bottom widget must be provided using the `bottomExtent` for the
/// height when the bottom widget is unstuck, and `stuckBottomExtent` for the height when the widget
/// is stuck to the bottom of the scroll view. If the scroll view extends to the bottom edge of the
/// screen, you should consider factoring `MediaQuery.of(context).padding.bottom` into the
/// `stuckBottomExtent`.
///
/// TODO:
///
///   * Add support for horizontal scrolling.
class SliverStickyBottomBuilder extends RenderObjectWidget {
  const SliverStickyBottomBuilder({
    Key? key,
    required this.child,
    required this.bottomBuilder,
    required this.bottomExtent,
    required this.stuckBottomExtent,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  /// The main widget to display.
  final Widget child;

  /// Builds the bottom widget.
  ///
  /// * `sizeOffset` is the current offset between `bottomExtent` and `stuckBottomExtent` as a
  ///   percentage.
  /// * `scrollOffset` is the current scroll offset of the sliver as a percentage.
  final Widget Function(BuildContext context, double sizeOffset, double scrollOffset) bottomBuilder;

  /// The size of the bottom widget when the user has reached the bottom or scrolled beyond it.
  final double bottomExtent;

  /// The maximum size of the bottom widget when it's stuck to the bottom of the scroll view.
  final double stuckBottomExtent;

  /// The clip behavior for the sliver.
  ///
  ///  This is useful if you don't want a shadow from the bottom widget overlaying the next sliver.
  final Clip clipBehavior;

  @override
  SliverStickyBottomBuilderElement createElement() => SliverStickyBottomBuilderElement(this);

  @override
  RenderSliverStickyBottomBuilder createRenderObject(BuildContext context) {
    return RenderSliverStickyBottomBuilder();
  }
}

/// Handles sliver geometry, layout, and painting for [SliverStickyBottomBuilder].
///
/// See also:
///
///   * [RenderSliverPersistentHeader] and [RenderObjectWithChildMixin], which I referenced when
///     creating this class.
class RenderSliverStickyBottomBuilder extends RenderSliver with RenderSliverHelpers {
  RenderSliverStickyBottomBuilder({
    RenderBox? child,
    RenderBox? bottom,
  }) {
    this.child = child;
    this.bottom = bottom;
  }

  SliverStickyBottomBuilderElement? element;
  RenderBox? _child;
  RenderBox? _bottom;
  double? previousBottomSizeOffset;
  double? previousBottomScrollOffset;

  RenderBox? get child => _child;

  RenderBox? get bottom => _bottom;

  set child(RenderBox? value) {
    if (_child != null) dropChild(_child!);
    _child = value;
    if (_child != null) adoptChild(_child!);
  }

  set bottom(RenderBox? value) {
    if (_bottom != null) dropChild(_bottom!);
    _bottom = value;
    if (_bottom != null) adoptChild(_bottom!);
  }

  Clip get clipBehavior => element!.widget.clipBehavior;

  double get unstuckBottomExtent => element!.widget.bottomExtent;

  double get stuckBottomExtent => element!.widget.stuckBottomExtent;

  /// Get the height of the child.
  double get childExtent => child?.size.height ?? 0;

  /// Get the effective size of the bottom widget based on the current scroll offset.
  double calculateBottomExtent() {
    // Get the maximum size of the sliver
    final double maxSliverExtent = childExtent + unstuckBottomExtent;
    // Get the offset for the bottom of the visible portion of the sliver
    final double visibleBottomOffset = constraints.remainingPaintExtent + constraints.scrollOffset;
    // Get the bottom size depending on whether the bottom widget should shrink or grow
    if (stuckBottomExtent > unstuckBottomExtent) {
      final double bottomSize =
          stuckBottomExtent + (maxSliverExtent - math.max(visibleBottomOffset, maxSliverExtent));
      return bottomSize.clamp(unstuckBottomExtent, stuckBottomExtent);
    } else {
      final double bottomSize =
          unstuckBottomExtent - (maxSliverExtent - math.min(visibleBottomOffset, maxSliverExtent));
      return bottomSize.clamp(stuckBottomExtent, unstuckBottomExtent);
    }
  }

  /// Get the offset for the bottom widget based on the current scroll offset.
  double calculateBottomOffset() {
    // Get the maximum and minimum offsets
    const double minOffset = 0;
    final double maxOffset = child!.size.height;
    // Get the offset for the bottom of the visible portion of the sliver
    final double visibleBottomOffset = constraints.remainingPaintExtent + constraints.scrollOffset;
    // Get the bottom offset
    final double bottomOffset = visibleBottomOffset - stuckBottomExtent;
    return bottomOffset.clamp(minOffset, maxOffset) - constraints.scrollOffset;
  }

  /// Get the percentage offset of the distance the user has scrolled inside the sliver.
  double calculateBottomScrollOffsetPercent() {
    // Get the current scroll offset relative to the scroll view
    final double scrollViewScrollOffset = constraints.precedingScrollExtent +
        constraints.remainingPaintExtent +
        constraints.scrollOffset;
    // Get the point at which the scroll ofset percent should be 0 - This should always be the same
    // or greater than the viewport height to prevent the offset being greater than zero before
    // the user has started scrolling
    final double scrollTop = math.max(
        constraints.precedingScrollExtent + stuckBottomExtent, constraints.viewportMainAxisExtent);
    // Get the point at which the scroll ofset percent should be 1
    final double scrollBottom = constraints.precedingScrollExtent + childExtent + stuckBottomExtent;
    // If the scroll bottom comes before the scroll top, return a full scroll offset percent
    return scrollTop < scrollBottom
        ? (scrollViewScrollOffset - scrollTop) / (scrollBottom - scrollTop)
        : 1;
  }

  /// Gets the position of the leading edge of a child relative to the current scroll offset.
  @override
  double childMainAxisPosition(RenderObject child) {
    if (child == this.child) return -constraints.scrollOffset;
    if (child == bottom) return calculateBottomOffset();
    return super.childMainAxisPosition(child);
  }

  /// Handles hit tests, including tap event hit tests.
  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    // Determine which child should capture the hit test based on whether or not the tap position
    // was above the bottom widget
    if (mainAxisPosition > calculateBottomOffset()) {
      return hitTestBoxChild(BoxHitTestResult.wrap(result), bottom!,
          mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition);
    } else {
      return hitTestBoxChild(BoxHitTestResult.wrap(result), child!,
          mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition);
    }
  }

  /// Determines the layout and geometry, including the amount of space the sliver should take up.
  @override
  void performLayout() {
    // Layout the child using the sliver's constraints
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    // Get the bottom sizes and offset percentages
    final double minBottomExtent = math.min(unstuckBottomExtent, stuckBottomExtent);
    final double maxBottomExtent = math.max(unstuckBottomExtent, stuckBottomExtent);
    final double bottomExtent = calculateBottomExtent();
    final double bottomSizeOffsetPercent =
        (bottomExtent - minBottomExtent) / (maxBottomExtent - minBottomExtent);
    final double bottomScrollOffsetPercent = calculateBottomScrollOffsetPercent();
    // Rebuild the bottom widget if necessary
    if (previousBottomSizeOffset != bottomSizeOffsetPercent ||
        previousBottomScrollOffset != bottomScrollOffsetPercent) {
      invokeLayoutCallback<SliverConstraints>(
        (constraints) => element!.buildBottom(
          bottomSizeOffsetPercent.clamp(0, 1),
          bottomScrollOffsetPercent.clamp(0, 1),
        ),
      );
    }
    // Layout the bottom widget using the effective size based on the scroll position
    bottom!.layout(constraints.asBoxConstraints().copyWith(
          minHeight: bottomExtent,
          maxHeight: bottomExtent,
        ));
    // Set the sliver geometry
    final double maxSliverExtent = childExtent + unstuckBottomExtent;
    geometry = SliverGeometry(
      scrollExtent: maxSliverExtent,
      paintExtent: calculatePaintOffset(constraints, from: 0, to: maxSliverExtent),
      maxPaintExtent: maxSliverExtent,
      hasVisualOverflow: false,
    );
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }

  /// Paints sliver with clipping if clipBehaviour isn't set to `Clip.none`.
  @override
  void paint(PaintingContext context, Offset offset) {
    if (clipBehavior == Clip.none) {
      paintChildren(context, offset);
    } else {
      // Not sure if this is the best way clip the sliver
      final RRect rrect = BorderRadius.zero.toRRect(
        Offset.zero & Size(constraints.crossAxisExtent, geometry!.paintExtent),
      );
      context.pushClipRRect(
        needsCompositing,
        offset,
        rrect.outerRect,
        rrect,
        paintChildren,
        clipBehavior: clipBehavior,
      );
    }
  }

  /// Paints the child and bottom widgets.
  void paintChildren(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset + Offset(0, childMainAxisPosition(child!)));
    context.paintChild(bottom!, offset + Offset(0, calculateBottomOffset()));
  }

  @protected
  void triggerRebuild() {
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_child != null) _child!.attach(owner);
    if (_bottom != null) _bottom!.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (_child != null) _child!.detach();
    if (_bottom != null) _bottom!.detach();
  }

  @override
  void redepthChildren() {
    if (_child != null) redepthChild(_child!);
    if (_bottom != null) redepthChild(_bottom!);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_child != null) visitor(_child!);
    if (_bottom != null) visitor(_bottom!);
  }
}

/// The RenderObjectElement for [SliverStickyBottomBuilder], which is responsible for managing its
/// children in the tree.
///
/// See also:
///
///   * [_SliverPersistentHeaderElement] which I referenced when creating class.
class SliverStickyBottomBuilderElement extends RenderObjectElement {
  SliverStickyBottomBuilderElement(SliverStickyBottomBuilder widget) : super(widget);

  Element? child;

  Element? bottom;

  @override
  SliverStickyBottomBuilder get widget => super.widget as SliverStickyBottomBuilder;

  @override
  RenderSliverStickyBottomBuilder get renderObject =>
      super.renderObject as RenderSliverStickyBottomBuilder;

  void buildBottom(double sizeOffset, double scrollOffset) {
    owner!.buildScope(this, () {
      bottom = updateChild(
        bottom,
        widget.bottomBuilder(this, sizeOffset, scrollOffset),
        1,
      );
    });
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    renderObject.element = this;
    child = updateChild(child, widget.child, 0);
  }

  @override
  void unmount() {
    super.unmount();
    renderObject.element = null;
    child = null;
    bottom = null;
  }

  @override
  void update(SliverStickyBottomBuilder newWidget) {
    super.update(newWidget);
    child = updateChild(child, widget.child, 0);
  }

  @override
  void performRebuild() {
    super.performRebuild();
    renderObject.triggerRebuild();
  }

  @override
  void forgetChild(Element child) {
    if (this.child == child) this.child = null;
    if (bottom == child) bottom = null;
    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(covariant RenderBox child, dynamic slot) {
    if (slot == 0) renderObject.child = child;
    if (slot == 1) renderObject.bottom = child;
  }

  @override
  void moveRenderObjectChild(covariant RenderObject child, dynamic oldSlot, dynamic newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(covariant RenderObject child, dynamic slot) {
    if (renderObject.child == child) renderObject.child = null;
    if (renderObject.bottom == child) renderObject.bottom = null;
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null) visitor(child!);
    if (bottom != null) visitor(bottom!);
  }
}
