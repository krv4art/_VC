import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

class AppSpacer extends StatelessWidget {
  final double? width;
  final double? height;

  const AppSpacer._({this.width, this.height});

  // Квадратные спейсеры
  factory AppSpacer.p4() => const AppSpacer._(
    height: AppDimensions.space4,
    width: AppDimensions.space4,
  );
  factory AppSpacer.p8() => const AppSpacer._(
    height: AppDimensions.space8,
    width: AppDimensions.space8,
  );
  factory AppSpacer.p12() => const AppSpacer._(
    height: AppDimensions.space12,
    width: AppDimensions.space12,
  );
  factory AppSpacer.p16() => const AppSpacer._(
    height: AppDimensions.space16,
    width: AppDimensions.space16,
  );
  factory AppSpacer.p24() => const AppSpacer._(
    height: AppDimensions.space24,
    width: AppDimensions.space24,
  );
  factory AppSpacer.p32() => const AppSpacer._(
    height: AppDimensions.space32,
    width: AppDimensions.space32,
  );

  // Вертикальные спейсеры
  factory AppSpacer.v4() => const AppSpacer._(height: AppDimensions.space4);
  factory AppSpacer.v8() => const AppSpacer._(height: AppDimensions.space8);
  factory AppSpacer.v12() => const AppSpacer._(height: AppDimensions.space12);
  factory AppSpacer.v16() => const AppSpacer._(height: AppDimensions.space16);
  factory AppSpacer.v24() => const AppSpacer._(height: AppDimensions.space24);
  factory AppSpacer.v32() => const AppSpacer._(height: AppDimensions.space32);

  // Горизонтальные спейсеры
  factory AppSpacer.h4() => const AppSpacer._(width: AppDimensions.space4);
  factory AppSpacer.h8() => const AppSpacer._(width: AppDimensions.space8);
  factory AppSpacer.h12() => const AppSpacer._(width: AppDimensions.space12);
  factory AppSpacer.h16() => const AppSpacer._(width: AppDimensions.space16);
  factory AppSpacer.h24() => const AppSpacer._(width: AppDimensions.space24);
  factory AppSpacer.h32() => const AppSpacer._(width: AppDimensions.space32);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
