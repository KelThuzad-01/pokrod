InitPlayerData:
InitPlayerData2:

	call Random
	ldh a, [hRandomSub]
	ld [wPlayerID], a

	call Random
	ldh a, [hRandomAdd]
	ld [wPlayerID + 1], a

	ld a, $ff
	ld [wUnusedPlayerDataByte], a

	ld hl, wPartyCount
	call InitializeEmptyList
	ld hl, wBoxCount
	call InitializeEmptyList
	ld hl, wNumBagItems
	call InitializeEmptyList
	call InitPlayerBag ; Call new function bag to give items
	ld hl, wNumBoxItems
	call InitializeEmptyList
  	
DEF START_MONEY EQU $5
	ld hl, wPlayerMoney + 1
	ld a, HIGH(START_MONEY)
	ld [hld], a
	xor a ; LOW(START_MONEY)
	ld [hli], a
	inc hl
	ld [hl], a

	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hli], a
	ASSERT wObtainedBadges + 1 == wUnusedObtainedBadges
	ld [hl], a

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wGameProgressFlagsEnd - wGameProgressFlags
	call FillMemory ; clear all game progress flags

	jp InitializeMissableObjectsFlags

InitializeEmptyList:
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret

InitPlayerBag:
    ld hl, wNumBagItems   ; Apunta al número de objetos en la mochila
    ld [hl], 2            ; Número de objetos iniciales (ajústalo si agregas más)

    ld hl, wBagItems
    ld [hl], OLD_ROD      ; Primer objeto
    inc hl
    ld [hl], 1            ; Cantidad: 1
    inc hl

    ld [hl], POKE_BALL    ; Segundo objeto: Poké Ball
    inc hl
    ld [hl], 99           ; Cantidad: 99
    inc hl

    ld [hl], $FF          ; Terminador de lista de objetos (obligatorio)
        ld a, [wPartyCount]   ; Cargar el número de Pokémon en el equipo
    cp 6                  ; ¿El equipo está lleno?
    jp nc, .ToBox         ; Si está lleno, enviarlo a la caja

    ; Obtener la posición del siguiente Pokémon en el equipo
    ld hl, wPartySpecies  ; Dirección base de la lista de especies en el equipo
    ld b, 0
    ld c, a
    add hl, bc            ; Moverse a la última posición disponible
    ld [hl], MAGIKARP     ; ID de Magikarp

    ; Establecer nivel
    ld hl, wPartyMon1Level
    ld b, 0
    ld c, a
    add hl, bc
    ld [hl], 5            ; Nivel 5

    ; Inicializar HP y estadísticas base
    call InitializeNewPokemonStats

    ; Aumentar el contador de Pokémon en el equipo
    ld hl, wPartyCount
    inc [hl]
    ret

.ToBox:
    ; Si el equipo está lleno, en esta versión simplemente lo ignoramos por ahora
    ret

; --------------------------------------
; Inicializa los datos del Pokémon correctamente
; --------------------------------------
InitializeNewPokemonStats:
    ld hl, wPartyMon1HP
    xor a
    ld [hl], a
    inc hl
    ld [hl], a

    ; Inicializar HP y estadísticas completas
    ld hl, wPartyMon1Stats
    ld bc, 10
    call FillMemoryWithZero

    ; Inicializar Ataques (usar ataques predeterminados de Magikarp)
    ld hl, wPartyMon1Moves
    ld [hl], SPLASH  ; Magikarp solo conoce Salpicadura al inicio
    inc hl
    ld [hl], $FF     ; Termina la lista de movimientos

    ret

; --------------------------------------
; Llena un área de memoria con ceros
; --------------------------------------
FillMemoryWithZero:
    xor a
.loop
    ld [hl], a
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .loop
    ret
