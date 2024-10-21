import 'package:flutter/cupertino.dart';
import 'package:helpwave_service/property.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/bottom_sheets.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:provider/provider.dart';

class PropertyBottomSheetPage extends StatelessWidget {
  final String? id;

  const PropertyBottomSheetPage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PropertyController(id: id),
      child: BottomSheetPage(
        header: BottomSheetHeader.navigation(
          context,
          title: Consumer<PropertyController>(
            builder: (context, controller, _) => LoadingAndErrorWidget(
              state: controller.state,
              loadingWidget: const PulsingContainer(width: 50),
              child: Text(controller.property.name, style: context.theme.textTheme.titleMedium),
            ),
          ),
        ),
        child: Flexible(
          child: Consumer<PropertyController>(
            builder: (context, controller, _) => LoadingAndErrorWidget(
              state: controller.state,
              child: ListView(
                children: [
                  Text(
                    "subjectType",
                    // TODO context.localization!.subjectType,
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: paddingTiny),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
