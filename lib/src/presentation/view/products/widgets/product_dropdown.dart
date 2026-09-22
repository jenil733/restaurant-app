import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class ProductDropdown extends StatefulWidget {
  final String title;
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final Widget? trailing;
  final bool isRequired;
  final VoidCallback? onAddNew;
  final String? addNewLabel;

  const ProductDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    this.value,
    required this.onChanged,
    this.trailing,
    this.isRequired = false,
    this.onAddNew,
    this.addNewLabel,
  });

  @override
  State<ProductDropdown> createState() => _ProductDropdownState();
}

class _ProductDropdownState extends State<ProductDropdown> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ProductDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _textController.text = widget.value ?? '';
      _textController.selection = TextSelection.collapsed(
        offset: _textController.text.length,
      );
    } else if (widget.value != null && widget.value != _textController.text) {
      _textController.text = widget.value!;
      _textController.selection = TextSelection.collapsed(
        offset: _textController.text.length,
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                  children: [
                    if (widget.isRequired)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
          const SizedBox(height: 8),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            return RawAutocomplete<String>(
              textEditingController: _textController,
              focusNode: _focusNode,
              optionsBuilder: (TextEditingValue textEditingValue) {
                final query = textEditingValue.text.trim().toLowerCase();
                if (query.isEmpty ||
                    (widget.value != null &&
                        query == widget.value!.trim().toLowerCase())) {
                  return widget.items;
                }
                final filtered = widget.items.where((item) {
                  return item.toLowerCase().contains(query);
                }).toList();

                return filtered.isNotEmpty ? filtered : widget.items;
              },
              onSelected: (String selection) {
                _textController.text = selection;
                _textController.selection = TextSelection.collapsed(
                  offset: selection.length,
                );
                widget.onChanged(selection);
                _focusNode.unfocus();
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  onTap: () {
                    if (!fieldFocusNode.hasFocus) {
                      fieldFocusNode.requestFocus();
                    }
                    fieldTextEditingController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: fieldTextEditingController.text.length,
                    );
                  },
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        if (fieldFocusNode.hasFocus) {
                          fieldFocusNode.unfocus();
                        } else {
                          fieldFocusNode.requestFocus();
                          fieldTextEditingController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: fieldTextEditingController.text.length,
                          );
                        }
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    widget.onChanged(text);
                  },
                );
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options,
              ) {
                final optionsList = options.toList();
                if (optionsList.isEmpty && widget.onAddNew == null) {
                  return const SizedBox.shrink();
                }

                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: Container(
                      width: constraints.maxWidth,
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (optionsList.isNotEmpty)
                            Flexible(
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                shrinkWrap: true,
                                itemCount: optionsList.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade100,
                                ),
                                itemBuilder: (context, index) {
                                  final option = optionsList[index];
                                  final isSelected =
                                      option.toLowerCase() ==
                                      _textController.text.trim().toLowerCase();

                                  return InkWell(
                                    onTap: () {
                                      onSelected(option);
                                      _focusNode.unfocus();
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      color: isSelected
                                          ? AppColors.primary.withValues(alpha: 0.08)
                                          : Colors.transparent,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : const Color(0xFF1F2937),
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check_rounded,
                                              size: 16,
                                              color: AppColors.primary,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (widget.onAddNew != null) ...[
                            if (optionsList.isNotEmpty)
                              Divider(
                                height: 1,
                                color: Colors.grey.shade200,
                              ),
                            InkWell(
                              onTap: () {
                                _focusNode.unfocus();
                                widget.onAddNew!();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.06),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.addNewLabel ?? "Add New",
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}