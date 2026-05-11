import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/constants/app_strings.dart';
import 'package:factory_management/core/theme/app_theme.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;
    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemeColors.of(context).drawerBg,
          foregroundColor: Colors.white,
          title: const Text(AppStrings.appName, style: TextStyle(fontSize: AppFonts.lg, fontWeight: FontWeight.w700)),
        ),
        drawer: const _AppDrawer(),
        body: child,
      );
    }
    return Scaffold(
      body: Row(
        children: [
          const _AppDrawer(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final c = AppThemeColors.of(context);
    return SizedBox(
      width: AppSizes.drawerWidth,
      child: Drawer(
        elevation: 0,
        backgroundColor: c.drawerBg,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.factory_outlined, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFonts.md,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.inter,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerItem(
                icon: Icons.factory_outlined,
                label: AppStrings.factories,
                path: '/factories',
                isActive: location.startsWith('/factories'),
              ),
              _DrawerItem(
                icon: Icons.inventory_2_outlined,
                label: AppStrings.products,
                path: '/products',
                isActive: location.startsWith('/products'),
              ),
              _DrawerItem(
                icon: Icons.category_outlined,
                label: AppStrings.categories,
                path: '/categories',
                isActive: location.startsWith('/categories'),
              ),
              const Spacer(),
              // Theme toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance,
                  builder: (_, mode, __) {
                    final isDark = mode == ThemeMode.dark;
                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        onTap: ThemeController.instance.toggle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                size: AppSizes.iconSize,
                                color: c.drawerItem,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isDark ? 'Light Mode' : 'Dark Mode',
                                style: TextStyle(
                                  color: c.drawerItem,
                                  fontSize: AppFonts.base,
                                  fontFamily: AppFonts.inter,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final bool isActive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          onTap: () {
            context.replace(path);
            if (Scaffold.of(context).isDrawerOpen) {
              Navigator.of(context).pop();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? c.drawerItemActiveBg : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: AppSizes.iconSize,
                  color: isActive ? c.drawerItemActive : c.drawerItem,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? c.drawerItemActive : c.drawerItem,
                    fontSize: AppFonts.base,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: AppFonts.inter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
