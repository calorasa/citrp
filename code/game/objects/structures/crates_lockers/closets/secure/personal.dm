/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	req_access = list(ACCESS_COMMAND_LOCKERS)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/PopulateContents()
	new /obj/item/radio/headset(src)
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel/norm(src)
	new /obj/item/instrument/piano_synth(src)

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/medigown(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/white(src)


/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

	starts_with = list(
		/obj/item/storage/backpack/satchel/withwallet,
		/obj/item/radio/headset
		)

/obj/structure/closet/secure_closet/personal/cabinet/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W as obj, mob/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			src.MouseDroppedOn(G.affecting, user)      //act like they were dragged onto the closet
		user.transfer_item_to_loc(W, loc)
	else if(W.GetID())
		var/obj/item/card/id/I = W.GetID()

		if(src.broken)
			to_chat(user, "<span class='warning'>It appears to be broken.</span>")
			return
		if(!I || !I.registered_name)	return
		if(src.allowed(user) || !src.registered_name || (istype(I) && (src.registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !( src.locked )
			if(src.locked)	src.icon_state = src.icon_locked
			else	src.icon_state = src.icon_closed

			if(!src.registered_name)
				src.registered_name = I.registered_name
				src.desc = "Owned by [I.registered_name]."
		else
			to_chat(user, "<span class='warning'>Access Denied</span>")
	else if(istype(W, /obj/item/melee/energy/blade))
		if(emag_act(INFINITY, user, "The locker has been sliced open by [user] with \an [W]!", "You hear metal being sliced and sparks flying."))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
	else
		to_chat(user, "<span class='warning'>Access Denied</span>")
	return

/obj/structure/closet/secure_closet/personal/emag_act(var/remaining_charges, var/mob/user, var/visual_feedback, var/audible_feedback)
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		if(visual_feedback)
			visible_message("<span class='warning'>[visual_feedback]</span>", "<span class='warning'>[audible_feedback]</span>")
		return 1

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Reset Lock"
	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	if(ishuman(usr))
		src.add_fingerprint(usr)
		if (src.locked || !src.registered_name)
			to_chat(usr, "<span class='warning'>You need to unlock it first.</span>")
		else if (src.broken)
			to_chat(usr, "<span class='warning'>It appears to be broken.</span>")
		else
			if (src.opened)
				if(!src.close())
					return
			src.locked = 1
			src.icon_state = src.icon_locked
			src.registered_name = null
			src.desc = "It's a secure locker for personnel. The first card swiped gains control."
	return
