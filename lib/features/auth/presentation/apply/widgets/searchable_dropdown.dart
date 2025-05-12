// features/auth/presentation/apply/widgets/searchable_dropdown.dart
import 'dart:math' as math;
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';

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
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items.where((item) {
          return widget
              .displayStringForOption(item)
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
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
              borderRadius: BorderRadius.circular(4.r),
              child: AnimatedBuilder(
                animation: Listenable.merge([_searchController]),
                builder: (context, _) {
                  final int itemHeight = 45;
                  final int searchBarHeight = 70;
                  final int minHeight = searchBarHeight + 30;

                  final int calculatedHeight = _filteredItems.isEmpty
                      ? minHeight
                      : searchBarHeight +
                          (math.min(_filteredItems.length, 5) * itemHeight);

                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: calculatedHeight.toDouble(),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText:
                                    LocaleKeys.apply_search_country.tr(),
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
                          ),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: Listenable.merge([_searchController]),
                              builder: (context, _) {
                                return _filteredItems.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.w),
                                          child: Text(
                                            LocaleKeys.apply_no_results
                                                .tr(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: _filteredItems.length,
                                        itemBuilder: (context, index) {
                                          final item = _filteredItems[index];
                                          return InkWell(
                                            onTap: () {
                                              widget.onChanged(item);
                                              _searchController.clear();
                                              _removeOverlay();
                                              setState(() {
                                                _isDropdownOpen = false;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 12.h),
                                              child: widget.itemBuilder(item),
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
                  );
                },
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
            border: Border.all(color: AppColors.grey),
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
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                      : Text(
                          widget.hint,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.grey,
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
