import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stopwatch_flutter/ui/elapsed_time_text_basic.dart';
import 'package:stopwatch_flutter/ui/reset_button.dart';
import 'package:stopwatch_flutter/ui/start_stop_button.dart';
import 'package:stopwatch_flutter/ui/stopwatch_renderer.dart';

import 'elapsed_time_text.dart';

class Stopwatch extends StatefulWidget {
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch>
    with SingleTickerProviderStateMixin {
  Duration _previouslapsedTime = Duration.zero;
  Duration _currentlapsedTime = Duration.zero;
  Duration get elapsedTime => _currentlapsedTime + _previouslapsedTime;
  late final Ticker _ticker;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _ticker = this.createTicker((elapsed) {
      setState(() {
        _currentlapsedTime = elapsed;
      });
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  //_toggleRunning
  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _ticker.start();
      } else {
        _ticker.stop();
        _previouslapsedTime += _currentlapsedTime;
        _currentlapsedTime = Duration.zero;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final radius = constraints.maxWidth / 2;
      return Stack(
        children: [
          StopWatchRenderer(
            elapsed: elapsedTime,
            radius: radius,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 80,
              height: 80,
              child: ResetButton(
                onPressed: () {
                  _ticker.stop();
                  setState(() {
                    _isRunning = false;
                    _previouslapsedTime = Duration.zero;
                    _currentlapsedTime = Duration.zero;
                  });
                },
                isRunning: _isRunning,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 80,
              height: 80,
              child: StartStopButton(
                onPressed: _toggleRunning,
                isRunning: _isRunning,
              ),
            ),
          ),
        ],
      );
    });
  }
}
