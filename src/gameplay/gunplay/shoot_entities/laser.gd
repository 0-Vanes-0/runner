class_name Laser
extends ShootEntity

signal shooted()

var raycast: RayCast2D
var line2d: Line2D
var collision_particle: CPUParticles2D
var weapon: Weapon
var tick_time: float
var timer := 0.0
var is_casting := false
var is_activated := false


func _init(resource: LaserSER, entity_owner: Owner, start_position: Vector2, target_position: Vector2, damage: int, tick_time: float, status_resource: StatusResource = null) -> void:
	super(resource, entity_owner, start_position, target_position, damage, status_resource)
	self.tick_time = tick_time
	self.name = "Laser"
	
	raycast = RayCast2D.new()
	self.add_child(raycast)
	raycast.target_position = Vector2.RIGHT * Global.SCREEN_WIDTH
	raycast.collide_with_areas = true
	raycast.collide_with_bodies = false
	raycast.set_collision_mask_value(1, false)
	if entity_owner == Owner.PLAYER:
		raycast.set_collision_mask_value(Global.Layers.ENEMY, true)
	else:
		raycast.set_collision_mask_value(Global.Layers.PLAYER, true)
	
	line2d = Line2D.new()
	raycast.add_child(line2d)
	line2d.add_point(Vector2.ZERO)
	line2d.add_point(Vector2.RIGHT * 100)
	line2d.default_color = Color.CRIMSON
	
	collision_particle = Preloader.laser_particles.instantiate() as CPUParticles2D
	raycast.add_child(collision_particle)


func _ready() -> void:
	line2d.points[1] = Vector2.ZERO
	weapon = get_parent() as Weapon
	assert(weapon)


func _physics_process(delta: float) -> void:
	if is_activated:
		var cast_point = raycast.target_position
		raycast.force_raycast_update()
		
		timer += delta
		if raycast.is_colliding():
			if timer >= tick_time:
				var health_comp: HealthComponent = raycast.get_collider() as HealthComponent
				if health_comp != null:
					health_comp.take_damage(self.damage)
			cast_point = to_local(raycast.get_collision_point())
		
		collision_particle.direction = raycast.get_collision_normal().normalized()
		collision_particle.position = cast_point
		line2d.points[1] = cast_point
		
		if timer >= tick_time:
			timer = 0.0
			shooted.emit()


func toggle_shoot_entity(is_active: bool, target_position := Vector2.ZERO):
	self.is_casting = is_active
	
	if is_casting:
		if target_position != Vector2.ZERO:
			raycast.target_position = raycast.target_position.rotated( (target_position - weapon.get_start_shoot_position()).angle() - raycast.target_position.angle() )
		
		if not is_activated:
			appear()
			timer = 0.0
			collision_particle.emitting = true
			is_activated = true
		
	else:
		collision_particle.emitting = false
		disappear()
		is_activated = false


func appear():
	var tween := create_tween()
	tween.tween_property(
			line2d, "width",
			10.0,
			0.2
	)


func disappear():
	var tween := create_tween()
	tween.tween_property(
			line2d, "width",
			0.0,
			0.1
	)
	tween.tween_callback(
			func():
				line2d.points[1] = self.position
	)
