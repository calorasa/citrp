PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = 1
	stat_tag = "PP"
	priority = FIRE_PRIORITY_PROJECTILES
	subsystem_flags = SS_NO_INIT|SS_TICKER
	var/global_max_tick_moves = 10
	var/global_pixel_speed = 2
	var/global_iterations_per_move = 16

/datum/controller/subsystem/processing/projectiles/proc/set_pixel_speed(new_speed)
	global_pixel_speed = new_speed
	for(var/i in processing)
		var/obj/projectile/P = i
		if(istype(P))			//there's non projectiles on this too.
			P.set_pixel_speed(new_speed)
