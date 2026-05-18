import 'dart:async';
import 'package:flutter/foundation.dart';

class KaziLiveSession {
  final String id;
  final String clientId;
  final String proId;
  final String serviceName;
  final DateTime scheduledTime;
  final DateTime? actualStartTime;
  final DateTime? endTime;
  final KaziLiveStatus status;
  final Map<String, dynamic> bookingDetails;

  KaziLiveSession({
    required this.id,
    required this.clientId,
    required this.proId,
    required this.serviceName,
    required this.scheduledTime,
    this.actualStartTime,
    this.endTime,
    this.status = KaziLiveStatus.scheduled,
    required this.bookingDetails,
  });

  KaziLiveSession copyWith({
    String? id,
    String? clientId,
    String? proId,
    String? serviceName,
    DateTime? scheduledTime,
    DateTime? actualStartTime,
    DateTime? endTime,
    KaziLiveStatus? status,
    Map<String, dynamic>? bookingDetails,
  }) {
    return KaziLiveSession(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      proId: proId ?? this.proId,
      serviceName: serviceName ?? this.serviceName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      bookingDetails: bookingDetails ?? this.bookingDetails,
    );
  }
}

enum KaziLiveStatus {
  scheduled,
  countdown,
  live,
  completed,
  cancelled,
  expired,
}

class KaziLiveService extends ChangeNotifier {
  static final KaziLiveService _instance = KaziLiveService._internal();
  factory KaziLiveService() => _instance;
  KaziLiveService._internal();

  final List<KaziLiveSession> _sessions = [];
  List<KaziLiveSession> get sessions => List.unmodifiable(_sessions);

  KaziLiveSession? _activeSession;
  KaziLiveSession? get activeSession => _activeSession;

  Timer? _countdownTimer;
  Timer? _sessionTimer;
  final int _remainingSeconds = 0;

  // Get sessions for a specific client
  List<KaziLiveSession> getClientSessions(String clientId) {
    return _sessions.where((session) => session.clientId == clientId).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // Get sessions for a specific pro
  List<KaziLiveSession> getProSessions(String proId) {
    return _sessions.where((session) => session.proId == proId).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // Get sessions that are starting soon (within 24 hours)
  List<KaziLiveSession> getUpcomingSessions() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(hours: 24));
    
    return _sessions.where((session) {
      return session.scheduledTime.isAfter(now) &&
             session.scheduledTime.isBefore(tomorrow) &&
             session.status != KaziLiveStatus.cancelled &&
             session.status != KaziLiveStatus.completed;
    }).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // Get sessions currently in countdown
  List<KaziLiveSession> getCountdownSessions() {
    return _sessions.where((session) => 
      session.status == KaziLiveStatus.countdown
    ).toList();
  }

  // Get currently live sessions
  List<KaziLiveSession> getLiveSessions() {
    return _sessions.where((session) => 
      session.status == KaziLiveStatus.live
    ).toList();
  }

  // Create a new KaziLive session from booking
  KaziLiveSession createSessionFromBooking({
    required String clientId,
    required String proId,
    required String serviceName,
    required DateTime scheduledTime,
    required Map<String, dynamic> bookingDetails,
  }) {
    final session = KaziLiveSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      clientId: clientId,
      proId: proId,
      serviceName: serviceName,
      scheduledTime: scheduledTime,
      bookingDetails: bookingDetails,
    );

    _sessions.add(session);
    notifyListeners();
    
    debugPrint('Created KaziLive session: ${session.id} for $serviceName');
    
    // Start countdown if session is within 5 minutes
    _checkAndStartCountdown(session);
    
    return session;
  }

  // Start countdown for a session
  void startCountdown(String sessionId) {
    final session = _sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;

    final updatedSession = session.copyWith(status: KaziLiveStatus.countdown);
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    _sessions[index] = updatedSession;
    
    _startCountdownTimer(sessionId);
    notifyListeners();
  }

  // Start a live session
  void startLiveSession(String sessionId) {
    final session = _sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;

    _countdownTimer?.cancel();
    
    final updatedSession = session.copyWith(
      status: KaziLiveStatus.live,
      actualStartTime: DateTime.now(),
    );
    
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    _sessions[index] = updatedSession;
    
    _activeSession = updatedSession;
    _startSessionTimer(sessionId);
    notifyListeners();
    
    debugPrint('Started KaziLive session: $sessionId');
  }

  // End a live session
  void endSession(String sessionId) {
    final session = _sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;

    _countdownTimer?.cancel();
    _sessionTimer?.cancel();
    
    final updatedSession = session.copyWith(
      status: KaziLiveStatus.completed,
      endTime: DateTime.now(),
    );
    
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    _sessions[index] = updatedSession;
    
    if (_activeSession?.id == sessionId) {
      _activeSession = null;
    }
    
    notifyListeners();
    
    debugPrint('Ended KaziLive session: $sessionId');
  }

  // Cancel a session
  void cancelSession(String sessionId) {
    final session = _sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;

    _countdownTimer?.cancel();
    _sessionTimer?.cancel();
    
    final updatedSession = session.copyWith(
      status: KaziLiveStatus.cancelled,
      endTime: DateTime.now(),
    );
    
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    _sessions[index] = updatedSession;
    
    if (_activeSession?.id == sessionId) {
      _activeSession = null;
    }
    
    notifyListeners();
    
    debugPrint('Cancelled KaziLive session: $sessionId');
  }

  // Get remaining time for countdown
  String getRemainingTime(String sessionId) {
    final session = _sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null || session.status != KaziLiveStatus.countdown) {
      return '00:00';
    }

    final now = DateTime.now();
    final difference = session.scheduledTime.difference(now);
    
    if (difference.isNegative) {
      return '00:00';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  // Check if session should start countdown
  void _checkAndStartCountdown(KaziLiveSession session) {
    final now = DateTime.now();
    final timeUntilSession = session.scheduledTime.difference(now);
    
    // Start countdown if session is within 5 minutes
    if (timeUntilSession.inMinutes <= 5 && timeUntilSession.inSeconds > 0) {
      startCountdown(session.id);
    }
  }

  // Start countdown timer
  void _startCountdownTimer(String sessionId) {
    _countdownTimer?.cancel();
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final session = _sessions.where((s) => s.id == sessionId).firstOrNull;
      if (session == null || session.status != KaziLiveStatus.countdown) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      final timeUntilSession = session.scheduledTime.difference(now);
      
      if (timeUntilSession.inSeconds <= 0) {
        timer.cancel();
        startLiveSession(sessionId);
      }
      
      notifyListeners();
    });
  }

  // Start session timer (24 hour limit)
  void _startSessionTimer(String sessionId) {
    _sessionTimer?.cancel();
    
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final session = _sessions.where((s) => s.id == sessionId).firstOrNull;
      if (session == null || session.status != KaziLiveStatus.live) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      final sessionDuration = now.difference(session.actualStartTime ?? now);
      
      // End session after 24 hours
      if (sessionDuration.inHours >= 24) {
        timer.cancel();
        endSession(sessionId);
      }
      
      notifyListeners();
    });
  }

  // Initialize service and check for pending sessions
  void initialize() {
    debugPrint('Initializing KaziLive Service...');
    
    // Check all sessions and start countdowns if needed
    for (final session in _sessions) {
      _checkAndStartCountdown(session);
    }
  }

  // Cleanup expired sessions
  void cleanupExpiredSessions() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));
    
    _sessions.removeWhere((session) {
      return session.status == KaziLiveStatus.completed &&
             session.endTime != null &&
             session.endTime!.isBefore(yesterday);
    });
    
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }
}
