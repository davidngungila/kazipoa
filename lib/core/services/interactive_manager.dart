import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/storage_manager.dart';

/// Interactive Manager - Equivalent to JavaScript InteractivePageManager
/// Handles interactive elements, animations, and dynamic page behaviors
class InteractiveManager {
  Map<String, dynamic> _pageStates = {};
  final Map<String, Timer?> _animationTimers = {};
  final Map<String, StreamController?> _streamControllers = {};
  final List<void Function()> _interactionListeners = [];
  bool _isOnline = true;
  final List<Map<String, dynamic>> _recentActivities = [];

  // Getters
  Map<String, dynamic> get pageStates => _pageStates;
  bool get isOnline => _isOnline;
  List<Map<String, dynamic>> get recentActivities => _recentActivities;

  /// Initialize interactive manager
  Future<void> init() async {
    try {
      // Load saved page states
      final savedStates = await StorageManager.get<Map<String, dynamic>>('pageStates') ?? {};
      _pageStates = savedStates;
      
      // Load recent activities
      final savedActivities = await StorageManager.get<List<Map<String, dynamic>>>('recentActivities') ?? [];
      _recentActivities.addAll(savedActivities);
      
      // Initialize network monitoring
      _initializeNetworkMonitoring();
      
      print('Interactive manager initialized');
    } catch (e) {
      print('Error initializing interactive manager: $e');
    }
  }

  /// Initialize network monitoring
  void _initializeNetworkMonitoring() {
    // In a real implementation, you'd use connectivity_plus or similar
    // For now, we'll simulate online status
    Timer.periodic(const Duration(seconds: 30), (timer) {
      // Simulate network status changes
      final wasOnline = _isOnline;
      _isOnline = math.Random().nextBool();
      
      if (wasOnline != _isOnline) {
        _handleNetworkStatusChange(_isOnline);
      }
    });
  }

  /// Handle network status changes
  void _handleNetworkStatusChange(bool isOnline) {
    if (isOnline) {
      _addActivity('network_restored', 'Mtandao umerejeshwa');
      // Sync pending data when coming back online
      _syncPendingData();
    } else {
      _addActivity('network_lost', 'Mtandao umepotea');
    }
    
    _notifyInteractionListeners();
  }

