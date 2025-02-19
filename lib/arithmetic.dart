import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

class ArithmeticScreen extends StatefulWidget {
  const ArithmeticScreen({super.key});

  @override
  State<ArithmeticScreen> createState() => _ArithmeticScreenState();
}

class _ArithmeticScreenState extends State<ArithmeticScreen> {
  int _operand1 = 0;
  int _operand2 = 0;
  String _operator = '+';
  int _answer = 0;
  int _userAnswer = 0;
  bool _isCorrect = false;
  String _feedback = '';
  int _score = 0;
  late Timer _timer;
  int _timeLeft = 60;
  bool _gameStarted = false;
  int _countdown = 3;
  bool _isCountingDown = false;

  void _generateProblem() {
    setState(() {
      _operand1 = _getRandomNumber(1, 10);
      _operand2 = _getRandomNumber(1, 10);
      _operator = _getRandomOperator();
      switch (_operator) {
        case '+':
          _answer = _operand1 + _operand2;
          break;
        case '-':
          _answer = _operand1 - _operand2;
          break;
        case '*':
          _answer = _operand1 * _operand2;
          break;
        case '/':
          _operand2 = _getRandomNumber(1, _operand1);
          _answer = _operand1 ~/ _operand2;
          break;
      }
    });
  }

  int _getRandomNumber(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  String _getRandomOperator() {
    List<String> operators = ['+', '-', '*', '/'];
    return operators[Random().nextInt(operators.length)];
  }

  void _checkAnswer() {
    setState(() {
      _isCorrect = _userAnswer == _answer;
      if (_isCorrect) {
        _score += 10;
      }
      _feedback = _isCorrect ? 'Correct!' : 'Incorrect. The correct answer is $_answer.';
      _userAnswer = 0;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _generateProblem();
    });
  }

  void _startGame() {
    setState(() {
      _isCountingDown = true;
      _countdown = 3;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          timer.cancel();
          _isCountingDown = false;
          _gameStarted = true;
          _score = 0;
          _timeLeft = 60;
          _generateProblem();
          _startTimer();
        }
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Time is Up!'),
          content: Text('Your score: $_score'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.pop(context);
                _startGame();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Back'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFF_1A_1A_1A),
        middle: const Text(
          'ARITHMETIC',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!_gameStarted)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildActionButton(
                    context,
                    label: 'Start Game',
                    icon: CupertinoIcons.play_circle,
                    onPressed: _startGame,
                  ),
                  SizedBox(height: 10), // Add some spacing between the button and description
                  Text(
                    'An arithmetic game is a game designed to help players practice and improve their math skills, such as addition, subtraction, multiplication, and division.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey, // You can customize the text style
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),


            const SizedBox(height: 50),
            if (_isCountingDown)
              Text(
                'Starting in $_countdown...',
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            if (_gameStarted && !_isCountingDown) ...[
              Text(
                '$_operand1 $_operator $_operand2 = ?',
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(height: 40),
              _buildInputField(),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                label: 'Submit',
                icon: CupertinoIcons.check_mark_circled_solid,
                onPressed: _checkAnswer,
              ),
              const SizedBox(height: 20),
              Text(
                _feedback,
                style: const TextStyle(fontSize: 18, color: CupertinoColors.activeBlue),
              ),
              const SizedBox(height: 20),
              Text(
                'Time Left: $_timeLeft seconds',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Score: $_score',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return CupertinoTextField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _userAnswer = int.tryParse(value) ?? 0;
        });
      },
      style: const TextStyle(color: Colors.white),
      placeholder: 'Enter your answer',
      placeholderStyle: TextStyle(color: Colors.white70),

      cursorColor: Colors.redAccent,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed}) {
    return CupertinoButton(
      color: Colors.red,
      borderRadius: BorderRadius.circular(12),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
