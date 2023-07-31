class_name StatusResource
extends Resource

enum OffType {
	NONE, TICKS_COUNT, TIME
}
enum Tags {
	EMPTY, BURNING
}
@export_range(0.1, 5.0, 0.1) var tick_time: float = 1.0
@export_range(1, 10) var status_count_max: int = 1
@export var off_type: OffType = OffType.NONE
@export_range(0, 10) var ticks_count_max: int = 0
@export_range(0.0, 30.0, 0.1) var time_max: float = 0.0
@export var off_on_dead: bool = true

var tick_action: Callable = func(status: Status): pass
var tag: Tags = Tags.EMPTY
