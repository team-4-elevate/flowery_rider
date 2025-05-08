// features/auth/presentation/widgets/apply_widgets/searchable_dropdown.dart
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowery_rider/core/theme/app_styles.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final Function(T) onChanged;
  final String Function(T) displayStringForOption;
  final Widget Function(T) itemBuilder;
  final Widget Function(T)? selectedItemBuilder;
  final bool showSearchBox;

  const SearchableDropdown({
    super.key,
    required this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    required this.displayStringForOption,
    required this.itemBuilder,
    this.selectedItemBuilder,
    this.showSearchBox = true,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      setState(() {
        _filteredItems = List.from(widget.items);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = List.from(widget.items);
      });
    } else {
      final filteredList = widget.items
          .where((item) => widget
              .displayStringForOption(item)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();

      setState(() {
        _filteredItems = filteredList;
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height),
            child: Material(
              elevation: 4,
              child: Container(
                height: 250.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.grey),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                ),
                child: Column(
                  children: [
                    widget.showSearchBox
                        ? Padding(
                            padding: EdgeInsets.all(8.w),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 8.h),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              onChanged: _filterItems,
                              autofocus: true,
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_searchController]),
                        builder: (context, _) {
                          return _filteredItems.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      'No results found',
                                      style: getRegularStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: _filteredItems.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        widget.onChanged(_filteredItems[index]);
                                        _searchController.clear();
                                        _removeOverlay();
                                        setState(() {
                                          _isDropdownOpen = false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 12.h),
                                        child: widget
                                            .itemBuilder(_filteredItems[index]),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
    _searchFocusNode.requestFocus();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
      setState(() {
        _isDropdownOpen = false;
      });
      _searchController.clear();
      _filteredItems = List.from(widget.items);
    } else {
      _showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: widget.value != null
                      ? widget.selectedItemBuilder != null
                          ? widget.selectedItemBuilder!(widget.value!)
                          : Text(
                              widget.displayStringForOption(widget.value!),
                              style: getRegularStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                      : Text(
                          widget.hint,
                          style: getRegularStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
