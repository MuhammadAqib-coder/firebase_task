import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_task/Models/message_detail.dart';
import 'package:firebase_task/Views/ChatmainView/chat_main_view.dart';
import 'package:firebase_task/Views/Utils/util.dart';

// List<MessageDetail> chatList = [];

Future<DataSnapshot> getLoginUser() async {
  return await ref.child(auth.currentUser!.uid).get();
}

Future<void> userChatList(merge) async {
  // chatList.clear();
}

sendMessageToDB(String groupId, Map<String, dynamic> chatMessage, user1, user2,
    user2Members) async {
  var doc = FirebaseDatabase.instance
      .ref('chatrooms')
      .child(groupId)
      .child('chats')
      .push();
  chatMessage['id'] = doc.key;
  doc.set(chatMessage);
  members.add(user2['id']);
  var newMember = members.toList();
  // members = List.from(members)
  await FirebaseDatabase.instance
      .ref('users')
      .child(auth.currentUser!.uid)
      .update({"members": newMember});
  user2Members.add(user1['id']);
  var againNewMember = user2Members.toList();
  await FirebaseDatabase.instance
      .ref('users')
      .child(user2['id'])
      .update({"members": againNewMember});
}

chatExistence(merge, user1, user2) async {
  await FirebaseDatabase.instance
      .ref("chatrooms")
      .child(merge)
      .get()
      .then((value) async {
    if (value.exists) {
    } else {
      await FirebaseDatabase.instance.ref('chatrooms').child(merge).set({
        'time': DateTime.now().millisecondsSinceEpoch,
        'chatId': merge,
        'img1': '',
        'img2': ''
      });
    }
  });
}

Future getChatUser(members) async {
  dynamic temp = [];
  await FirebaseDatabase.instance.ref('users').get().then((doc) {
    var snapdata = doc.value as Map<dynamic, dynamic>;
    snapdata.forEach((key, value) {
      var chatUser = Map<String, dynamic>.from(value);
      if (members.contains(chatUser['id'])) {
        temp.add(chatUser);
      }
    });
  });
  return temp;
}

Future getGroupsChat(groups) async {
  dynamic temp = [];
  await FirebaseDatabase.instance.ref('groupchat').get().then((doc) {
    var snapshot = doc.value as Map<dynamic, dynamic>;
    snapshot.forEach((key, value) {
      var groupUser = Map<String, dynamic>.from(value);
      if (groups.contains(groupUser['group_id'])) {
        temp.add(groupUser);
      }
    });
  });
  return temp;
}

//get chatting user of login user
// chattingMemeber() async {
//   ref.child(auth.currentUser!.uid).child('members').onValue.listen((event) {
//     dynamic temp = event.snapshot.value;
//     getChatUser(members);
//   });
// }

//get user groups
// getUserGroups(uid) async {
//   return FirebaseDatabase.instance.ref('users').child(uid).onValue;
// }

//create group
// createGroup(userName, id, groupName, uid) async {
//   var docRef = FirebaseDatabase.instance.ref("groupchat").push();
//   await docRef.set({
//     "group_name": groupName,
//     "admin": "${id}_$userName",
//     "members": ["${uid}_$userName"],
//     "group_id": docRef.key,
//     "recent_message": "",
//     "recent_message_sender": ""
//   });
//   var userRef = FirebaseDatabase.instance.ref('users').child(uid);
//   return userRef.update({
//     "groups": ["${userRef.key}_$groupName"]
//   });
// }

//get group chats
// getGroupChats(groupId) async {
//   return await FirebaseDatabase.instance
//       .ref("groupchat")
//       .child(groupId)
//       .child('messages')
//       .orderByChild('time')
//       .onValue;
// }

//get group admin
getGroupAdmin(groupId) async {
  var data = await FirebaseDatabase.instance
      .ref("groupchat")
      .child(groupId)
      .child('admin')
      .get();
  var value = data.value as Map<String, dynamic>;
  return value['admin'];
}

//get group members
getGroupMembers(groupId) async {
  return FirebaseDatabase.instance.ref('groupchat').child(groupId).onValue;
}

//send message
sendGroupMessage(groupId, Map<String, dynamic> chatMessageData) async {
  var chatRef = FirebaseDatabase.instance
      .ref('groupchat')
      .child(groupId)
      .child('chats')
      .push();
  await chatRef.set(chatMessageData);
  // await FirebaseDatabase.instance.ref('groupchat').child(groupId).update({
  //   "recent_message": chatMessageData['message'],
  //   "recent_message_sender": chatMessageData['sender'],
  //   "recent_messge_time": chatMessageData['time'].toString()
  // });
}