  /// Set page state
  Future<void> setPageState(String page, Map<String, dynamic> state) async {
    _pageStates[page] = {
      ...state,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
    
    // Save to storage
    await StorageManager.set('pageStates', _pageStates);
    
    _notifyInteractionListeners();
    print('Page state updated for: $page');
  }

  /// Get page state
  Map<String, dynamic>? getPageState(String page) {
    return _pageStates[page];
  }

  /// Clear page state
  Future<void> clearPageState(String page) async {
    _pageStates.remove(page);
    await StorageManager.set('pageStates', _pageStates);
    _notifyInteractionListeners();
  }

  /// Start animation
  void startAnimation(String animationId, Duration duration, VoidCallback onComplete) {
    // Cancel existing animation if any
    _animationTimers[animationId]?.cancel();
    
    _animationTimers[animationId] = Timer(duration, () {
      _animationTimers.remove(animationId);
      onComplete();
    });
    
    print('Animation started: $animationId');
  }

  /// Stop animation
  void stopAnimation(String animationId) {
    final timer = _animationTimers[animationId];
    if (timer != null) {
      timer.cancel();
      _animationTimers.remove(animationId);
      print('Animation stopped: $animationId');
    }
  }

  /// Check if animation is running
  bool isAnimationRunning(String animationId) {
    return _animationTimers.containsKey(animationId);
  }

  /// Create stream for real-time updates
  Stream<T> createStream<T>(String streamId) {
    if (!_streamControllers.containsKey(streamId)) {
      _streamControllers[streamId] = StreamController<T>.broadcast();
    }
    
    return (_streamControllers[streamId] as StreamController<T>).stream;
  }

  /// Add data to stream
  void addToStream<T>(String streamId, T data) {
    final controller = _streamControllers[streamId];
    if (controller != null) {
      if (controller.isClosed) {
        _streamControllers[streamId] = StreamController<T>.broadcast();
      }
      (_streamControllers[streamId] as StreamController<T>).add(data);
    }
  }

  /// Close stream
  void closeStream(String streamId) {
    final controller = _streamControllers[streamId];
    if (controller != null && !controller.isClosed) {
      controller.close();
      _streamControllers.remove(streamId);
    }
  }

  /// Add user activity
  Future<void> _addActivity(String type, String description) async {
    final activity = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'description': description,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _recentActivities.insert(0, activity);
    
    // Keep only last 50 activities
    if (_recentActivities.length > 50) {
      _recentActivities.removeRange(50, _recentActivities.length);
    }
    
    // Save to storage
    await StorageManager.set('recentActivities', _recentActivities);
  }

  /// Get activities by type
  List<Map<String, dynamic>> getActivitiesByType(String type) {
    return _recentActivities.where((activity) => activity['type'] == type).toList();
  }

  /// Get recent activities (last 10)
  List<Map<String, dynamic>> getRecentActivities({int limit = 10}) {
    return _recentActivities.take(limit).toList();
  }

  /// Clear all activities
  Future<void> clearActivities() async {
    _recentActivities.clear();
    await StorageManager.remove('recentActivities');
  }

  /// Track user interaction
  Future<void> trackInteraction(String action, Map<String, dynamic>? data) async {
    final interaction = {
      'action': action,
      'data': data ?? {},
      'timestamp': DateTime.now().toIso8601String(),
      'page': _getCurrentPage(),
    };
    
    await _addActivity('user_interaction', '$action: ${data?.toString()}');
    print('Interaction tracked: $action');
  }

  /// Get current page (from navigation state)
  String _getCurrentPage() {
    // This would integrate with navigation manager
    // For now, return a default
    return 'unknown';
  }

  /// Sync pending data when coming back online
  Future<void> _syncPendingData() async {
    try {
      // Sync pending bookings, messages, etc.
      // This would integrate with other managers
      print('Syncing pending data...');
    } catch (e) {
      print('Error syncing pending data: $e');
    }
  }

  /// Create interactive element configuration
  Map<String, dynamic> createInteractiveElement({
    required String id,
    required String type,
    Map<String, dynamic>? properties,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    Function(bool)? onHover,
  }) {
    return {
      'id': id,
      'type': type,
      'properties': properties ?? {},
      'callbacks': {
        'onTap': onTap,
        'onLongPress': onLongPress,
        'onDoubleTap': onDoubleTap,
        'onHover': onHover,
      },
      'createdAt': DateTime.now().toIso8601String(),
      'isActive': true,
    };
  }

  /// Update interactive element
  void updateInteractiveElement(String id, Map<String, dynamic> updates) {
    final element = _pageStates['interactiveElements']?[id];
    if (element != null) {
      element.addAll(updates);
      element['updatedAt'] = DateTime.now().toIso8601String();
    }
  }

  /// Remove interactive element
  void removeInteractiveElement(String id) {
    final elements = _pageStates['interactiveElements'] as Map<String, dynamic>?;
    if (elements != null) {
      elements.remove(id);
    }
  }

  /// Get interactive elements for current page
  Map<String, dynamic> getInteractiveElements() {
    return _pageStates['interactiveElements'] as Map<String, dynamic>? ?? {};
  }

  /// Handle gesture events
  Future<void> handleGestureEvent({
    required String elementId,
    required String gesture,
    Map<String, dynamic>? data,
  }) async {
    final element = getInteractiveElements()[elementId];
    if (element == null) return;

    final callbacks = element['callbacks'] as Map<String, dynamic>?;
    if (callbacks == null) return;

    switch (gesture) {
      case 'tap':
        final onTap = callbacks['onTap'] as VoidCallback?;
        if (onTap != null) onTap();
        break;
      case 'longPress':
        final onLongPress = callbacks['onLongPress'] as VoidCallback?;
        if (onLongPress != null) onLongPress();
        break;
      case 'doubleTap':
        final onDoubleTap = callbacks['onDoubleTap'] as VoidCallback?;
        if (onDoubleTap != null) onDoubleTap();
        break;
      case 'hover':
        final onHover = callbacks['onHover'] as Function(bool)?;
        if (onHover != null) onHover(data?['isHovering'] ?? false);
        break;
    }

    await trackInteraction('gesture', {
      'elementId': elementId,
      'gesture': gesture,
      'data': data,
    });
  }

  /// Create animation configuration
  Map<String, dynamic> createAnimationConfig({
    required String id,
    required Duration duration,
    required Curve curve,
    Map<String, dynamic>? properties,
    VoidCallback? onComplete,
    VoidCallback? onStart,
  }) {
    return {
      'id': id,
      'duration': duration.inMilliseconds,
      'curve': curve.toString(),
      'properties': properties ?? {},
      'callbacks': {
        'onComplete': onComplete,
        'onStart': onStart,
      },
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Play animation
  Future<void> playAnimation(String animationId, Map<String, dynamic> config) async {
    final duration = Duration(milliseconds: config['duration'] as int);
    
    if (config['callbacks']['onStart'] != null) {
      (config['callbacks']['onStart'] as VoidCallback)();
    }
    
    startAnimation(animationId, duration, () {
      if (config['callbacks']['onComplete'] != null) {
        (config['callbacks']['onComplete'] as VoidCallback)();
      }
    });
  }

  /// Get animation progress (0.0 to 1.0)
  double getAnimationProgress(String animationId) {
    // In a real implementation, this would track actual animation progress
    // For now, return a simulated progress
    return _animationTimers.containsKey(animationId) ? 0.5 : 1.0;
  }

  /// Create interactive page configuration
  Map<String, dynamic> createPageConfig({
    required String pageId,
    Map<String, dynamic>? layout,
    Map<String, dynamic>? animations,
    Map<String, dynamic>? interactions,
    Map<String, dynamic>? transitions,
  }) {
    return {
      'pageId': pageId,
      'layout': layout ?? {},
      'animations': animations ?? {},
      'interactions': interactions ?? {},
      'transitions': transitions ?? {},
      'createdAt': DateTime.now().toIso8601String(),
      'isActive': true,
    };
  }

  /// Apply page configuration
  Future<void> applyPageConfig(Map<String, dynamic> config) async {
    final pageId = config['pageId'] as String;
    _pageStates['pageConfig_$pageId'] = config;
    
    await StorageManager.set('pageStates', _pageStates);
    
    // Apply animations, interactions, etc.
    if (config['animations'] != null) {
      final animations = config['animations'] as Map<String, dynamic>;
      for (final animId in animations.keys) {
        final animConfig = animations[animId];
        if (animConfig is Map<String, dynamic>) {
          await playAnimation(animId, animConfig);
        }
      }
    }
    
    print('Page config applied: $pageId');
  }

  /// Get page configuration
  Map<String, dynamic>? getPageConfig(String pageId) {
    return _pageStates['pageConfig_$pageId'];
  }

  /// Handle page transition
  Future<void> handlePageTransition({
    required String fromPage,
    required String toPage,
    String? transitionType,
    Duration? duration,
  }) async {
    final transition = {
      'fromPage': fromPage,
      'toPage': toPage,
      'transitionType': transitionType ?? 'slide',
      'duration': duration?.inMilliseconds ?? 300,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _addActivity('page_transition', 'Transition: $fromPage -> $toPage');
    
    // Apply transition animation
    if (transitionType != null) {
      startAnimation('transition_${fromPage}_$toPage', 
                  duration ?? const Duration(milliseconds: 300), 
                  () {});
    }
  }

  /// Create interactive form configuration
  Map<String, dynamic> createInteractiveForm({
    required String formId,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? validation,
    Map<String, dynamic>? submission,
  }) {
    return {
      'formId': formId,
      'fields': fields ?? {},
      'validation': validation ?? {},
      'submission': submission ?? {},
      'state': 'pristine',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Update form field value
  void updateFormField(String formId, String fieldId, dynamic value) {
    final form = _pageStates['form_$formId'] as Map<String, dynamic>?;
    if (form != null) {
      final fields = form['fields'] as Map<String, dynamic>?;
      if (fields != null) {
        fields[fieldId] = value;
        fields['${fieldId}_updated'] = DateTime.now().toIso8601String();
        form['state'] = 'dirty';
      }
    }
  }

  /// Get form field value
  dynamic getFormField(String formId, String fieldId) {
    final form = _pageStates['form_$formId'] as Map<String, dynamic>?;
    if (form != null) {
      final fields = form['fields'] as Map<String, dynamic>?;
      if (fields != null) {
        return fields[fieldId];
      }
    }
    return null;
  }

  /// Validate form
  Map<String, dynamic> validateForm(String formId) {
    final form = _pageStates['form_$formId'] as Map<String, dynamic>?;
    if (form == null) {
      return {'valid': false, 'errors': ['Form not found']};
    }

    final validation = form['validation'] as Map<String, dynamic>?;
    if (validation == null) {
      return {'valid': true, 'errors': []};
    }

    final fields = form['fields'] as Map<String, dynamic>?;
    if (fields == null) {
      return {'valid': false, 'errors': ['No fields to validate']};
    }

    final errors = <String>[];
    
    for (final fieldId in validation.keys) {
      final fieldValidation = validation[fieldId] as Map<String, dynamic>?;
      if (fieldValidation != null) {
        final value = fields[fieldId];
        final required = fieldValidation['required'] as bool? ?? false;
        
        if (required && (value == null || value.toString().isEmpty)) {
          errors.add('$fieldId is required');
        } else if (value != null && value.toString().isNotEmpty) {
          // Apply field-specific validation
          if (fieldValidation.containsKey('minLength')) {
            final minLength = fieldValidation['minLength'] as int;
            if (value.toString().length < minLength) {
              errors.add('$fieldId is too short (minimum $minLength characters)');
            }
          }
          if (fieldValidation.containsKey('maxLength')) {
            final maxLength = fieldValidation['maxLength'] as int;
            if (value.toString().length > maxLength) {
              errors.add('$fieldId is too long (maximum $maxLength characters)');
            }
          }
        }
      }
    }

    final isValid = errors.isEmpty;
    form['state'] = isValid ? 'valid' : 'invalid';
    
    return {
      'valid': isValid,
      'errors': errors,
    };
  }

  /// Reset form
  void resetForm(String formId) {
    final form = _pageStates['form_$formId'] as Map<String, dynamic>?;
    if (form != null) {
      final fields = form['fields'] as Map<String, dynamic>?;
      if (fields != null) {
        for (final fieldId in fields.keys) {
          fields[fieldId] = null;
          fields['${fieldId}_updated'] = null;
        }
      }
      form['state'] = 'pristine';
    }
  }

  /// Add interaction listener
  void addInteractionListener(void Function() listener) {
    _interactionListeners.add(listener);
  }

  /// Remove interaction listener
  void removeInteractionListener(void Function() listener) {
    _interactionListeners.remove(listener);
  }

  /// Notify all interaction listeners
  void _notifyInteractionListeners() {
    for (final listener in _interactionListeners) {
      try {
        listener();
      } catch (e) {
        print('Error in interaction listener: $e');
      }
    }
  }

  /// Get interactive statistics
  Map<String, dynamic> getInteractiveStatistics() {
    final totalInteractions = _recentActivities
        .where((activity) => activity['type'] == 'user_interaction')
        .length;
    
    final pageTransitions = _recentActivities
        .where((activity) => activity['type'] == 'page_transition')
        .length;
    
    final networkEvents = _recentActivities
        .where((activity) => ['network_lost', 'network_restored'].contains(activity['type']))
        .length;

    return {
      'totalInteractions': totalInteractions,
      'pageTransitions': pageTransitions,
      'networkEvents': networkEvents,
      'activeAnimations': _animationTimers.length,
      'activeStreams': _streamControllers.values.where((c) => c != null && !c.isClosed).length,
      'onlineStatus': _isOnline,
      'lastActivity': _recentActivities.isNotEmpty ? _recentActivities.first['timestamp'] : null,
    };
  }

  /// Clear all interactive data
  Future<void> clearAllData() async {
    _pageStates.clear();
    _animationTimers.forEach((id, timer) => timer?.cancel());
    _animationTimers.clear();
    _streamControllers.forEach((id, controller) {
      if (controller != null) {
        controller.close();
      }
    });
    _streamControllers.clear();
    _recentActivities.clear();
    
    await StorageManager.remove('pageStates');
    await StorageManager.remove('recentActivities');
    
    _notifyInteractionListeners();
    print('All interactive data cleared');
  }

  /// Dispose method
  void dispose() {
    _animationTimers.forEach((id, timer) => timer?.cancel());
    _animationTimers.clear();
    _streamControllers.forEach((id, controller) {
      if (controller != null) {
        controller.close();
      }
    });
    _streamControllers.clear();
    _interactionListeners.clear();
  }
}

// Provider
final interactiveManagerProvider = Provider<InteractiveManager>((ref) {
  final manager = InteractiveManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

// Extension for easy access in widgets
extension InteractiveManagerRef on WidgetRef {
  InteractiveManager get interactive => read(interactiveManagerProvider);
}
