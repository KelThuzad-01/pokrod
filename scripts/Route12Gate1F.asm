const EVENT_GOT_ROUTE12_POKEMON

Route12Gate1F_Script:
	jp EnableAutoTextBoxDrawing

Route12Gate1F_TextPointers:
	def_text_pointers
	dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD
	dw_const Route12Gate1FPokeballText, TEXT_ROUTE12_GATE1F_POKEMON_POKEBALL

Route12Gate1FGuardText:
	jr nz, .heal
	text_far _Route12Gate1FGuardText
	text_end
	jp TextScriptEnd
.heal
	call RedsHouse1FMomHealScript2

RedsHouse1FMomHealScript2:
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite

Route12Gate1FPokeballText:
	text_asm
	CheckEvent EVENT_GOT_ROUTE12_POKEMON  ; Verificar si ya se recogió el Pokémon
	jr nz, .already_got_it                 ; Si ya lo tiene, salir

	lb bc, GYARADOS, 15
	call GivePokemon
	jr nc, .party_full  ; Si el equipo está lleno, mostrar mensaje

	; Marcar el evento como completado
	SetEvent EVENT_GOT_ROUTE12_POKEMON  

	; Ocultar la Poké Ball del mapa
	ld a, HS_ROUTE12_GATE1F_POKEMON_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject
	
.party_full
	jp TextScriptEnd

.already_got_it
	text "The POKÉBALL is empty."
	jp TextScriptEnd  ; Si ya se recogió, no hacer nada
