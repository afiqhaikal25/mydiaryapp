import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int gridSize = 20;
  static const int snakeSpeed = 300; // milliseconds

  late Timer _timer;
  List<int> snake = [];
  int food = -1;
  Direction direction = Direction.right;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      snake = [44, 45];
      food = generateFood();
      direction = Direction.right;
      isGameOver = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: snakeSpeed), (timer) {
      moveSnake();
      if (checkCollision()) {
        gameOver();
      } else {
        setState(() {
          if (snake.first == food) {
            eatFood();
            food = generateFood();
          }
        });
      }
    });
  }

  int generateFood() {
    final random = Random();
    int newFood;
    do {
      newFood = random.nextInt(gridSize * gridSize);
    } while (snake.contains(newFood));
    return newFood;
  }

  void moveSnake() {
    setState(() {
      final head = snake.first;
      final nextPosition = getNextPosition(head);

      snake.insert(0, nextPosition);
      snake.removeLast();
    });
  }

  int getNextPosition(int currentPosition) {
    switch (direction) {
      case Direction.up:
        return (currentPosition - gridSize) % (gridSize * gridSize);
      case Direction.down:
        return (currentPosition + gridSize) % (gridSize * gridSize);
      case Direction.left:
        return currentPosition % gridSize == 0 ? currentPosition + gridSize - 1 : currentPosition - 1;
      case Direction.right:
        return (currentPosition + 1) % gridSize == 0 ? currentPosition - gridSize + 1 : currentPosition + 1;
    }
  }

  void eatFood() {
    setState(() {
      final head = snake.first;
      final nextPosition = getNextPosition(head);

      snake.insert(0, nextPosition);
    });
  }

  bool checkCollision() {
    final head = snake.first;
    final body = snake.sublist(1);
    return body.contains(head);
  }

  void gameOver() {
    setState(() {
      isGameOver = true;
      _timer.cancel();
    });
  }

  void handleSwipe(DragUpdateDetails details) {
    final dx = details.delta.dx;
    final dy = details.delta.dy;

    if (dx.abs() > dy.abs()) {
      if (dx > 0) {
        changeDirection(Direction.right);
      } else {
        changeDirection(Direction.left);
      }
    } else {
      if (dy > 0) {
        changeDirection(Direction.down);
      } else {
        changeDirection(Direction.up);
      }
    }
  }

  void changeDirection(Direction newDirection) {
    if (!isGameOver) {
      final isOppositeDirection = (direction == Direction.up && newDirection == Direction.down) ||
          (direction == Direction.down && newDirection == Direction.up) ||
          (direction == Direction.left && newDirection == Direction.right) ||
          (direction == Direction.right && newDirection == Direction.left);

      if (!isOppositeDirection) {
        setState(() {
          direction = newDirection;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cellSize = MediaQuery.of(context).size.width / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (details) => handleSwipe(details),
        onVerticalDragUpdate: (details) => handleSwipe(details),
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: gridSize * gridSize,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                        ),
                        itemBuilder: (context, index) {
                          final isSnakeCell = snake.contains(index);
                          final isFoodCell = index == food;

                          return Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: isSnakeCell ? Colors.green : (isFoodCell ? Colors.red : Colors.grey),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (isGameOver)
                Text(
                  'Game Over',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isGameOver ? startGame : null,
        child: Icon(isGameOver ? Icons.refresh : Icons.play_arrow),
      ),
    );
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}
