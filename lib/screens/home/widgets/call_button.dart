import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/theme.dart';

class CallButton extends StatefulWidget {
  final String phoneNumber;

  const CallButton({super.key, required this.phoneNumber});

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {
  OverlayEntry? _overlayEntry; // Stores the dropdown overlay
  final LayerLink _layerLink = LayerLink(); // Helps position the dropdown

  Future<void> _makePhoneCall() async {
    final Uri callUri = Uri(scheme: 'tel', path: widget.phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: 160,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 45), // Position dropdown below button
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      widget.phoneNumber,
                      style: RiceTextStyles.label.copyWith(
                        color: RiceColors.neutral,
                        fontSize: 14,
                      ),
                    ),
                    leading: Icon(Icons.call, color: RiceColors.neutral),
                    onTap: () {
                      _makePhoneCall();
                      _removeDropdown(); // Close dropdown after tap
                    },
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: 38,
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: RiceColors.neutral,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.phone_in_talk, color: RiceColors.white, size: 20),
        ),
      ),
    );
  }
}
