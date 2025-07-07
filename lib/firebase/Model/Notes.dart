import 'package:cloud_firestore/cloud_firestore.dart';
class NoteModel{
  String? id;
  String? content;
  String? createdBy;
  Timestamp? createdAt;

  NoteModel({
    this.id,
    this.content,
    this.createdBy,
    this.createdAt,
  });

  factory NoteModel.fromJson(Map<String,dynamic>data, String? id)=> NoteModel(
    id: id,
    content: data['Content'],
    createdBy: data['CreatedBy'],
    createdAt: data['CreatedAt'],
  );

  Map<String,dynamic> toJson()=>{
    'id':id,
    'content':content,
    'createdBy':createdBy,
    'createdAt':createdAt,
  };
}