import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// Header
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Color(0xff334155),
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F0FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.deepPurple,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            "General",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    _item(
                      icon: Icons.notifications,
                      color: Colors.teal,
                      title: "Notifications",
                      trailing: const Text(
                        "ON",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    _divider(),

                    _item(
                      icon: Icons.grid_view,
                      color: Colors.blue,
                      title: "App Version",
                      trailing: const Text(
                        "v1.0.0",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    _divider(),

                    _item(
                      icon: Icons.lock,
                      color: Colors.orange,
                      title: "Change Password",
                    ),

                    _divider(),

                    _item(
                      icon: Icons.logout,
                      color: Colors.red,
                      title: "Logout",
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _item({
    required IconData icon,
    required Color color,
    required String title,
    Color textColor = const Color(0xff2B3142),
    Widget? trailing,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),

            trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
          ],
        ),
      ),
    );
  }
}