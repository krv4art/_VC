import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/gemini_service.dart';
import '../providers/locale_provider.dart';
import '../providers/identification_provider.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';
import '../config/fish_prompts_manager.dart';

class ChatScreen extends StatefulWidget {
  final int? fishId;

  const ChatScreen({super.key, this.fishId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late final GeminiService _geminiService;
  bool _isLoading = false;
  String? _fishContext;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(
      useProxy: true,
      supabaseClient: Supabase.instance.client,
    );

    // Load fish context if fishId is provided
    if (widget.fishId != null) {
      final identificationProvider = context.read<IdentificationProvider>();
      final fish = identificationProvider.getIdentificationById(widget.fishId!);
      if (fish != null) {
        _fishContext = '''
Fish: ${fish.fishName} (${fish.scientificName})
Habitat: ${fish.habitat}
Diet: ${fish.diet}
''';
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'text': message, 'isUser': true});
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final localeProvider = context.read<LocaleProvider>();
      final response = await _geminiService.sendMessageWithHistory(
        message,
        languageCode: localeProvider.locale.languageCode,
        fishContext: _fishContext,
      );

      setState(() {
        _messages.add({'text': response, 'isUser': false});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'text': 'Error: ${e.toString()}', 'isUser': false});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _messages.clear();
                _geminiService.clearHistory();
              });
            },
            tooltip: l10n.chatClear,
          ),
        ],
      ),
      body: Column(
        children: [
          // Sample questions chip list
          if (_messages.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.chatSampleQuestions, style: AppTheme.h4),
                  const SizedBox(height: AppDimensions.space8),
                  Wrap(
                    spacing: AppDimensions.space8,
                    runSpacing: AppDimensions.space8,
                    children: FishPromptsManager.getSampleQuestions(
                      localeProvider.locale.languageCode,
                    ).map((question) {
                      return ActionChip(
                        label: Text(question),
                        onPressed: () {
                          _messageController.text = question;
                          _sendMessage();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      l10n.chatHint,
                      style: AppTheme.body.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(
                        message['text'],
                        message['isUser'],
                      );
                    },
                  ),
          ),

          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(AppDimensions.space8),
              child: CircularProgressIndicator(),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(AppDimensions.space16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [AppTheme.softShadow],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: l10n.chatPlaceholder,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space16,
                        vertical: AppDimensions.space12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                IconButton.filled(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.space12),
        padding: const EdgeInsets.all(AppDimensions.space12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        child: Text(
          text,
          style: AppTheme.body.copyWith(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
