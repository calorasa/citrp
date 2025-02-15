/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/head/that = 2,
		/obj/item/radio/headset/headset_service = 2,
		/obj/item/clothing/head/pin/flower,
		/obj/item/clothing/head/pin/flower/pink,
		/obj/item/clothing/head/pin/flower/yellow,
		/obj/item/clothing/head/pin/flower/blue,
		/obj/item/clothing/head/pin/pink,
		/obj/item/clothing/head/pin/magnetic,
		/obj/item/clothing/under/sl_suit = 2,
		/obj/item/clothing/under/rank/bartender = 2,
		/obj/item/clothing/under/rank/bartender/skirt,
		/obj/item/clothing/under/rank/bartender/skirt_pleated,
		/obj/item/clothing/under/dress/dress_saloon,
		/obj/item/clothing/accessory/wcoat = 2,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/shoes/laceup)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "chef's closet"
	desc = "It's a storage unit for foodservice garments."
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/under/sundress,
		/obj/item/clothing/under/waiter = 2,
		/obj/item/radio/headset/headset_service = 2,
		/obj/item/storage/box/mousetraps = 2,
		/obj/item/clothing/under/rank/chef,
		/obj/item/clothing/under/rank/chef/skirt_pleated,
		/obj/item/clothing/head/chefhat,
		/obj/item/storage/bag/food = 2)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	icon_state = "mixed"
	icon_closed = "mixed"

	starts_with = list(
		/obj/item/clothing/under/rank/janitor,
		/obj/item/clothing/under/rank/janitor/skirt_pleated,
		/obj/item/clothing/under/dress/maid/janitor,
		/obj/item/radio/headset/headset_service,
		/obj/item/cartridge/janitor,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft/purple,
		/obj/item/clothing/head/beret/science,
		/obj/item/flashlight,
		/obj/item/caution = 4,
		/obj/item/lightreplacer,
		/obj/item/storage/bag/trash,
		/obj/item/storage/belt/janitor,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/reagent_containers/food/urinalcake,
		/obj/item/reagent_containers/food/urinalcake)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	icon_state = "blue"
	icon_closed = "blue"

	starts_with = list(
		/obj/item/clothing/under/lawyer/female = 2,
		/obj/item/clothing/under/lawyer/black = 2,
		/obj/item/clothing/under/lawyer/black/skirt = 2,
		/obj/item/clothing/under/lawyer/red = 2,
		/obj/item/clothing/under/lawyer/red/skirt = 2,
		/obj/item/clothing/suit/storage/toggle/internalaffairs = 2,
		/obj/item/clothing/under/lawyer/bluesuit = 2,
		/obj/item/clothing/under/lawyer/bluesuit/skirt = 2,
		/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 2,
		/obj/item/clothing/under/lawyer/purpsuit = 2,
		/obj/item/clothing/under/lawyer/purpsuit/skirt = 2,
		/obj/item/clothing/suit/storage/toggle/lawyer/purpjacket = 2,
		/obj/item/clothing/shoes/brown = 2,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/glasses/sunglasses/big = 2,
		/obj/item/clothing/under/lawyer/blue = 2,
		/obj/item/clothing/under/lawyer/blue/skirt = 2,
		/obj/item/cassette_tape/random = 2)
