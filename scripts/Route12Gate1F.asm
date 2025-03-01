Route12Gate1F_Script:
	jp EnableAutoTextBoxDrawing

Route12Gate1F_TextPointers:
	def_text_pointers
	dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD
        dw_const Route12Gate1FPokeballText, TEXT_ROUTE12_GATE1F_POKEMON_POKEBALL

Route12Gate1FGuardText:
	text_far _Route12Gate1FGuardText
	text_end

Route12Gate1FPokeballText:
	text_asm
	lb bc, GYARADOS, 15
	call GivePokemon
	jr nc, .party_full
	ld a, HS_ROUTE12_GATE1F_POKEMON_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject
	db ROUTE_12_GATE_1F, ROUTE12_GATE1F_POKEMON_POKEBALL, SHOW
.party_full
	jp TextScriptEnd
