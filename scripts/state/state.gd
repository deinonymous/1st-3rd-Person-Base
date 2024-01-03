extends Node3D

class_name State

var change_state: Callable
var animation
var persistent_state
var velocity = Vector3(0,0,0)

func setup(_change_state: Callable, _persistent_state):
  self.change_state = _change_state
  self.persistent_state = _persistent_state

func do_state(state_string) -> void:
  if !persistent_state.state_changed:
    if has_method(state_string):
      call(state_string)
      persistent_state.state_changed = true
    else:
      print("tried entering invalid state %s from %s" % [state_string, persistent_state.state.classname])
      persistent_state.state_changed = false
