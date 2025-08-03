// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      budget: (json['budget'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'name': instance.name,
      'description': instance.description,
      'budget': instance.budget,
      'createdAt': instance.createdAt.toIso8601String(),
      'isActive': instance.isActive,
    };
