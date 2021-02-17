import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
import 'package:provider/provider.dart';

class ProductBottomPageView extends StatefulWidget {
  final List<Widget> children;

  const ProductBottomPageView({
    Key key,
    @required this.children,
  }) : super(key: key);

  @override
  _ProductBottomPageViewState createState() => _ProductBottomPageViewState();
}

class _ProductBottomPageViewState extends State<ProductBottomPageView>
    with TickerProviderStateMixin {
  PageController _pageController;
  TabController _tabController;
  List<double> _heights;
  int _currentPage = 0;

  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController() //
      ..addListener(() {
        final _newPage = _pageController.page.round();
        if (_currentPage != _newPage) {
          setState(() => _currentPage = _newPage);
        }
      });
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductDescriptionViewmodel _model =
    Provider.of<ProductDescriptionViewmodel>(context, listen: true);
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          onTap: (index) {
            _pageController.animateToPage(index, duration: Duration(milliseconds: 100), curve:Curves.easeInOutCubic );
          },
          labelStyle: Theme.of(context).textTheme.bodyText1,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: Color(kMainColor)),
              insets: EdgeInsets.symmetric(horizontal: 60, vertical: 8)),
          tabs: [
            Tab(
              child: Text(
                '상세정보',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                '리뷰(${_model.isLazyLoaded == false ? '' : _model.reviewList.length})',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        TweenAnimationBuilder<double>(
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 100),
          tween: Tween<double>(begin: _heights[0], end: _currentHeight),
          builder: (context, value, child) =>
              SizedBox(height: value, child: child),
          child: PageView(
            onPageChanged: (index) {
              _tabController.animateTo(index,duration: Duration(milliseconds: 100), curve: Curves.easeIn);
            },
            controller: _pageController,
            children: _sizeReportingChildren,
          ),
        ),
      ],
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children
      .asMap() //
      .map(
        (index, child) => MapEntry(
          index,
          OverflowBox(
            //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
            minHeight: 0,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: SizeReportingWidget(
              onSizeChange: (size) =>
                  setState(() => _heights[index] = size?.height ?? 0),
              child: child,
            ),
          ),
        ),
      )
      .values
      .toList();
}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    Key key,
    @required this.child,
    @required this.onSizeChange,
  }) : super(key: key);

  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    final size = context?.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }
}
