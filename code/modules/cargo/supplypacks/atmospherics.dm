/*
*	Here is where any supply packs related
*	to being atmospherics tasks live.
*/


/datum/supply_pack/atmos
	group = "Atmospherics"

/datum/supply_pack/atmos/inflatable
	name = "Inflatable barriers"
	contains = list(/obj/item/storage/briefcase/inflatable = 3)
	cost = 20
	container_type = /obj/structure/closet/crate/engineering
	container_name = "Inflatable Barrier Crate"

/datum/supply_pack/atmos/canister_empty
	name = "Empty gas canister"
	cost = 7
	container_name = "Empty gas canister crate"
	container_type = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister)

/datum/supply_pack/atmos/canister_air
	name = "Air canister"
	cost = 10
	container_name = "Air canister crate"
	container_type = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister/air)

/datum/supply_pack/atmos/canister_oxygen
	name = "Oxygen canister"
	cost = 15
	container_name = "Oxygen canister crate"
	container_type = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)

/datum/supply_pack/atmos/canister_nitrogen
	name = "Nitrogen canister"
	cost = 10
	container_name = "Nitrogen canister crate"
	container_type = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)

/datum/supply_pack/atmos/canister_phoron
	name = "Phoron gas canister"
	cost = 60
	container_name = "Phoron gas canister crate"
	container_type = /obj/structure/closet/crate/secure/large
	access = ACCESS_ENGINEERING_ATMOS
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)

/datum/supply_pack/atmos/canister_nitrous_oxide
	name = "N2O gas canister"
	cost = 15
	container_name = "N2O gas canister crate"
	container_type = /obj/structure/closet/crate/secure/large
	access = ACCESS_ENGINEERING_ATMOS
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrous_oxide)

/datum/supply_pack/atmos/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	cost = 15
	container_name = "CO2 canister crate"
	container_type = /obj/structure/closet/crate/secure/large
	access = ACCESS_ENGINEERING_ATMOS
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)

/datum/supply_pack/atmos/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	cost = 25
	container_type = /obj/structure/closet/crate/secure/large
	container_name = "Pipe Dispenser Crate"
	access = ACCESS_ENGINEERING_ATMOS

/datum/supply_pack/atmos/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	cost = 25
	container_type = /obj/structure/closet/crate/secure/large
	container_name = "Disposal Dispenser Crate"
	access = ACCESS_ENGINEERING_ATMOS

/datum/supply_pack/atmos/internals
	name = "Internals crate"
	contains = list(
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/air = 3
			)
	cost = 10
	container_type = /obj/structure/closet/crate/internals
	container_name = "Internals crate"

/datum/supply_pack/atmos/evacuation
	name = "Emergency equipment"
	contains = list(
			/obj/item/storage/toolbox/emergency = 2,
			/obj/item/clothing/suit/storage/hazardvest = 2,
			/obj/item/clothing/suit/storage/vest = 2,
			/obj/item/tank/emergency/oxygen/engi = 4,
			/obj/item/clothing/suit/space/emergency = 4,
			/obj/item/clothing/head/helmet/space/emergency = 4,
			/obj/item/clothing/mask/gas = 4
			)
	cost = 35
	container_type = /obj/structure/closet/crate/internals
	container_name = "Emergency crate"
