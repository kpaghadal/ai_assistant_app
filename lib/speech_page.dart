import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'ui_theme.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  late SpeechToText _speech;
  bool _isListening = false;
  bool _isInitialized = false;
  String _text = '';
  double _confidence = 1.0;
  String _status = 'Tap the mic to start';

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (mounted) {
            setState(() {
              _status = status;
              if (status == 'done' || status == 'notListening') {
                _isListening = false;
              }
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _status = 'Error: ${error.errorMsg}';
              _isListening = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Speech recognition error: ${error.errorMsg}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );

      if (mounted) {
        setState(() {
          _isInitialized = available;
          _status = available
              ? 'Ready to listen'
              : 'Speech recognition not available';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _status = 'Failed to initialize: $e';
        });
      }
    }
  }

  void _listen() async {
    if (!_isInitialized) {
      await _initializeSpeech();
      if (!_isInitialized) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speech recognition is not available on this device'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (!_isListening) {
      try {
        setState(() {
          _isListening = true;
          _status = 'Listening...';
        });

        await _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
              if (result.hasConfidenceRating && result.confidence > 0) {
                _confidence = result.confidence;
              }
              if (result.finalResult) {
                _status = 'Done';
              }
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          localeId: 'en_US',
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _isListening = false;
            _status = 'Error: $e';
          });
        }
      }
    } else {
      setState(() {
        _isListening = false;
        _status = 'Stopped';
      });
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBackground,

      /// SAME HEADER AS TRANSLATE PAGE
      appBar: const AppHeader(title: 'AI Assistant App', showBack: true),

      /// SAME BOTTOM NAVIGATION
      bottomNavigationBar: _bottomBar(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BIG TITLE (LIKE "Translate")
              const Center(
                child: Text(
                  'Speech to Text',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFBFD7C7)),
              const SizedBox(height: 16),

              /// STATUS + CONFIDENCE CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// STATUS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _status,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    /// CONFIDENCE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Confidence',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(_confidence * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// TRANSCRIBED TEXT BOX
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transcribed Text',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _text.isEmpty
                                ? 'Your transcribed text will appear here...\n\nTap the microphone button to start listening.'
                                : _text,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              color: _text.isEmpty
                                  ? AppColors.textMuted
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// MICROPHONE BUTTON
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _listen,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:
                              _isListening ? Colors.red : AppColors.brandGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening
                                      ? Colors.red
                                      : AppColors.brandGreen)
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isListening ? 'Tap to stop' : 'Tap to start listening',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SAME NAVIGATION BAR AS TRANSLATE PAGE
  Widget _bottomBar() {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xFFE9F0EB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home_outlined, size: 30, color: Colors.black87),
         
          Icon(Icons.settings, size: 30, color: Colors.black87),
        ],
      ),
    );
  }
}
