/obj/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 0
	damage_type = BURN
	nodamage = 1
	damage_flag = ARMOR_ENERGY
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"

	combustion = FALSE

	var/sev1_range = 0
	var/sev2_range = 1
	var/sev3_range = 1
	var/sev4_range = 1

/obj/projectile/ion/on_hit(var/atom/target, var/blocked = 0)
		empulse(target, sev1_range, sev2_range, sev3_range, sev4_range)
		return 1

/obj/projectile/ion/small
	sev1_range = -1
	sev2_range = 0
	sev3_range = 0
	sev4_range = 1

/obj/projectile/ion/pistol
	sev1_range = 0
	sev2_range = 0
	sev3_range = 0
	sev4_range = 0

/obj/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	damage_flag = ARMOR_BULLET
	sharp = 1
	edge = 1

/obj/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
	explosion(target, -1, 0, 2)
	..()

/obj/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	fire_sound = 'sound/weapons/pulse3.ogg'
	damage = 0
	damage_type = BURN
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE
	nodamage = 1
	damage_flag = ARMOR_ENERGY // It actually checks heat/cold protection.
	var/target_temperature = 50
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"

	combustion = FALSE

/obj/projectile/temp/on_hit(atom/target, blocked = FALSE)
	..()
	if(isliving(target))
		var/mob/living/L = target

		var/protection = null
		var/potential_temperature_delta = null
		var/new_temperature = L.bodytemperature

		if(target_temperature >= T20C) // Make it cold.
			protection = L.get_cold_protection(target_temperature)
			potential_temperature_delta = 75
			new_temperature = max(new_temperature - potential_temperature_delta, target_temperature)
		else // Make it hot.
			protection = L.get_heat_protection(target_temperature)
			potential_temperature_delta = 200 // Because spacemen temperature needs stupid numbers to actually hurt people.
			new_temperature = min(new_temperature + potential_temperature_delta, target_temperature)

		var/temp_factor = abs(protection - 1)

		new_temperature = round(new_temperature * temp_factor)
		L.bodytemperature = new_temperature

	return 1

/obj/projectile/temp/hot
	name = "heat beam"
	target_temperature = 1000

	combustion = TRUE

/obj/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	damage_flag = ARMOR_BULLET

/obj/projectile/meteor/Bump(atom/A as mob|obj|turf|area)
	if(A == firer)
		return

	LEGACY_EX_ACT(A, 2, null)
	playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

	for(var/mob/M in range(10, src))
		if(!M.stat && !istype(M, /mob/living/silicon/ai))\
			shake_camera(M, 3, 1)
	qdel(src)

/obj/projectile/meteor/slug
	name = "meteor"
	damage = 25
	damage_type = BRUTE
	nodamage = 0

/obj/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1
	damage_flag = ARMOR_ENERGY
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"

	combustion = FALSE

/obj/projectile/energy/floramut/on_hit(var/atom/target, var/blocked = 0)
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.species_flags & IS_PLANT) && (M.nutrition < 500))
			if(prob(15))
				// todo: less stunlock capability
				M.afflict_radiation(RAD_MOB_AFFLICT_FLORARAY_ON_PLANT, TRUE)
				M.Weaken(5)
				var/datum/gender/TM = GLOB.gender_datums[M.get_visible_gender()]
				for (var/mob/V in viewers(src))
					V.show_message("<font color='red'>[M] writhes in pain as [TM.his] vacuoles boil.</font>", 3, "<font color='red'>You hear the crunching of leaves.</font>", 2)
			if(prob(35))
			//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
			//		V.show_message("<font color='red'>[M] is mutated by the radiation beam.</font>", 3, "<font color='red'> You hear the snapping of twigs.</font>", 2)
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("<font color='red'>The radiation beam singes you!</font>")
			//	for (var/mob/V in viewers(src))
			//		V.show_message("<font color='red'>[M] is singed by the radiation beam.</font>", 3, "<font color='red'> You hear the crackle of burning leaves.</font>", 2)
	else if(istype(target, /mob/living/carbon/))
	//	for (var/mob/V in viewers(src))
	//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
		M.show_message("<font color=#4F49AF>The radiation beam dissipates harmlessly through your body.</font>")
	else
		return 1

