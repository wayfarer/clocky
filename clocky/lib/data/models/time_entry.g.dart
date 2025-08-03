// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeEntryImpl _$$TimeEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimeEntryImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      description: json['description'] as String?,
      isBillable: json['isBillable'] as bool? ?? true,
    );

Map<String, dynamic> _$$TimeEntryImplToJson(_$TimeEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'description': instance.description,
      'isBillable': instance.isBillable,
    };
