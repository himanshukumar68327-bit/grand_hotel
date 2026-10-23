import 'package:cloud_firestore/cloud_firestore.dart';
import 'room_model.dart';

class BookingModel {
  const BookingModel({required this.id, required this.room, required this.checkIn, required this.checkOut, required this.guests, required this.total, required this.status, this.guestName = '', this.guestPhone = '', this.createdAt});
  final String id, status, guestName, guestPhone;
  final RoomModel room;
  final DateTime checkIn, checkOut;
  final int guests, total;
  final DateTime? createdAt;
  Map<String,dynamic> toMap() => {'room':room.toMap(),'checkIn':Timestamp.fromDate(checkIn),'checkOut':Timestamp.fromDate(checkOut),'guests':guests,'total':total,'status':status,'guestName':guestName,'guestPhone':guestPhone,'createdAt':FieldValue.serverTimestamp()};
  factory BookingModel.fromDoc(DocumentSnapshot<Map<String,dynamic>> doc) {
    final m=doc.data() ?? {};
    DateTime date(dynamic v) => v is Timestamp ? v.toDate() : DateTime.tryParse('$v') ?? DateTime.now();
    return BookingModel(id:doc.id,room:RoomModel.fromMap(Map<String,dynamic>.from(m['room'] ?? {})),checkIn:date(m['checkIn']),checkOut:date(m['checkOut']),guests:(m['guests'] as num?)?.toInt() ?? 1,total:(m['total'] as num?)?.toInt() ?? 0,status:m['status'] ?? 'Requested',guestName:m['guestName'] ?? '',guestPhone:m['guestPhone'] ?? '',createdAt: m['createdAt'] is Timestamp ? (m['createdAt'] as Timestamp).toDate() : null);
  }
}
