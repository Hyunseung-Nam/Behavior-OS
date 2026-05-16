// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScheduleTableTable extends ScheduleTable
    with TableInfo<$ScheduleTableTable, ScheduleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whyMeta = const VerificationMeta('why');
  @override
  late final GeneratedColumn<String> why = GeneratedColumn<String>(
      'why', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _minimumActionMeta =
      const VerificationMeta('minimumAction');
  @override
  late final GeneratedColumn<String> minimumAction = GeneratedColumn<String>(
      'minimum_action', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('other'));
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _naggingCountMeta =
      const VerificationMeta('naggingCount');
  @override
  late final GeneratedColumn<int> naggingCount = GeneratedColumn<int>(
      'nagging_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _snoozedUntilMeta =
      const VerificationMeta('snoozedUntil');
  @override
  late final GeneratedColumn<DateTime> snoozedUntil = GeneratedColumn<DateTime>(
      'snoozed_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _calendarEventIdMeta =
      const VerificationMeta('calendarEventId');
  @override
  late final GeneratedColumn<String> calendarEventId = GeneratedColumn<String>(
      'calendar_event_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        description,
        why,
        minimumAction,
        category,
        scheduledAt,
        status,
        naggingCount,
        snoozedUntil,
        completedAt,
        calendarEventId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_table';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('why')) {
      context.handle(
          _whyMeta, why.isAcceptableOrUnknown(data['why']!, _whyMeta));
    }
    if (data.containsKey('minimum_action')) {
      context.handle(
          _minimumActionMeta,
          minimumAction.isAcceptableOrUnknown(
              data['minimum_action']!, _minimumActionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('nagging_count')) {
      context.handle(
          _naggingCountMeta,
          naggingCount.isAcceptableOrUnknown(
              data['nagging_count']!, _naggingCountMeta));
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
          _snoozedUntilMeta,
          snoozedUntil.isAcceptableOrUnknown(
              data['snoozed_until']!, _snoozedUntilMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('calendar_event_id')) {
      context.handle(
          _calendarEventIdMeta,
          calendarEventId.isAcceptableOrUnknown(
              data['calendar_event_id']!, _calendarEventIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      why: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}why']),
      minimumAction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}minimum_action']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      naggingCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nagging_count'])!,
      snoozedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}snoozed_until']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      calendarEventId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}calendar_event_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ScheduleTableTable createAlias(String alias) {
    return $ScheduleTableTable(attachedDatabase, alias);
  }
}

class ScheduleTableData extends DataClass
    implements Insertable<ScheduleTableData> {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? why;
  final String? minimumAction;
  final String category;
  final DateTime scheduledAt;
  final String status;
  final int naggingCount;
  final DateTime? snoozedUntil;
  final DateTime? completedAt;
  final String? calendarEventId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ScheduleTableData(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      this.why,
      this.minimumAction,
      required this.category,
      required this.scheduledAt,
      required this.status,
      required this.naggingCount,
      this.snoozedUntil,
      this.completedAt,
      this.calendarEventId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || why != null) {
      map['why'] = Variable<String>(why);
    }
    if (!nullToAbsent || minimumAction != null) {
      map['minimum_action'] = Variable<String>(minimumAction);
    }
    map['category'] = Variable<String>(category);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['status'] = Variable<String>(status);
    map['nagging_count'] = Variable<int>(naggingCount);
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || calendarEventId != null) {
      map['calendar_event_id'] = Variable<String>(calendarEventId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScheduleTableCompanion toCompanion(bool nullToAbsent) {
    return ScheduleTableCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      why: why == null && nullToAbsent ? const Value.absent() : Value(why),
      minimumAction: minimumAction == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumAction),
      category: Value(category),
      scheduledAt: Value(scheduledAt),
      status: Value(status),
      naggingCount: Value(naggingCount),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      calendarEventId: calendarEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarEventId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScheduleTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      why: serializer.fromJson<String?>(json['why']),
      minimumAction: serializer.fromJson<String?>(json['minimumAction']),
      category: serializer.fromJson<String>(json['category']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      status: serializer.fromJson<String>(json['status']),
      naggingCount: serializer.fromJson<int>(json['naggingCount']),
      snoozedUntil: serializer.fromJson<DateTime?>(json['snoozedUntil']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      calendarEventId: serializer.fromJson<String?>(json['calendarEventId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'why': serializer.toJson<String?>(why),
      'minimumAction': serializer.toJson<String?>(minimumAction),
      'category': serializer.toJson<String>(category),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'status': serializer.toJson<String>(status),
      'naggingCount': serializer.toJson<int>(naggingCount),
      'snoozedUntil': serializer.toJson<DateTime?>(snoozedUntil),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'calendarEventId': serializer.toJson<String?>(calendarEventId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScheduleTableData copyWith(
          {String? id,
          String? userId,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> why = const Value.absent(),
          Value<String?> minimumAction = const Value.absent(),
          String? category,
          DateTime? scheduledAt,
          String? status,
          int? naggingCount,
          Value<DateTime?> snoozedUntil = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> calendarEventId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ScheduleTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        why: why.present ? why.value : this.why,
        minimumAction:
            minimumAction.present ? minimumAction.value : this.minimumAction,
        category: category ?? this.category,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        status: status ?? this.status,
        naggingCount: naggingCount ?? this.naggingCount,
        snoozedUntil:
            snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        calendarEventId: calendarEventId.present
            ? calendarEventId.value
            : this.calendarEventId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ScheduleTableData copyWithCompanion(ScheduleTableCompanion data) {
    return ScheduleTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      why: data.why.present ? data.why.value : this.why,
      minimumAction: data.minimumAction.present
          ? data.minimumAction.value
          : this.minimumAction,
      category: data.category.present ? data.category.value : this.category,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      status: data.status.present ? data.status.value : this.status,
      naggingCount: data.naggingCount.present
          ? data.naggingCount.value
          : this.naggingCount,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      calendarEventId: data.calendarEventId.present
          ? data.calendarEventId.value
          : this.calendarEventId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('why: $why, ')
          ..write('minimumAction: $minimumAction, ')
          ..write('category: $category, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('naggingCount: $naggingCount, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('completedAt: $completedAt, ')
          ..write('calendarEventId: $calendarEventId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      title,
      description,
      why,
      minimumAction,
      category,
      scheduledAt,
      status,
      naggingCount,
      snoozedUntil,
      completedAt,
      calendarEventId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.why == this.why &&
          other.minimumAction == this.minimumAction &&
          other.category == this.category &&
          other.scheduledAt == this.scheduledAt &&
          other.status == this.status &&
          other.naggingCount == this.naggingCount &&
          other.snoozedUntil == this.snoozedUntil &&
          other.completedAt == this.completedAt &&
          other.calendarEventId == this.calendarEventId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ScheduleTableCompanion extends UpdateCompanion<ScheduleTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> why;
  final Value<String?> minimumAction;
  final Value<String> category;
  final Value<DateTime> scheduledAt;
  final Value<String> status;
  final Value<int> naggingCount;
  final Value<DateTime?> snoozedUntil;
  final Value<DateTime?> completedAt;
  final Value<String?> calendarEventId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ScheduleTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.why = const Value.absent(),
    this.minimumAction = const Value.absent(),
    this.category = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    this.naggingCount = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.calendarEventId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleTableCompanion.insert({
    required String id,
    required String userId,
    required String title,
    this.description = const Value.absent(),
    this.why = const Value.absent(),
    this.minimumAction = const Value.absent(),
    this.category = const Value.absent(),
    required DateTime scheduledAt,
    this.status = const Value.absent(),
    this.naggingCount = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.calendarEventId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        title = Value(title),
        scheduledAt = Value(scheduledAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ScheduleTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? why,
    Expression<String>? minimumAction,
    Expression<String>? category,
    Expression<DateTime>? scheduledAt,
    Expression<String>? status,
    Expression<int>? naggingCount,
    Expression<DateTime>? snoozedUntil,
    Expression<DateTime>? completedAt,
    Expression<String>? calendarEventId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (why != null) 'why': why,
      if (minimumAction != null) 'minimum_action': minimumAction,
      if (category != null) 'category': category,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (status != null) 'status': status,
      if (naggingCount != null) 'nagging_count': naggingCount,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (completedAt != null) 'completed_at': completedAt,
      if (calendarEventId != null) 'calendar_event_id': calendarEventId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? why,
      Value<String?>? minimumAction,
      Value<String>? category,
      Value<DateTime>? scheduledAt,
      Value<String>? status,
      Value<int>? naggingCount,
      Value<DateTime?>? snoozedUntil,
      Value<DateTime?>? completedAt,
      Value<String?>? calendarEventId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ScheduleTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      why: why ?? this.why,
      minimumAction: minimumAction ?? this.minimumAction,
      category: category ?? this.category,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      naggingCount: naggingCount ?? this.naggingCount,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      completedAt: completedAt ?? this.completedAt,
      calendarEventId: calendarEventId ?? this.calendarEventId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (why.present) {
      map['why'] = Variable<String>(why.value);
    }
    if (minimumAction.present) {
      map['minimum_action'] = Variable<String>(minimumAction.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (naggingCount.present) {
      map['nagging_count'] = Variable<int>(naggingCount.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (calendarEventId.present) {
      map['calendar_event_id'] = Variable<String>(calendarEventId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('why: $why, ')
          ..write('minimumAction: $minimumAction, ')
          ..write('category: $category, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('naggingCount: $naggingCount, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('completedAt: $completedAt, ')
          ..write('calendarEventId: $calendarEventId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineTableTable extends RoutineTable
    with TableInfo<$RoutineTableTable, RoutineTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notifyHourMeta =
      const VerificationMeta('notifyHour');
  @override
  late final GeneratedColumn<int> notifyHour = GeneratedColumn<int>(
      'notify_hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notifyMinuteMeta =
      const VerificationMeta('notifyMinute');
  @override
  late final GeneratedColumn<int> notifyMinute = GeneratedColumn<int>(
      'notify_minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, notifyHour, notifyMinute, isEnabled, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_table';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notify_hour')) {
      context.handle(
          _notifyHourMeta,
          notifyHour.isAcceptableOrUnknown(
              data['notify_hour']!, _notifyHourMeta));
    } else if (isInserting) {
      context.missing(_notifyHourMeta);
    }
    if (data.containsKey('notify_minute')) {
      context.handle(
          _notifyMinuteMeta,
          notifyMinute.isAcceptableOrUnknown(
              data['notify_minute']!, _notifyMinuteMeta));
    } else if (isInserting) {
      context.missing(_notifyMinuteMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notifyHour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notify_hour'])!,
      notifyMinute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notify_minute'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RoutineTableTable createAlias(String alias) {
    return $RoutineTableTable(attachedDatabase, alias);
  }
}

class RoutineTableData extends DataClass
    implements Insertable<RoutineTableData> {
  final String id;
  final String title;
  final int notifyHour;
  final int notifyMinute;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineTableData(
      {required this.id,
      required this.title,
      required this.notifyHour,
      required this.notifyMinute,
      required this.isEnabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['notify_hour'] = Variable<int>(notifyHour);
    map['notify_minute'] = Variable<int>(notifyMinute);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutineTableCompanion toCompanion(bool nullToAbsent) {
    return RoutineTableCompanion(
      id: Value(id),
      title: Value(title),
      notifyHour: Value(notifyHour),
      notifyMinute: Value(notifyMinute),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notifyHour: serializer.fromJson<int>(json['notifyHour']),
      notifyMinute: serializer.fromJson<int>(json['notifyMinute']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notifyHour': serializer.toJson<int>(notifyHour),
      'notifyMinute': serializer.toJson<int>(notifyMinute),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineTableData copyWith(
          {String? id,
          String? title,
          int? notifyHour,
          int? notifyMinute,
          bool? isEnabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      RoutineTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        notifyHour: notifyHour ?? this.notifyHour,
        notifyMinute: notifyMinute ?? this.notifyMinute,
        isEnabled: isEnabled ?? this.isEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RoutineTableData copyWithCompanion(RoutineTableCompanion data) {
    return RoutineTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notifyHour:
          data.notifyHour.present ? data.notifyHour.value : this.notifyHour,
      notifyMinute: data.notifyMinute.present
          ? data.notifyMinute.value
          : this.notifyMinute,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, notifyHour, notifyMinute, isEnabled, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.notifyHour == this.notifyHour &&
          other.notifyMinute == this.notifyMinute &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineTableCompanion extends UpdateCompanion<RoutineTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> notifyHour;
  final Value<int> notifyMinute;
  final Value<bool> isEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutineTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notifyHour = const Value.absent(),
    this.notifyMinute = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineTableCompanion.insert({
    required String id,
    required String title,
    required int notifyHour,
    required int notifyMinute,
    this.isEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        notifyHour = Value(notifyHour),
        notifyMinute = Value(notifyMinute),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RoutineTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? notifyHour,
    Expression<int>? notifyMinute,
    Expression<bool>? isEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notifyHour != null) 'notify_hour': notifyHour,
      if (notifyMinute != null) 'notify_minute': notifyMinute,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? notifyHour,
      Value<int>? notifyMinute,
      Value<bool>? isEnabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RoutineTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notifyHour: notifyHour ?? this.notifyHour,
      notifyMinute: notifyMinute ?? this.notifyMinute,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notifyHour.present) {
      map['notify_hour'] = Variable<int>(notifyHour.value);
    }
    if (notifyMinute.present) {
      map['notify_minute'] = Variable<int>(notifyMinute.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScheduleTableTable scheduleTable = $ScheduleTableTable(this);
  late final $RoutineTableTable routineTable = $RoutineTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [scheduleTable, routineTable];
}

typedef $$ScheduleTableTableCreateCompanionBuilder = ScheduleTableCompanion
    Function({
  required String id,
  required String userId,
  required String title,
  Value<String?> description,
  Value<String?> why,
  Value<String?> minimumAction,
  Value<String> category,
  required DateTime scheduledAt,
  Value<String> status,
  Value<int> naggingCount,
  Value<DateTime?> snoozedUntil,
  Value<DateTime?> completedAt,
  Value<String?> calendarEventId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ScheduleTableTableUpdateCompanionBuilder = ScheduleTableCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> title,
  Value<String?> description,
  Value<String?> why,
  Value<String?> minimumAction,
  Value<String> category,
  Value<DateTime> scheduledAt,
  Value<String> status,
  Value<int> naggingCount,
  Value<DateTime?> snoozedUntil,
  Value<DateTime?> completedAt,
  Value<String?> calendarEventId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ScheduleTableTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleTableTable> {
  $$ScheduleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get why => $composableBuilder(
      column: $table.why, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get minimumAction => $composableBuilder(
      column: $table.minimumAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get naggingCount => $composableBuilder(
      column: $table.naggingCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get snoozedUntil => $composableBuilder(
      column: $table.snoozedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get calendarEventId => $composableBuilder(
      column: $table.calendarEventId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ScheduleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleTableTable> {
  $$ScheduleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get why => $composableBuilder(
      column: $table.why, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get minimumAction => $composableBuilder(
      column: $table.minimumAction,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get naggingCount => $composableBuilder(
      column: $table.naggingCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get snoozedUntil => $composableBuilder(
      column: $table.snoozedUntil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get calendarEventId => $composableBuilder(
      column: $table.calendarEventId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ScheduleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleTableTable> {
  $$ScheduleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get why =>
      $composableBuilder(column: $table.why, builder: (column) => column);

  GeneratedColumn<String> get minimumAction => $composableBuilder(
      column: $table.minimumAction, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get naggingCount => $composableBuilder(
      column: $table.naggingCount, builder: (column) => column);

  GeneratedColumn<DateTime> get snoozedUntil => $composableBuilder(
      column: $table.snoozedUntil, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get calendarEventId => $composableBuilder(
      column: $table.calendarEventId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ScheduleTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduleTableTable,
    ScheduleTableData,
    $$ScheduleTableTableFilterComposer,
    $$ScheduleTableTableOrderingComposer,
    $$ScheduleTableTableAnnotationComposer,
    $$ScheduleTableTableCreateCompanionBuilder,
    $$ScheduleTableTableUpdateCompanionBuilder,
    (
      ScheduleTableData,
      BaseReferences<_$AppDatabase, $ScheduleTableTable, ScheduleTableData>
    ),
    ScheduleTableData,
    PrefetchHooks Function()> {
  $$ScheduleTableTableTableManager(_$AppDatabase db, $ScheduleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> why = const Value.absent(),
            Value<String?> minimumAction = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> naggingCount = const Value.absent(),
            Value<DateTime?> snoozedUntil = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> calendarEventId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduleTableCompanion(
            id: id,
            userId: userId,
            title: title,
            description: description,
            why: why,
            minimumAction: minimumAction,
            category: category,
            scheduledAt: scheduledAt,
            status: status,
            naggingCount: naggingCount,
            snoozedUntil: snoozedUntil,
            completedAt: completedAt,
            calendarEventId: calendarEventId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> why = const Value.absent(),
            Value<String?> minimumAction = const Value.absent(),
            Value<String> category = const Value.absent(),
            required DateTime scheduledAt,
            Value<String> status = const Value.absent(),
            Value<int> naggingCount = const Value.absent(),
            Value<DateTime?> snoozedUntil = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> calendarEventId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduleTableCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            description: description,
            why: why,
            minimumAction: minimumAction,
            category: category,
            scheduledAt: scheduledAt,
            status: status,
            naggingCount: naggingCount,
            snoozedUntil: snoozedUntil,
            completedAt: completedAt,
            calendarEventId: calendarEventId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScheduleTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduleTableTable,
    ScheduleTableData,
    $$ScheduleTableTableFilterComposer,
    $$ScheduleTableTableOrderingComposer,
    $$ScheduleTableTableAnnotationComposer,
    $$ScheduleTableTableCreateCompanionBuilder,
    $$ScheduleTableTableUpdateCompanionBuilder,
    (
      ScheduleTableData,
      BaseReferences<_$AppDatabase, $ScheduleTableTable, ScheduleTableData>
    ),
    ScheduleTableData,
    PrefetchHooks Function()>;
typedef $$RoutineTableTableCreateCompanionBuilder = RoutineTableCompanion
    Function({
  required String id,
  required String title,
  required int notifyHour,
  required int notifyMinute,
  Value<bool> isEnabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RoutineTableTableUpdateCompanionBuilder = RoutineTableCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<int> notifyHour,
  Value<int> notifyMinute,
  Value<bool> isEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$RoutineTableTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineTableTable> {
  $$RoutineTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notifyHour => $composableBuilder(
      column: $table.notifyHour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notifyMinute => $composableBuilder(
      column: $table.notifyMinute, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RoutineTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineTableTable> {
  $$RoutineTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notifyHour => $composableBuilder(
      column: $table.notifyHour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notifyMinute => $composableBuilder(
      column: $table.notifyMinute,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RoutineTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineTableTable> {
  $$RoutineTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get notifyHour => $composableBuilder(
      column: $table.notifyHour, builder: (column) => column);

  GeneratedColumn<int> get notifyMinute => $composableBuilder(
      column: $table.notifyMinute, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RoutineTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineTableTable,
    RoutineTableData,
    $$RoutineTableTableFilterComposer,
    $$RoutineTableTableOrderingComposer,
    $$RoutineTableTableAnnotationComposer,
    $$RoutineTableTableCreateCompanionBuilder,
    $$RoutineTableTableUpdateCompanionBuilder,
    (
      RoutineTableData,
      BaseReferences<_$AppDatabase, $RoutineTableTable, RoutineTableData>
    ),
    RoutineTableData,
    PrefetchHooks Function()> {
  $$RoutineTableTableTableManager(_$AppDatabase db, $RoutineTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> notifyHour = const Value.absent(),
            Value<int> notifyMinute = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineTableCompanion(
            id: id,
            title: title,
            notifyHour: notifyHour,
            notifyMinute: notifyMinute,
            isEnabled: isEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required int notifyHour,
            required int notifyMinute,
            Value<bool> isEnabled = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineTableCompanion.insert(
            id: id,
            title: title,
            notifyHour: notifyHour,
            notifyMinute: notifyMinute,
            isEnabled: isEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RoutineTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineTableTable,
    RoutineTableData,
    $$RoutineTableTableFilterComposer,
    $$RoutineTableTableOrderingComposer,
    $$RoutineTableTableAnnotationComposer,
    $$RoutineTableTableCreateCompanionBuilder,
    $$RoutineTableTableUpdateCompanionBuilder,
    (
      RoutineTableData,
      BaseReferences<_$AppDatabase, $RoutineTableTable, RoutineTableData>
    ),
    RoutineTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScheduleTableTableTableManager get scheduleTable =>
      $$ScheduleTableTableTableManager(_db, _db.scheduleTable);
  $$RoutineTableTableTableManager get routineTable =>
      $$RoutineTableTableTableManager(_db, _db.routineTable);
}
