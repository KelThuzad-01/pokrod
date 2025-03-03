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
	call ChooseRandomGiftPokemon   ; Selecciona un Pokémon aleatorio

	ld b, a
	ld c, 15
	call GivePokemon
	jr nc, .party_full  ; Si el equipo está lleno, mostrar mensaje

	; Marcar el evento como completado
	SetEvent EVENT_GOT_ROUTE12_POKEMON  

	; Ocultar la Poké Ball del mapa
	ld a, HS_ROUTE12_GATE1F_POKEMON_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject

; ---------------------------------
; Función para seleccionar un Pokémon aleatorio
; ---------------------------------
ChooseRandomGiftPokemon:
    call Random
    and %00001111     ; Genera un número entre 0 y 31 (ajustaremos si hay 25 Pokémon)

    cp 15             ; Si el número es mayor o igual a 15, recalcular
    jr nc, ChooseRandomGiftPokemon  

    ld hl, GiftPokemonTable ; Cargar la tabla de Pokémon posibles
    ld d, 0
    ld e, a
    add hl, de
    ld a, [hl]         ; Cargar el Pokémon seleccionado en A
    ret

; ---------------------------------
; Lista de Pokémon aleatorios para recibir
; ---------------------------------
GiftPokemonTable:
    db WARTORTLE
    db GOLDUCK
    db POLIWHIRL
    db TENTACRUEL
    db SLOWBRO
    db DEWGONG
    db CLOYSTER
    db KINGLER
    db SEADRA
    db SEAKING
    db GYARADOS
    db LAPRAS
    db VAPOREON
    db OMASTAR
    db KABUTOPS
	
.party_full
	jp TextScriptEnd

.already_got_it
	jp TextScriptEnd  ; Si ya se recogió, no hacer nada
