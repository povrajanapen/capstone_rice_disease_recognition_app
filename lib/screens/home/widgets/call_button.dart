import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallButton extends StatefulWidget {
  final String phoneNumber;

  const CallButton({super.key, required this.phoneNumber});

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {
  bool _showDropdown = false;

  Future<void> _makePhoneCall() async {
    final Uri callUri = Uri(scheme: 'tel', path: widget.phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  @override
  Widget build(BuildContext context) {
        return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showDropdown = !_showDropdown; // Toggle dropdown
            });
          },
          child: Container(
            height: 38,
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: RiceColors.neutral,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.phone_in_talk,
              color: RiceColors.white,
              size: 20,
            ),
          ),
        ),
        
        // Dropdown
        if (_showDropdown)
          Positioned(
            top: 45,
            right: 0,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        widget.phoneNumber,
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Icon(Icons.call, color: RiceColors.neutral),
                      onTap: () {
                        _makePhoneCall();
                        setState(() {
                          _showDropdown = false; // Close dropdown after selecting
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}