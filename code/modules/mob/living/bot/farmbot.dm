#define FARMBOT_COLLECT 1
#define FARMBOT_WATER 2
#define FARMBOT_UPROOT 3
#define FARMBOT_NUTRIMENT 4

/datum/category_item/catalogue/technology/bot/farmbot
	name = "Bot - Farmbot"
	desc = "Farmbots are the fusion of mobile water tanks with sophisticated \
	cultivation routines. Designed to ease the burden of maintaining Hydroponics \
	gardens - often a vital facet of life in space - these bots are always in demand."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/bot/farmbot
	name = "Farmbot"
	desc = "The botanist's best friend."
	icon = 'icons/obj/bots/farmbots.dmi'
	icon_state = "farmbot0"
	health = 50
	maxHealth = 50
	req_one_access = list(ACCESS_SCIENCE_ROBOTICS, ACCESS_GENERAL_BOTANY, ACCESS_SCIENCE_XENOBIO)
	catalogue_data = list(/datum/category_item/catalogue/technology/bot/farmbot)

	var/action = "" // Used to update icon
	var/waters_trays = TRUE
	var/refills_water = TRUE
	var/uproots_weeds = TRUE
	var/replaces_nutriment = FALSE
	var/collects_produce = FALSE
	var/removes_dead = FALSE
	var/obj/structure/reagent_dispensers/watertank/tank

/mob/living/bot/farmbot/Initialize(mapload, newTank)
	. = ..(mapload)
	if(!newTank)
		newTank = new /obj/structure/reagent_dispensers/watertank(src)
	tank = newTank
	tank.forceMove(src)

/mob/living/bot/farmbot/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Farmbot", name)
		ui.open()

/mob/living/bot/farmbot/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	data["on"] = on
	data["tank"] = !!tank
	if(tank)
		data["tankVolume"] = tank.reagents.total_volume
		data["tankMaxVolume"] = tank.reagents.maximum_volume
	data["locked"] = locked

	data["waters_trays"] = null
	data["refills_water"] = null
	data["uproots_weeds"] = null
	data["replaces_nutriment"] = null
	data["collects_produce"] = null
	data["removes_dead"] = null

	if(!locked)
		data["waters_trays"] = waters_trays
		data["refills_water"] = refills_water
		data["uproots_weeds"] = uproots_weeds
		data["replaces_nutriment"] = replaces_nutriment
		data["collects_produce"] = collects_produce
		data["removes_dead"] = removes_dead

	return data

/mob/living/bot/farmbot/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	ui_interact(user)

/mob/living/bot/farmbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, SPAN_NOTICE("You short out [src]'s plant identifier circuits."))
		spawn(rand(30, 50))
			visible_message(SPAN_WARNING("[src] buzzes oddly."))
			emagged = TRUE
		return TRUE

/mob/living/bot/farmbot/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("power")
			if(!access_scanner.allowed(usr))
				return FALSE
			if(on)
				turn_off()
			else
				turn_on()
			. = TRUE

	if(locked)
		return TRUE

	switch(action)
		if("water")
			waters_trays = !waters_trays
			. = TRUE
		if("refill")
			refills_water = !refills_water
			. = TRUE
		if("weed")
			uproots_weeds = !uproots_weeds
			. = TRUE
		if("replacenutri")
			replaces_nutriment = !replaces_nutriment
			. = TRUE
		// No automatic hydroponics //TODO: Reconsider?
		// if("collect")
		// 	collects_produce = !collects_produce
		// 	. = TRUE
		// if("removedead")
		// 	removes_dead = !removes_dead
		// 	. = TRUE

/mob/living/bot/farmbot/update_icons()
	if(on && action)
		icon_state = "farmbot_[action]"
	else
		icon_state = "farmbot[on]"

/mob/living/bot/farmbot/handleRegular()
	if(emagged && prob(1))
		flick("farmbot_broke", src)

/mob/living/bot/farmbot/handleAdjacentTarget()
	UnarmedAttack(target)

