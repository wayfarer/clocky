// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClientImpl _$$ClientImplFromJson(Map<String, dynamic> json) => _$ClientImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  hourlyRate: (json['hourlyRate'] as num).toDouble(),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$ClientImplToJson(_$ClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'hourlyRate': instance.hourlyRate,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };
