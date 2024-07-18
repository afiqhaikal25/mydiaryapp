import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({Key? key}) : super(key: key);

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  final List<String> _board = List.filled(9, '');
  String _currentPlayer = 'X';
  String _winner = '';
  int _moveCount = 0;
  GameMode _gameMode = GameMode.twoPlayers;

  static const List<List<int>> _winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  void _makeMove(int index) {
    if (_board[index].isEmpty && _winner.isEmpty) {
      setState(() {
        _board[index] = _currentPlayer;
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        _moveCount++;

        _checkForWin();
        if (_moveCount == 9 && _winner.isEmpty) {
          _winner = 'It\'s a Draw!';
        }

        if (_gameMode == GameMode.computer && _currentPlayer == 'O' && _winner.isEmpty) {
          _makeComputerMove();
        }
      });
    }
  }

  void _checkForWin() {
    for (final combination in _winningCombinations) {
      if (_board[combination[0]].isNotEmpty &&
          _board[combination[0]] == _board[combination[1]] &&
          _board[combination[1]] == _board[combination[2]]) {
        setState(() {
          _winner = 'Player ${_board[combination[0]]} Wins!';
        });
        break;
      }
    }
  }

  void _makeComputerMove() {
    final emptyCells = _board.asMap().entries.where((entry) => entry.value.isEmpty).toList();
    final randomIndex = Random().nextInt(emptyCells.length);
    final computerMoveIndex = emptyCells[randomIndex].key;

    Future.delayed(const Duration(milliseconds: 500), () {
      _makeMove(computerMoveIndex);
    });
  }

  void _resetGame() {
    setState(() {
      _board.fillRange(0, 9, '');
      _currentPlayer = 'X';
      _winner = '';
      _moveCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<GameMode>(
              value: _gameMode,
              onChanged: (mode) {
                setState(() {
                  _gameMode = mode!;
                  _resetGame();
                });
              },
              items: [
                DropdownMenuItem(
                  value: GameMode.twoPlayers,
                  child: const Text('2 Players'),
                ),
                DropdownMenuItem(
                  value: GameMode.computer,
                  child: const Text('Computer'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _board.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () => _makeMove(index),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                      if (_board[index] == 'X') {
                        return Colors.blue;
                      } else if (_board[index] == 'O') {
                        return Colors.red;
                      } else {
                        return Colors.white;
                      }
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    _board[index],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              _winner,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetGame,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum GameMode {
  twoPlayers,
  computer,
}
