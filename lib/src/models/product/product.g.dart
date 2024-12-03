// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int,
      name: fields[1] as String,
      permalink: fields[2] as String,
      type: fields[3] as String,
      shortDescription: fields[4] as String,
      stockStatus: fields[5] as String,
      price: fields[6] as double,
      regularPrice: fields[7] as double,
      salePrice: fields[8] as double?,
      onSale: fields[9] as bool,
      images: (fields[10] as List).cast<String>(),
      metadata: (fields[11] as Map?)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.permalink)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.shortDescription)
      ..writeByte(5)
      ..write(obj.stockStatus)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.regularPrice)
      ..writeByte(8)
      ..write(obj.salePrice)
      ..writeByte(9)
      ..write(obj.onSale)
      ..writeByte(10)
      ..write(obj.images)
      ..writeByte(11)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
