import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogicScreen extends StatefulWidget {
  const LogicScreen({super.key});

  @override
  State<LogicScreen> createState() => _LogicScreenState();
}

class _LogicScreenState extends State<LogicScreen> {
  bool _gameStarted = false;
  int _countdown = 3;
  bool _isCountingDown = false;
  String _userAnswer = '';
  String _feedback = '';
  int _score = 0;
  List<Map<String, dynamic>> _shuffledPuzzles = [];
  int _currentPuzzleIndex = 0;

  final List<Map<String, dynamic>> _puzzles = [
    {'question': "What has keys but can’t open locks?", 'answer': 'keyboard'},
    {'question': "The more you take, the more you leave behind. What am I?", 'answer': 'footsteps'},
    {'question': "I speak without a mouth and hear without ears. What am I?", 'answer': 'echo'},
    {'question': "What has hands but can’t clap?", 'answer': 'clock'},
    {'question': "I’m tall when I’m young, and I’m short when I’m old. What am I?", 'answer': 'candle'},
    {'question': "The more you remove from me, the bigger I get. What am I?", 'answer': 'hole'},
    {'question': "What comes once in a minute, twice in a moment, but never in a thousand years?", 'answer': 'm'},
    {'question': "What has to be broken before you can use it?", 'answer': 'egg'},
  ];

  @override
  void initState() {
    super.initState();
    _shufflePuzzles();
  }

  void _shufflePuzzles() {
    setState(() {
      _shuffledPuzzles = List.from(_puzzles)..shuffle();
      _currentPuzzleIndex = 0;
    });
  }

  void _startGame() {
    setState(() {
      _isCountingDown = true;
      _countdown = 3;
      _score = 0;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          timer.cancel();
          _isCountingDown = false;
          _gameStarted = true;
          _shufflePuzzles();
        }
      });
    });
  }

  void _checkAnswer() {
    setState(() {
      if (_userAnswer.toLowerCase() == _shuffledPuzzles[_currentPuzzleIndex]['answer']) {
        _feedback = 'Correct!';
        _score++;
        _userAnswer = '';
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            if (_currentPuzzleIndex < _shuffledPuzzles.length - 1) {
              _currentPuzzleIndex++;
            } else {
              _gameStarted = false;
            }
          });
        });
      } else {
        _feedback = 'Try again!';
      }
    });
  }

  Widget _buildActionButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed}) {
    return CupertinoButton(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(12),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        middle: const Text(
          'LOGIC',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: Colors.redAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!_gameStarted)
              Column(
                children: [
                  _buildActionButton(
                    context,
                    label: 'Start Game',
                    icon: CupertinoIcons.play_circle,
                    onPressed: _startGame,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A logic game is designed to challenge and enhance critical thinking, '
                        'problem-solving, and reasoning skills through puzzles and logical deductions.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 15),
                  if (_isCountingDown)
                    Text(
                      'Starting in $_countdown...',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    _shuffledPuzzles[_currentPuzzleIndex]['question'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: $_score',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CupertinoTextField(
                    placeholder: 'Enter your answer',
                    placeholderStyle: TextStyle(color: Colors.white70),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.redAccent,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    onChanged: (value) {
                      setState(() {
                        _userAnswer = value;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  _buildActionButton(
                    context,
                    label: 'Submit',
                    icon: CupertinoIcons.check_mark_circled_solid,
                    onPressed: _checkAnswer,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _feedback,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _feedback.contains('Correct') ? Colors.green : Colors.redAccent,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}