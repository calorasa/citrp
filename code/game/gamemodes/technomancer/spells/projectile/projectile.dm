/obj/item/spell/projectile
	name = "projectile template"
	icon_state = "generic"
	desc = "This is a generic template that shoots projectiles.  If you can read this, the game broke!"
	cast_methods = CAST_RANGED
	var/obj/projectile/spell_projectile = null
	var/energy_cost_per_shot = 0
	var/instability_per_shot = 0
	var/pre_shot_delay = 0
	var/fire_sound = null

/obj/item/spell/projectile/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(set_up(hit_atom, user))
		var/obj/projectile/new_projectile = make_projectile(spell_projectile, user)
		new_projectile.old_style_target(hit_atom)
		new_projectile.fire()
		log_and_message_admins("has casted [src] at \the [hit_atom].")
		if(fire_sound)
			playsound(get_turf(src), fire_sound, 75, 1)
		adjust_instability(instability_per_shot)
		return 1
	return 0

/obj/item/spell/projectile/proc/make_projectile(obj/projectile/projectile_type, mob/living/user)
	var/obj/projectile/P = new projectile_type(get_turf(user))
	P.damage = calculate_spell_power(P.damage)
	return P

/obj/item/spell/projectile/proc/set_up(atom/hit_atom, mob/living/user)
	if(spell_projectile)
		if(pay_energy(energy_cost_per_shot))
			if(pre_shot_delay)
				var/image/target_image = image(icon = 'icons/obj/spells.dmi', loc = get_turf(hit_atom), icon_state = "target")
				SEND_IMAGE(user, target_image)
				user.Stun(pre_shot_delay / 10)
				sleep(pre_shot_delay)
				qdel(target_image)
				if(owner)
					return TRUE
				return FALSE // We got dropped before the firing occured.
			return TRUE // No delay, no need to check.
	return FALSE
