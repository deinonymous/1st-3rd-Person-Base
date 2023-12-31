extends State

class_name CrouchState

func _ready():
  persistent_state.transition_camera_height(persistent_state.camera_crouch_height)
  persistent_state.animation.play("crouch")
  crouch()

func walk():
  persistent_state.transition_camera_height(persistent_state.camera_standing_height)
  change_state.call("walk")

func crouch():
  persistent_state.velocity = Vector3(0,0,0)

func sneak():
  change_state.call("sneak")

func run():
  pass

func fall():
  persistent_state.transition_camera_height(persistent_state.camera_standing_height)
  change_state.call("fall")

func idle():
  persistent_state.transition_camera_height(persistent_state.camera_standing_height)
  change_state.call("idle")

func jump():
  pass
