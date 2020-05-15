
import 'dart:io';

import 'package:chat_flutter_firebase/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
    //FirebaseAuth.instance.currentUser(); //ou posso usar o listen para ficar ouvindo as mudanças de usuario
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      _currentUser = user;
    });
  }

  /*
   * Get User Firebase / Login
   */
  Future<FirebaseUser> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      //Google SignIn
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      //Firebase Credential com o Google Provider - Podemos fazer signin com Facebook provider entre outros
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken, 
        accessToken: googleSignInAuthentication.accessToken
      );

      //Firebase SignIn com credenciais - neste caso com o Google conforme credenciais acima
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;

      return user;
    
    } catch (error) {
      print(error);
      return null;
    }
  }

  /*
   * Send message or File message
   */
  void _sendMessage({String text, File imgFile}) async {
    final FirebaseUser user = await _getUser();

    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Não foi possível fazer Login, tente novamente!'),
          backgroundColor: Colors.red,
        )
      );
    }

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl
    };

    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance.ref().child('images').child(
        DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String imgUrl = await taskSnapshot.ref.getDownloadURL();

      data['imgUrl'] = imgUrl;
    }

    if (text != null) {
      data['text'] = text;
    }

    Firestore.instance.collection('messages').add(data);
  }

  /*
   * Build
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Chat Flutter'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('messages').snapshots(),
              builder: (context, snapshotMsgs) {
                switch (snapshotMsgs.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    List<DocumentSnapshot> documents = snapshotMsgs.data.documents.reversed.toList();
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(documents[index].data['text'] ?? documents[index].data['imgUrl']),
                        );
                      }
                    );
                }
              }
            )
          ),

          TextComposer(_sendMessage),
        ],
      ),
    );
  }

}