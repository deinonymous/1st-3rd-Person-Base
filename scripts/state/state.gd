extends Node3D

class_name State

var change_state: Callable
var animation
var persistent_state
var velocity = Vector3(0,0,0)


func setup(_change_state: Callable, _animation, _persistent_state):
  self.change_state = _change_state
  self.animation = _animation
  self.persistent_state = _persistent_state