/obj/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1
	damage_flag = ARMOR_ENERGY
	var/singleton/plantgene/gene = null

/obj/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 0
	damage_type = TOX
	nodamage = 1
	damage_flag = ARMOR_ENERGY
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"

/obj/projectile/energy/florayield/on_hit(var/atom/target, var/blocked = 0)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.species_flags & IS_PLANT) && (M.nutrition < 500))
			M.nutrition += 30
	else if (istype(target, /mob/living/carbon/))
		M.show_message("<font color=#4F49AF>The radiation beam dissipates harmlessly through your body.</font>")
	else
		return 1


/obj/projectile/beam/mindflayer
	name = "flayer ray"

	combustion = FALSE

/obj/projectile/beam/mindflayer/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.Confuse(rand(5,8))

/obj/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed_chance = 0 // nope
	nodamage = 1
	damage_type = HALLOSS
	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/projectile/bola
	name = "bola"
	icon_state = "bola"
	damage = 5
	embed_chance = 0 //Nada.
	damage_type = HALLOSS
	muzzle_type = null

	combustion = FALSE

/obj/projectile/bola/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		var/obj/item/handcuffs/legcuffs/bola/B = new(src.loc)
		if(!B.place_legcuffs(M,firer))
			if(B)
				qdel(B)
	..()

/obj/projectile/webball
	name = "ball of web"
	icon_state = "bola"
	damage = 10
	embed_chance = 0 //Nada.
	damage_type = BRUTE
	muzzle_type = null

	combustion = FALSE

/obj/projectile/webball/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target.loc))
		var/obj/effect/spider/stickyweb/W = locate() in get_turf(target)
		if(!W && prob(75))
			visible_message("<span class='danger'>\The [src] splatters a layer of web on \the [target]!</span>")
			new /obj/effect/spider/stickyweb(target.loc)
	..()

/obj/projectile/beam/tungsten
	name = "core of molten tungsten"
	icon_state = "energy"
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GRILLE
	damage = 70
	damage_type = BURN
	damage_flag = ARMOR_LASER
	light_range = 4
	light_power = 3
	light_color = "#3300ff"

	muzzle_type = /obj/effect/projectile/tungsten/muzzle
	tracer_type = /obj/effect/projectile/tungsten/tracer
	impact_type = /obj/effect/projectile/tungsten/impact

/obj/projectile/beam/tungsten/on_hit(var/atom/target, var/blocked = 0)
	if(isliving(target))
		var/mob/living/L = target
		L.add_modifier(/datum/modifier/grievous_wounds, 30 SECONDS)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L

			var/target_armor = H.legacy_mob_armor(def_zone, damage_flag)
			var/obj/item/organ/external/target_limb = H.get_organ(def_zone)

			var/armor_special = 0

			if(target_armor >= 60)
				var/turf/T = get_step(H, pick(GLOB.alldirs - src.dir))
				H.throw_at_old(T, 1, 1, src)
				H.apply_damage(20, BURN, def_zone)
				if(target_limb)
					armor_special = 2
					target_limb.fracture()

			else if(target_armor >= 45)
				H.apply_damage(15, BURN, def_zone)
				if(target_limb)
					armor_special = 1
					target_limb.dislocate()

			else if(target_armor >= 30)
				H.apply_damage(10, BURN, def_zone)
				if(prob(30) && target_limb)
					armor_special = 1
					target_limb.dislocate()

			else if(target_armor >= 15)
				H.apply_damage(5, BURN, def_zone)
				if(prob(15) && target_limb)
					armor_special = 1
					target_limb.dislocate()

			if(armor_special > 1)
				target.visible_message("<span class='cult'>\The [src] slams into \the [target]'s [target_limb], reverberating loudly!</span>")

			else if(armor_special)
				target.visible_message("<span class='cult'>\The [src] slams into \the [target]'s [target_limb] with a low rumble!</span>")

	..()

