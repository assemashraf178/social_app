class NotificationModel {
  String? to;
  NotificationOfModel? notification;
  Android? android;
  Data? data;

  NotificationModel({this.to, this.notification, this.android, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    notification = json['notification'] != null
        ? new NotificationOfModel.fromJson(json['notification'])
        : null;
    android =
        json['android'] != null ? new Android.fromJson(json['android']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationOfModel {
  String? title;
  String? body;
  String? sound;

  NotificationOfModel({
    this.title,
    this.body,
    this.sound,
  });

  NotificationOfModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['sound'] = this.sound;
    return data;
  }
}

class Android {
  String? priority;
  AndroidNotification? notification;

  Android({this.priority, this.notification});

  Android.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    notification = json['notification'] != null
        ? new AndroidNotification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority'] = this.priority;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    return data;
  }
}

class AndroidNotification {
  String? notificationPriority;
  String? sound;
  bool? defaultSound;
  bool? defaultVibrateTimings;
  bool? defaultLightSetings;

  AndroidNotification(
      {this.notificationPriority,
      this.sound,
      this.defaultSound,
      this.defaultVibrateTimings,
      this.defaultLightSetings});

  AndroidNotification.fromJson(Map<String, dynamic> json) {
    notificationPriority = json['notification_priority'];
    sound = json['sound'];
    defaultSound = json['default_sound'];
    defaultVibrateTimings = json['default_vibrate_timings'];
    defaultLightSetings = json['default_light_setings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_priority'] = this.notificationPriority;
    data['sound'] = this.sound;
    data['default_sound'] = this.defaultSound;
    data['default_vibrate_timings'] = this.defaultVibrateTimings;
    data['default_light_setings'] = this.defaultLightSetings;
    return data;
  }
}

class Data {
  String? type;
  String? id;
  String? clickAction;

  Data({this.type, this.id, this.clickAction});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    clickAction = json['click_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['click_action'] = this.clickAction;
    return data;
  }
}
