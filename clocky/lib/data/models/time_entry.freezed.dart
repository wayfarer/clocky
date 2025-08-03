// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) {
  return _TimeEntry.fromJson(json);
}

/// @nodoc
mixin _$TimeEntry {
  String get id => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isBillable => throw _privateConstructorUsedError;
  List<DateTime> get pausedAt => throw _privateConstructorUsedError;
  List<DateTime> get resumedAt => throw _privateConstructorUsedError;

  /// Serializes this TimeEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeEntryCopyWith<TimeEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeEntryCopyWith<$Res> {
  factory $TimeEntryCopyWith(TimeEntry value, $Res Function(TimeEntry) then) =
      _$TimeEntryCopyWithImpl<$Res, TimeEntry>;
  @useResult
  $Res call({
    String id,
    String projectId,
    DateTime startTime,
    DateTime? endTime,
    String? description,
    bool isBillable,
    List<DateTime> pausedAt,
    List<DateTime> resumedAt,
  });
}

/// @nodoc
class _$TimeEntryCopyWithImpl<$Res, $Val extends TimeEntry>
    implements $TimeEntryCopyWith<$Res> {
  _$TimeEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? isBillable = null,
    Object? pausedAt = null,
    Object? resumedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isBillable: null == isBillable
                ? _value.isBillable
                : isBillable // ignore: cast_nullable_to_non_nullable
                      as bool,
            pausedAt: null == pausedAt
                ? _value.pausedAt
                : pausedAt // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
            resumedAt: null == resumedAt
                ? _value.resumedAt
                : resumedAt // ignore: cast_nullable_to_non_nullable
                      as List<DateTime>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeEntryImplCopyWith<$Res>
    implements $TimeEntryCopyWith<$Res> {
  factory _$$TimeEntryImplCopyWith(
    _$TimeEntryImpl value,
    $Res Function(_$TimeEntryImpl) then,
  ) = __$$TimeEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String projectId,
    DateTime startTime,
    DateTime? endTime,
    String? description,
    bool isBillable,
    List<DateTime> pausedAt,
    List<DateTime> resumedAt,
  });
}

/// @nodoc
class __$$TimeEntryImplCopyWithImpl<$Res>
    extends _$TimeEntryCopyWithImpl<$Res, _$TimeEntryImpl>
    implements _$$TimeEntryImplCopyWith<$Res> {
  __$$TimeEntryImplCopyWithImpl(
    _$TimeEntryImpl _value,
    $Res Function(_$TimeEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? isBillable = null,
    Object? pausedAt = null,
    Object? resumedAt = null,
  }) {
    return _then(
      _$TimeEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isBillable: null == isBillable
            ? _value.isBillable
            : isBillable // ignore: cast_nullable_to_non_nullable
                  as bool,
        pausedAt: null == pausedAt
            ? _value._pausedAt
            : pausedAt // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
        resumedAt: null == resumedAt
            ? _value._resumedAt
            : resumedAt // ignore: cast_nullable_to_non_nullable
                  as List<DateTime>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeEntryImpl extends _TimeEntry {
  const _$TimeEntryImpl({
    required this.id,
    required this.projectId,
    required this.startTime,
    this.endTime,
    this.description,
    this.isBillable = true,
    final List<DateTime> pausedAt = const [],
    final List<DateTime> resumedAt = const [],
  }) : _pausedAt = pausedAt,
       _resumedAt = resumedAt,
       super._();

  factory _$TimeEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String projectId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isBillable;
  final List<DateTime> _pausedAt;
  @override
  @JsonKey()
  List<DateTime> get pausedAt {
    if (_pausedAt is EqualUnmodifiableListView) return _pausedAt;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pausedAt);
  }

  final List<DateTime> _resumedAt;
  @override
  @JsonKey()
  List<DateTime> get resumedAt {
    if (_resumedAt is EqualUnmodifiableListView) return _resumedAt;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resumedAt);
  }

  @override
  String toString() {
    return 'TimeEntry(id: $id, projectId: $projectId, startTime: $startTime, endTime: $endTime, description: $description, isBillable: $isBillable, pausedAt: $pausedAt, resumedAt: $resumedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isBillable, isBillable) ||
                other.isBillable == isBillable) &&
            const DeepCollectionEquality().equals(other._pausedAt, _pausedAt) &&
            const DeepCollectionEquality().equals(
              other._resumedAt,
              _resumedAt,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    projectId,
    startTime,
    endTime,
    description,
    isBillable,
    const DeepCollectionEquality().hash(_pausedAt),
    const DeepCollectionEquality().hash(_resumedAt),
  );

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeEntryImplCopyWith<_$TimeEntryImpl> get copyWith =>
      __$$TimeEntryImplCopyWithImpl<_$TimeEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeEntryImplToJson(this);
  }
}

abstract class _TimeEntry extends TimeEntry {
  const factory _TimeEntry({
    required final String id,
    required final String projectId,
    required final DateTime startTime,
    final DateTime? endTime,
    final String? description,
    final bool isBillable,
    final List<DateTime> pausedAt,
    final List<DateTime> resumedAt,
  }) = _$TimeEntryImpl;
  const _TimeEntry._() : super._();

  factory _TimeEntry.fromJson(Map<String, dynamic> json) =
      _$TimeEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get projectId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  String? get description;
  @override
  bool get isBillable;
  @override
  List<DateTime> get pausedAt;
  @override
  List<DateTime> get resumedAt;

  /// Create a copy of TimeEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeEntryImplCopyWith<_$TimeEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
