/obj/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	damage_flag = ARMOR_ENERGY
	var/flash_strength = 10

//releases a burst of light on impact or after travelling a distance
/obj/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	damage = 5
	range = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_colour = "#ffffff"

/obj/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < 1)
			M.flash_eyes()
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				flash_strength *= H.species.flash_mod

				if(flash_strength > 0)
					H.Confuse(flash_strength + 5)
					H.Blind(flash_strength)
					H.eye_blurry = max(H.eye_blurry, flash_strength + 5)
					H.adjustHalLoss(22 * (flash_strength / 5)) // Five flashes to stun.  Bit weaker than melee flashes due to being ranged.

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	src.visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")

	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
	sparks.set_up(2, 1, T)
	sparks.start()

	new /obj/effect/debris/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	new /obj/effect/particle_effect/smoke/illumination(T, 5, brightness, brightness, light_colour)

//No longer blinds, and flash strength has been greatly lowered but now set's on fire.
/obj/projectile/energy/flash/flare
	fire_sound = 'sound/weapons/grenade_launcher.ogg'
	damage = 20
	flash_range = 1
	brightness = 15
	flash_strength = 10
	incendiary = 1
	flammability = 2

/obj/projectile/energy/flash/flare/on_impact(var/atom/A)
	light_colour = pick("#e58775", "#ffffff", "#90ff90", "#a09030")

	..() //initial flash

	//residual illumination
	new /obj/effect/particle_effect/smoke/illumination(src.loc, rand(190,240) SECONDS, 8, 3, light_colour) //same lighting power as flare

/obj/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	fire_sound = 'sound/weapons/Gunshot2.ogg'
	taser_effect = 1
	agony = 40
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/projectile/energy/electrode/strong
	agony = 55

/obj/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	agony = 80

/obj/projectile/energy/electrode/goldenbolt	// MIGHTY GOLDEN BOLT
	name = "taser bolt"
	agony = 80

/obj/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	fire_sound = 'sound/weapons/pulse3.ogg'
	nodamage = 1
	damage_type = CLONE
	irradiate = 40
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"

	combustion = FALSE

/obj/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	agony = 120
	damage_flag = ARMOR_ENERGY

	combustion = FALSE

/obj/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	damage_type = TOX
	agony = 40
	stutter = 10

/obj/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20

/obj/projectile/energy/acid //Slightly up-gunned (Read: The thing does agony and checks bio resist) variant of the simple alien mob's projectile, for queens and sentinels.
	name = "acidic spit"
	icon_state = "neurotoxin"
	damage = 30
	damage_type = BURN
	agony = 10
	damage_flag = ARMOR_BIO
	armor_penetration = 25	// It's acid

	combustion = FALSE

/obj/projectile/energy/neurotoxin
	name = "neurotoxic spit"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = BIOACID
	agony = 80
	damage_flag = ARMOR_BIO
	armor_penetration = 25	// It's acid-based

	combustion = FALSE

/obj/projectile/energy/neurotoxin/toxic //New alien mob projectile to match the player-variant's projectiles.
	name = "neurotoxic spit"
	icon_state = "neurotoxin"
	damage = 20
	damage_type = BIOACID
	agony = 20
	damage_flag = ARMOR_BIO
	armor_penetration = 25	// It's acid-based

/obj/projectile/energy/phoron
	name = "phoron bolt"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 20
	damage_type = TOX
	irradiate = 20
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"

	combustion = FALSE

/obj/projectile/energy/plasmastun
	name = "plasma pulse"
	icon_state = "plasma_stun"
	fire_sound = 'sound/weapons/blaster.ogg'
	armor_penetration = 10
	range = 4
	damage = 5
	agony = 55
	damage_type = BURN
	vacuum_traversal = 0	//Projectile disappears in empty space

/obj/projectile/energy/plasmastun/proc/bang(var/mob/living/carbon/M)

	to_chat(M, "<span class='danger'>You hear a loud roar.</span>")
	playsound(M.loc, 'sound/effects/bang.ogg', 50, 1)
	var/ear_safety = 0
	ear_safety = M.get_ear_protection()
	if(ear_safety == 1)
		M.Confuse(150)
	else if (ear_safety > 1)
		M.Confuse(30)
	else if (!ear_safety)
		M.Stun(10)
		M.Weaken(2)
		M.ear_damage += rand(1, 10)
		M.ear_deaf = max(M.ear_deaf,15)
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
		if (prob(M.ear_damage - 5))
			to_chat(M, "<span class='danger'>You can't hear anything!</span>")
			M.sdisabilities |= SDISABILITY_DEAF
	else
		if (M.ear_damage >= 5)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
	M.update_icons() //Just to apply matrix transform for laying asap

/obj/projectile/energy/plasmastun/on_hit(var/atom/target)
	bang(target)
	. = ..()

/obj/projectile/energy/blue_pellet
	name = "suppressive pellet"
	icon_state = "blue_pellet"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 5
	armor_penetration = 75
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE
	damage_type = BURN
	damage_flag = ARMOR_ENERGY
	light_color = "#0000FF"

	embed_chance = 0
	muzzle_type = /obj/effect/projectile/muzzle/pulse

/obj/projectile/energy/phase
	name = "phase wave"
	icon_state = "phase"
	range = 25
	damage = 5
	SA_bonus_damage = 45	// 50 total on animals
	SA_vulnerability = MOB_CLASS_ANIMAL

/obj/projectile/energy/phase/light
	range = 15
	SA_bonus_damage = 35	// 40 total on animals

/obj/projectile/energy/phase/heavy
	range = 20
	SA_bonus_damage = 55	// 60 total on animals

/obj/projectile/energy/phase/heavy/cannon
	range = 30
	damage = 15
	SA_bonus_damage = 60	// 75 total on animals
