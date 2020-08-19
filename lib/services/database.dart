import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakulima/model/product.dart';

class DatabaseMethods {
  final String userId;
  DatabaseMethods({this.userId});
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection(userId)
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  getFarmerRecordsByEmail() async {
    return await Firestore.instance.collection(userId).getDocuments();
  }

  Future uploadUserInfo(String name, String date, int kilograms) async {
    return await Firestore.instance.collection(userId).document().setData(
        {'name': name, 'date': date, 'kilograms': kilograms}).catchError((e) {
      print(e.toString());
    });
  }

  //product list frm snapshot
  List<Product> _productListSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Product(
          name: doc.data['name'] ?? '',
          date: doc.data['date'] ?? '',
          kilograms: doc.data['kilograms'] ?? 0);
    }).toList();
  }

  Stream<List<Product>> get products {
    return Firestore.instance
        .collection(userId)
        .snapshots()
        .map(_productListSnapshot);
  }

  uploadMilkInfo(userMap) {
    Firestore.instance.collection(userId).add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