/mob/living/bot/farmbot/lookForTargets()
	if(emagged)
		for(var/mob/living/carbon/human/H in view(7, src))
			target = H
			return
	else
		for(var/obj/machinery/portable_atmospherics/hydroponics/tray in view(7, src))
			if(confirmTarget(tray))
				target = tray
				return
		if(!target && refills_water && tank && tank.reagents.total_volume < tank.reagents.maximum_volume)
			for(var/obj/structure/sink/source in view(7, src))
				target = source
				return

/mob/living/bot/farmbot/calcTargetPath() // We need to land NEXT to the tray, because the tray itself is impassable
	target_path = AStar(
		get_turf(loc),
		get_turf(target),
		/turf/proc/CardinalTurfsWithAccess,
		/turf/proc/Distance,
		0,
		max_target_dist,
		1,
		id = botcard,
	)
	if(!target_path)
		ignore_list |= target
		target = null
		target_path = list()

/mob/living/bot/farmbot/stepToTarget() // Same reason
	var/turf/T = get_turf(target)
	if(!target_path.len || !T.Adjacent(target_path[target_path.len]))
		calcTargetPath()
	makeStep(target_path)

/mob/living/bot/farmbot/UnarmedAttack(var/atom/A, var/proximity)
	if(!..())
		return

	if(busy)
		return

	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = A

		var/t = confirmTarget(T)
		switch(t)
			if(0)
				return
			if(FARMBOT_COLLECT)
				action = "water" // Needs a better one
				update_icons()
				visible_message("<span class='notice'>[src] starts [T.dead? "removing the plant from" : "harvesting"] \the [A].</span>")

				busy = 1
				if(do_after(src, 30, A))
					visible_message("<span class='notice'>[src] [T.dead? "removes the plant from" : "harvests"] \the [A].</span>")
					T.attack_hand(src)
			if(FARMBOT_WATER)
				action = "water"
				update_icons()
				visible_message("<span class='notice'>[src] starts watering \the [A].</span>")

				busy = 1
				if(do_after(src, 30, A))
					playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
					visible_message("<span class='notice'>[src] waters \the [A].</span>")
					tank.reagents.trans_to(T, 100 - T.waterlevel)
			if(FARMBOT_UPROOT)
				action = "hoe"
				update_icons()
				visible_message("<span class='notice'>[src] starts uprooting the weeds in \the [A].</span>")

				busy = 1
				if(do_after(src, 30))
					visible_message("<span class='notice'>[src] uproots the weeds in \the [A].</span>")
					T.weedlevel = 0
			if(FARMBOT_NUTRIMENT)
				action = "fertile"
				update_icons()
				visible_message("<span class='notice'>[src] starts fertilizing \the [A].</span>")

				busy = 1
				if(do_after(src, 30, A))

					visible_message("<span class='notice'>[src] fertilizes \the [A].</span>")
					T.reagents.add_reagent("ammonia", 10)

		busy = 0
		action = ""
		update_icons()
		T.update_icon()
	else if(istype(A, /obj/structure/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return
		action = "water"
		update_icons()
		visible_message("<span class='notice'>[src] starts refilling its tank from \the [A].</span>")

		busy = 1
		while(do_after(src, 10) && tank.reagents.total_volume < tank.reagents.maximum_volume)
			tank.reagents.add_reagent("water", 100)
			if(prob(5))
				playsound(loc, 'sound/effects/slosh.ogg', 25, 1)

		busy = 0
		action = ""
		update_icons()
		visible_message("<span class='notice'>[src] finishes refilling its tank.</span>")
	else if(emagged && ishuman(A))
		var/action = pick("weed", "water")

		busy = 1
		spawn(50) // Some delay

			busy = 0
		switch(action)
			if("weed")
				flick("farmbot_hoe", src)
				do_attack_animation(A)
				if(prob(50))
					visible_message("<span class='danger'>[src] swings wildly at [A] with a minihoe, missing completely!</span>")
					return
				var/t = pick("slashed", "sliced", "cut", "clawed")
				A.attack_generic(src, 5, t)
			if("water")
				flick("farmbot_water", src)

				visible_message("<span class='danger'>[src] splashes [A] with water!</span>")
				tank.reagents.splash(A, 100)

/mob/living/bot/farmbot/explode()
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/material/minihoe(Tsec)
	new /obj/item/reagent_containers/glass/bucket(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)
	new /obj/item/analyzer/plant_analyzer(Tsec)

	if(tank)
		tank.loc = Tsec

	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return


/mob/living/bot/farmbot/confirmTarget(var/atom/targ)
	if(!..())
		return 0

	if(emagged && ishuman(targ))
		if(targ in view(world.view, src))
			return 1
		return 0

	if(istype(targ, /obj/structure/sink))
		if(!tank || tank.reagents.total_volume >= tank.reagents.maximum_volume)
			return 0
		return 1

	var/obj/machinery/portable_atmospherics/hydroponics/tray = targ
	if(!istype(tray))
		return 0

	if(tray.closed_system || !tray.seed)
		return 0

	if(tray.dead && removes_dead || tray.harvest && collects_produce)
		return FARMBOT_COLLECT

	else if(refills_water && tray.waterlevel < 40 && !tray.reagents.has_reagent("water") && tank.reagents.total_volume > 0)
		return FARMBOT_WATER

	else if(uproots_weeds && tray.weedlevel > 3)
		return FARMBOT_UPROOT

	else if(replaces_nutriment && tray.nutrilevel < 1 && tray.reagents.total_volume < 1)
		return FARMBOT_NUTRIMENT

	return 0

// Assembly

/obj/item/farmbot_arm_assembly
	name = "water tank/robot arm assembly"
	desc = "A water tank with a robot arm permanently grafted to it."
	icon = 'icons/obj/bots/farmbots.dmi'
	icon_state = "water_arm"
	var/build_step = 0
	var/created_name = "Farmbot"
	var/obj/tank
	w_class = ITEMSIZE_NORMAL


/obj/item/farmbot_arm_assembly/Initialize(mapload, theTank)
	. = ..(mapload)
	if(!theTank) // If an admin spawned it, it won't have a watertank it, so lets make one for em!
		tank = new /obj/structure/reagent_dispensers/watertank(src)
	else
		tank = theTank
		tank.forceMove(src)

/obj/structure/reagent_dispensers/watertank/attackby(var/obj/item/robot_parts/S, mob/user as mob)
	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		return ..()
	if(!user.attempt_consume_item_for_construction(S))
		return
	to_chat(user, "You add the robot arm to [src].")

	new /obj/item/farmbot_arm_assembly(loc, src)

/obj/structure/reagent_dispensers/watertank/attackby(var/obj/item/organ/external/S, mob/user as mob)
	if ((!istype(S, /obj/item/organ/external/arm)) || S.robotic != ORGAN_ROBOT)
		return ..()
	if(!user.attempt_consume_item_for_construction(S))
		return
	to_chat(user, "You add the robot arm to [src].")

	new /obj/item/farmbot_arm_assembly(loc, src)

/obj/item/farmbot_arm_assembly/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if((istype(W, /obj/item/analyzer/plant_analyzer)) && (build_step == 0))
		if(!user.attempt_consume_item_for_construction(W))
			return
		build_step++
		to_chat(user, "You add the plant analyzer to [src].")
		name = "farmbot assembly"

	else if((istype(W, /obj/item/reagent_containers/glass/bucket)) && (build_step == 1))
		if(!user.attempt_consume_item_for_construction(W))
			return
		build_step++
		to_chat(user, "You add a bucket to [src].")
		name = "farmbot assembly with bucket"

	else if((istype(W, /obj/item/material/minihoe)) && (build_step == 2))
		if(!user.attempt_consume_item_for_construction(W))
			return
		build_step++
		to_chat(user, "You add a minihoe to [src].")
		name = "farmbot assembly with bucket and minihoe"

	else if((isprox(W)) && (build_step == 3))
		if(!user.attempt_consume_item_for_construction(W))
			return
		build_step++
		to_chat(user, "You complete the Farmbot! Beep boop.")

		var/mob/living/bot/farmbot/S = new /mob/living/bot/farmbot(get_turf(src), tank)
		S.name = created_name
		qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = input(user, "Enter new robot name", name, created_name) as text
		t = sanitize(t, MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		created_name = t

/obj/item/farmbot_arm_assembly/attack_hand(mob/user, list/params)
	return //it's a converted watertank, no you cannot pick it up and put it in your backpack
