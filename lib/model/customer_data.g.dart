// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerDataAdapter extends TypeAdapter<CustomerData> {
  @override
  final int typeId = 0;

  @override
  CustomerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerData(
      id: fields[0] as int?,
      customername: fields[1] as String?,
      city: fields[2] as String?,
      mobile: fields[3] as String?,
      email: fields[4] as String?,
      curloc: fields[5] as String?,
      status: fields[6] as int?,
      firstLogin: fields[7] as bool?,
      isLogin: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customername)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.curloc)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.firstLogin)
      ..writeByte(8)
      ..write(obj.isLogin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
