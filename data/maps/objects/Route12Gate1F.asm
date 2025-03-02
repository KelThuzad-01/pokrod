	object_const_def
	const_export ROUTE12GATE1F_GUARD
	const_export ROUTE12_GATE1F_POKEMON_POKEBALL

Route12Gate1F_Object:
	db $a ; border block

	def_warp_events
	warp_event  4,  0, LAST_MAP, 1
	warp_event  5,  0, LAST_MAP, 2
	warp_event  4,  7, LAST_MAP, 3
	warp_event  5,  7, LAST_MAP, 3
	warp_event  8,  6, REDS_HOUSE_2F, 1

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_GUARD, STAY, NONE, TEXT_ROUTE12GATE1F_GUARD
	 ; Verificar si el jugador ya ha recibido a Gyarados
	    CheckEvent EVENT_GOT_ROUTE12_POKEMON
	    jr nz, .skip_pokeball  ; Si ya lo tiene, no crear la Poké Ball
	
	    ; Si aún no tiene el Pokémon, agregar la Poké Ball dinámicamente
	    ld a, 7   ; X posición
	    ld b, 5   ; Y posición
	    ld c, SPRITE_POKE_BALL
	    ld d, STAY
	    ld e, NONE
	    ld hl, TEXT_ROUTE12_GATE1F_POKEMON_POKEBALL
	    call PlaceObject   ; Crear la Poké Ball
	
	.skip_pokeball
	    ret

	def_warps_to ROUTE_12_GATE_1F
