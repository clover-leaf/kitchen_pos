import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_pos/gen/colors.gen.dart';

ElegantNotification buildErrorNotification({
  required String title,
  required String description,
}) {
  return ElegantNotification.error(
    width: 256,
    showProgressIndicator: false,
    autoDismiss: false,
    notificationPosition: NotificationPosition.bottomRight,
    title: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        color: ColorName.blue900,
        fontWeight: FontWeight.w500,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(
        fontSize: 12,
        color: ColorName.text100,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

ElegantNotification buildSuccessNotification({
  required String title,
  required String description,
}) {
  return ElegantNotification.success(
    width: 256,
    showProgressIndicator: false,
    autoDismiss: false,
    notificationPosition: NotificationPosition.bottomRight,
    title: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        color: ColorName.blue900,
        fontWeight: FontWeight.w500,
      ),
    ),
    description: Text(
      description,
      style: const TextStyle(
        fontSize: 12,
        color: ColorName.text100,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
