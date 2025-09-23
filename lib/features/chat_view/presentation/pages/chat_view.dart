import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';
import 'package:sagar_chat_demo/features/chat_view/presentation/pages/widgets/chat_dailogs.dart';
import 'package:sagar_chat_demo/features/chat_view/presentation/pages/widgets/message_bubble.dart';
import 'package:sagar_chat_demo/features/chat_view/presentation/pages/widgets/message_input.dart';
import '../../domain/entities/message_entities.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatView extends StatefulWidget {
  final String myId;
  final String peerId;

  const ChatView({super.key, required this.myId, required this.peerId});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadChat(widget.myId, widget.peerId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoaded) {
              return BaseText(
                state.peerUser.displayName,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              );
            }
            return const SizedBox();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD), // A light blue
              Color(0xFFBBDEFB), // A slightly darker blue
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                    if(state.messages.isEmpty){
                      return Center(child: BaseText("No messages found"),);
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return MessageBubble(
                          message: message,
                          myId: widget.myId,
                          peerId: widget.peerId,
                          onLongPress: message.senderId == widget.myId
                              ? () => _showEditDeleteDialog(context, message)
                              : null,
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            MessageInput(
              controller: _messageController,
              onSend: () {
                if (_messageController.text.isNotEmpty) {
                  context.read<ChatCubit>().sendMessage(
                    widget.myId,
                    widget.peerId,
                    _messageController.text,
                  );
                  _messageController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDeleteDialog(BuildContext context, MessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => MessageEditDeleteDialog(
        onEdit: () {
          context.pop();
          _showEditDialog(context, message);
        },
        onDelete: () {
          context.pop();
          context.read<ChatCubit>().deleteMessage(
            widget.myId,
            widget.peerId,
            message.id,
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, MessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => MessageEditDialog(
        initialText: message.message,
        onSave: (newText) {
          context.read<ChatCubit>().editMessage(
            widget.myId,
            widget.peerId,
            message.id,
            newText,
          );
        },
      ),
    );
  }
}
