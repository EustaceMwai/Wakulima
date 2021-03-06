import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wakulima/model/product.dart';

class DatabaseMethods {
  final String userId;

  DatabaseMethods({this.userId});

  final CollectionReference col = Firestore.instance.collection("farmers");

  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("farmers")
        .where("id", isEqualTo: userId)
        .getDocuments();
  }

  getChatUserUsername(String username) async {
    return await Firestore.instance
        .collection("wakulima")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getFarmerId(int id) async {
    return await Firestore.instance
        .collection("wakulima")
        .where("farmerId", isEqualTo: id)
        .getDocuments();
  }

  getOnlineStatus(String username) async {
    return await Firestore.instance
        .collection("wakulima")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection("wakulima")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  getUserName() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("wakulima")
        .document(user.uid)
        .get();
  }

  getFarmerRecordsByEmail() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("farmers")
        .where("email", isEqualTo: user.email)
        .orderBy("date", descending: true)
        .getDocuments();
  }

  getVeterinaries() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("wakulima")
        .where("veterinary", isEqualTo: true)
        .getDocuments();
  }

  getFarmerLoanRecord() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
  }

  getFarmerLoanState() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("loans")
        .where("email", isEqualTo: user.email)
        .getDocuments();
  }

  getFarmerAdditionalLoanState() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("additionalLoans")
        .where("email", isEqualTo: user.email)
        .getDocuments();
  }

  getAllUsers() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance.collection("wakulima").getDocuments();
  }

  getLoanDetails() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("loans")
        .document(user.uid)
        .get();
  }

  getUserDetails() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("wakulima")
        .document(user.uid)
        .get();
  }

  getAllUserLoans() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance.collection("loans").getDocuments();
  }

  getAllOtherLoans() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    return await Firestore.instance
        .collection("additionalLoans")
        .getDocuments();
  }

  Future uploadUserInfo(
      String userId, String name, String date, int kilograms) async {
    return await col.document(userId).setData({
      'id': userId,
      'name': name,
      'date': date,
      'kilograms': kilograms
    }).catchError((e) {
      print(e.toString());
    });
  }

  uploadUsersInfo(userMap) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    Firestore.instance
        .collection("wakulima")
        .document(user.uid)
        .setData(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadVetInfo(userMap) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    Firestore.instance
        .collection("wakulima")
        .document(user.uid)
        .updateData(userMap)
        .catchError((e) {
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

  Future uploadMilkInfo(
      String userId, String name, String date, int kilograms) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();

    return await col.document(userId).setData({
      'id': user.uid,
      'email': user.email,
      'date': date,
      'kilograms': kilograms
    }).catchError((e) {
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