/obj/projectile/beam/tungsten/on_impact(var/atom/A)
	if(istype(A,/turf/simulated/shuttle/wall) || istype(A,/turf/simulated/wall) || (istype(A,/turf/simulated/mineral) && A.density) || istype(A,/obj/mecha) || istype(A,/obj/machinery/door))
		var/blast_dir = src.dir
		A.visible_message("<span class='danger'>\The [A] begins to glow!</span>")
		spawn(2 SECONDS)
			var/blastloc = get_step(A, blast_dir)
			if(blastloc)
				explosion(blastloc, -1, -1, 2, 3)
	..()

/obj/projectile/beam/tungsten/Bump(atom/A, forced=0)
	if(istype(A, /obj/structure/window)) //It does not pass through windows. It pulverizes them.
		var/obj/structure/window/W = A
		W.shatter()
		return 0
	..()

/obj/projectile/bullet/honker
	damage = 0
	nodamage = TRUE
	hitsound = 'sound/items/bikehorn.ogg'
	icon = 'icons/obj/items.dmi'
	icon_state = "banana"
	range = 200

/obj/projectile/bullet/honker/Initialize(mapload)
	. = ..()
	SpinAnimation()

/obj/projectile/bullet/honker/lethal
	damage = 20
	nodamage = FALSE
	damage_type = BRUTE

/obj/projectile/bullet/honker/lethal/Initialize(mapload)
	. = ..()
	SpinAnimation()

/obj/projectile/bullet/honker/lethal/light
	damage = 10

/obj/projectile/bullet/honker/lethal/heavy
	damage = 40

//Bio-Organic
/obj/projectile/bullet/organic
	damage = 10
	damage_type = BRUTE
	damage_flag = ARMOR_BULLET
	hitsound = 'sound/effects/splat.ogg'
	icon_state = "organic"

/obj/projectile/bullet/organic/wax
	damage_type = HALLOSS
	color = "#E6E685"
	icon_state = "organic"

/obj/projectile/bullet/organic/stinger
	damage = 15
	damage_type = TOX
	hitsound = 'sound/weapons/bladeslice.ogg'
	icon_state = "SpearFlight"

//Plasma Burst
/obj/projectile/plasma
	name ="plasma bolt"
	icon_state= "fuel-tritium"
	damage = 50
	damage_type = BURN
	damage_flag = ARMOR_ENERGY
	light_range = 4
	light_power = 3
	light_color = "#00ccff"

/obj/projectile/plasma/on_hit(var/atom/target, var/blocked = 0)
	explosion(target, -1, 0, 1, 2)
	..()

/obj/projectile/plasma/on_impact(var/atom/A)
	if(istype(A,/turf/simulated/shuttle/wall) || istype(A,/turf/simulated/wall) || (istype(A,/turf/simulated/mineral) && A.density) || istype(A,/obj/mecha) || istype(A,/obj/machinery/door))
		var/blast_dir = src.dir
		A.visible_message("<span class='danger'>\The [A] is engulfed in roiling plasma!</span>")
		var/blastloc = get_step(A, blast_dir)
		if(blastloc)
			explosion(blastloc, -1, 0, 1, 2)
	..()

/obj/projectile/plasma/Bump(atom/A, forced=0)
	if(istype(A, /obj/structure/window)) //It does not pass through windows. It pulverizes them.
		var/obj/structure/window/W = A
		W.shatter()
		return 0
	..()

/obj/projectile/plasma/hot
	name ="heavy plasma bolt"
	damage = 75
	light_range = 5
	light_power = 4
	light_color = "#00ccff"

/obj/projectile/plasma/hot/on_hit(var/atom/target, var/blocked = 0)
	explosion(target, -1, 0, 2, 3)
	..()

/obj/projectile/plasma/hot/on_impact(var/atom/A)
	if(istype(A,/turf/simulated/shuttle/wall) || istype(A,/turf/simulated/wall) || (istype(A,/turf/simulated/mineral) && A.density) || istype(A,/obj/mecha) || istype(A,/obj/machinery/door))
		var/blast_dir = src.dir
		A.visible_message("<span class='danger'>\The [A] is engulfed in roiling plasma!</span>")
		var/blastloc = get_step(A, blast_dir)
		if(blastloc)
			explosion(blastloc, -1, 0, 2, 3)
	..()
