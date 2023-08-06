
import 'package:flutter/material.dart';
import 'package:matching_app/components/chat_bubble.dart';
import 'package:matching_app/common.dart';
import 'package:matching_app/screen/main/layouts/pined_chatting_header.dart';
import 'package:matching_app/utile/index.dart';
import 'package:matching_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matching_app/controller/auth_controllers.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class ChattingScreen extends ConsumerStatefulWidget {
  final String receiverUserPhone;
  final String receiverUserToken;
  final String receiverUserId;
  final String receiverUserAvatar;
  final String receiverUserName;
  final String receiverUserBadgeName;
  final String receiverUserBadgeColor;
  final String senderUserId;
  final String tab_val;
  
  const ChattingScreen({super.key, required this.receiverUserPhone, required this.receiverUserToken, required this.receiverUserId, required this.receiverUserAvatar, required this.receiverUserName, required this.receiverUserBadgeName, required this.receiverUserBadgeColor, required this.senderUserId, required this.tab_val});
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends ConsumerState<ChattingScreen>
    with WidgetsBindingObserver {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  bool isRead = false;
  String otherMessage = "";
  double screenHeight = 0;
  double keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (this.mounted) {
        setState(() {
          this.keyboardHeight = keyboardHeight;
        });
      }
    });
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);
    //  _focusNode.addListener(() {
    //   setState(() {
    //     isRead = false;
    //     _onFocusChange;
    //   });
    // });
  }

  void sendMessage() async {
    // only send message if there is something to send
    String msg = _messageController.text;
    _messageController.clear();
    if(msg.isNotEmpty) {
      final result = await _chatService.sendMessage(   
        widget.receiverUserToken, msg, widget.senderUserId);
        // clear the text controller after sending the message
        
    }
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('hh:mm').format(currentTime);
    final controller = ref.read(AuthProvider.notifier);
    controller.doChatting(widget.receiverUserId, widget.receiverUserToken, msg, formattedTime).then(
      (value) {
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {

      // Keyboard is displayed, so hide it
      // FocusScope.of(context).unfocus();
      isRead = true;
      final controller = ref.read(AuthProvider.notifier);
      controller.doMessage(widget.receiverUserId, widget.receiverUserToken).then(
        (value) {
        },
      );
    }
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    String badge_name = widget.receiverUserBadgeName;
    List<String> numberArray = badge_name.split(",");
    List<String> badgeArray = widget.receiverUserBadgeColor.split(",");
    List<BadgeItemObject> badgeList = [];
    for (var i = 0; i < numberArray.length; i++) {
      badgeList.add(BadgeItemObject(i, numberArray[i], false, badgeArray[i]));
    }
    if (_isKeyboardVisible == true) {
      
    } else {
      screenHeight = 510;
      // keyboardHeight = 0;
    }
    print(isRead);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                flexibleSpace:
                    FlexibleSpaceBar(background: PinedChattingHeader(
                        avatar: widget.receiverUserAvatar,
                        user_name: widget.receiverUserName,
                        user_id: widget.receiverUserId,
                        tab_v: widget.tab_val
                    )))),
        
        body: Stack(
          children: <Widget>[
          
          Container(
              padding: EdgeInsets.symmetric(horizontal: vww(context, 5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 8,
                      children: badgeList.map((BadgeItemObject e) {
                        String textColor = e.color;
                        return FilterChip(
                          label: Text(e.title,
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                  Color(int.parse(textColor.substring(2, 7),
                                              radix: 16) +
                                          0xFF000000))),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: Color(int.parse(textColor.substring(2, 7),
                                        radix: 16) +
                                    0xFF000000),
                                width: 1.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          backgroundColor: Colors.white,
                          selectedColor: Color(
                              int.parse(textColor.substring(2, 7), radix: 16) +
                                  0xFF000000),
                          onSelected: (bool value) {},
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          // maxHeight: isKeyboardDisplayed? screenHeight - keyboardHeight:screenHeight - keyboardHeight - 250,
                          maxHeight: screenHeight - keyboardHeight,
                          minHeight: screenHeight - keyboardHeight - 250
                        ),
                        child: ListView(
                          controller: _scrollController1,
                          padding: EdgeInsets.all(16),
                          children: [
                            _buildMessageList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     controller: _scrollController,
                  //     child: ConstrainedBox(
                  //       constraints: BoxConstraints(
                  //         maxHeight: screenHeight - keyboardHeight,
                  //       ),
                  //       child:_buildMessageList(),
                  //     )
                  //   ),
                  // ),

                  const SizedBox(height: 25,)
                ],
              )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Color.fromARGB(255, 193, 192, 201),
                            width: 0.5)),
                    color: Color.fromARGB(255, 230, 231, 234)),
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                constraints: BoxConstraints(
                  minHeight: 30,
                  maxHeight: vhh(context, 20),
                ),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt_rounded),
                              onPressed: () {},
                              color: const Color.fromARGB(255, 193, 192, 201),
                            )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child:TextFormField(
                        maxLines: null,
                        controller: _messageController,
                        keyboardType: TextInputType.multiline,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "メッセージを入力",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 193, 192, 201)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 193, 192, 201))),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 193, 192, 201)),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onTap: () {
                          setState(() {
                            isRead = true;
                          });
                        },
                      ),
                    )),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () { sendMessage(); },
                        color: BUTTON_MAIN,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiverUserToken, widget.senderUserId),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Center(
            child: Text('Error${snapshot.error}'),
          );
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Container(
            alignment: Alignment.topCenter,
            child: const Text("ボード機能でマッチングしました",
                textAlign: TextAlign.center,
                style: TextStyle(color: BUTTON_MAIN)));
        }

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          // Scroll to the last position after the snapshot updates
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        });

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          // Scroll to the last position after the snapshot updates
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            _scrollController1.animateTo(
              _scrollController1.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }
        });

        return Container(
            child: Column(
            children: snapshot.data!.docs.map<Widget>((document) => _buildMessageItem(document)).toList(),
          )  
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    // align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == widget.senderUserId) 
      ? Alignment.centerRight: Alignment.centerLeft;

    var sendType = (data['senderId'] == widget.senderUserId) 
      ? true : false;
    otherMessage = data['message'];
    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(left: 1, right: 1),
          child: Column(
            crossAxisAlignment: (data['senderId'] == widget.senderUserId)? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: (data['senderId'] == widget.senderUserId)? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              const SizedBox(height: 1,),
              ChatBubble(message: data['message'], s_compare: sendType.toString(), time: data['timestamp'], read_val: isRead.toString()),
            ],
          ),
        ),
    );
    
  }
}
