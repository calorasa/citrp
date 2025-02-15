/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands.  It allows for faster than light travel to far-flung locations and even alternate realities."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = 1
	anchored = 1
	var/active = 0


/obj/machinery/gateway/Initialize(mapload)
	update_icon()
	if(dir == SOUTH)
		density = 0
	. = ..()

/obj/machinery/gateway/update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"



//this is da important part wot makes things go
/obj/machinery/gateway/centerstation
	density = 1
	icon_state = "offcenter"
	use_power = USE_POWER_IDLE

	//warping vars
	var/list/linked = list()
	var/ready = 0				//have we got all the parts for a gateway?
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/gateway/centeraway/awaygate = null

/obj/machinery/gateway/centerstation/Initialize(mapload)
	update_icon()
	wait = world.time + config_legacy.gateway_delay	//+ thirty minutes default
	awaygate = locate(/obj/machinery/gateway/centeraway)
	. = ..()
	density = TRUE

/obj/machinery/gateway/centerstation/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centerstation/process(delta_time)
	if(machine_stat & (NOPOWER))
		if(active) toggleoff()
		return

	if(active)
		use_power(5000)


/obj/machinery/gateway/centerstation/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in GLOB.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/gateway/centerstation/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!powered())		return
	if(!awaygate)
		to_chat(user, "<span class='notice'>Error: No destination found. Please program gateway.</span>")
		return
	if(world.time < wait)
		to_chat(user, "<span class='notice'>Error: Warpspace triangulation in progress. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes.</span>")
		return
	if(!awaygate.calibrated && !LAZYLEN(awaydestinations))
		to_chat(user, SPAN_NOTICE("Error: Destination gate uncalibrated. Gateway unsafe to use without far-end calibration update."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centerstation/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centerstation/attack_hand(mob/user, list/params)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


//okay, here's the good teleporting stuff
/obj/machinery/gateway/centerstation/Bumped(atom/movable/M as mob|obj)
	if(!ready)		return
	if(!active)		return
	if(!awaygate)	return

	use_power(5000)
	SEND_SOUND(M, sound('sound/effects/phasein.ogg'))
	playsound(src, 'sound/effects/phasein.ogg', 100, 1)
	if(awaygate.calibrated)
		M.forceMove(get_step(awaygate.loc, SOUTH))
		M.setDir(SOUTH)
		return
	else
		var/obj/landmark/dest = pick(awaydestinations)
		if(dest)
			M.forceMove(dest.loc)
			M.setDir(SOUTH)
		return

/obj/machinery/gateway/centerstation/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool))
		if(!awaygate)
			awaygate = locate(/obj/machinery/gateway/centeraway)
			if(!awaygate) // We still can't find the damn thing because there is no destination.
				to_chat(user, "<span class='notice'>Error: Programming failed. No destination found.</span>")
				return
			to_chat(user, "<span class='notice'><b>Startup programming successful!</b></span>: A destination in another point of space and time has been detected.")
		else
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return

/////////////////////////////////////Away////////////////////////


/obj/machinery/gateway/centeraway
	density = 1
	icon_state = "offcenter"
	use_power = USE_POWER_OFF
	var/calibrated = 1
	var/list/linked = list()	//a list of the connected gateway chunks
	var/ready = 0
	var/obj/machinery/gateway/centeraway/stationgate = null


/obj/machinery/gateway/centeraway/Initialize(mapload)
	update_icon()
	stationgate = locate(/obj/machinery/gateway/centerstation)
	. = ..()
	density = 1


/obj/machinery/gateway/centeraway/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centeraway/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in GLOB.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/gateway/centeraway/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!stationgate || !calibrated)
		to_chat(user, SPAN_NOTICE("Error: No destination found. Please calibrate gateway."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centeraway/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centeraway/attack_hand(mob/user, list/params)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


/obj/machinery/gateway/centeraway/Bumped(atom/movable/M as mob|obj)
	if(!ready)	return
	if(!active)	return
	if(istype(M, /mob/living/carbon))
		for(var/obj/item/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				to_chat(M, "<font color='black'>The station gate has detected your exile implant and is blocking your entry.</font>")
				return
	M.forceMove(get_step(stationgate.loc, SOUTH))
	M.setDir(SOUTH)
	SEND_SOUND(M, sound('sound/effects/phasein.ogg'))
	playsound(src, 'sound/effects/phasein.ogg', 100, 1)


/obj/machinery/gateway/centeraway/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool))
		if(calibrated && stationgate)
			to_chat(user, "<font color='black'>The gate is already calibrated, there is no work for you to do here.</font>")
			return
		else
			stationgate = locate(/obj/machinery/gateway/centerstation)
			if(!stationgate)
				to_chat(user, "<span class='notice'>Error: Recalibration failed. No destination found... That can't be good.</span>")
				return
			else
				to_chat(user, "<font color=#4F49AF><b>Recalibration successful!</b>:</font><font color='black'> This gate's systems have been fine tuned. Travel to this gate will now be on target.</font>")
				calibrated = 1
				return
