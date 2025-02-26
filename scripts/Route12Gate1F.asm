Route12Gate1F_TextPointers:
    def_text_pointers
    dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1F_Script:
    ld a, [wStatusFlags4]   ; Cargar el estado del evento
    bit BIT_GOT_LAPRAS, a   ; ¿Ya recibió Lapras?
    ret nz                  ; Si ya lo tiene, salir sin hacer nada.

    ; Dar Lapras sin mostrar diálogos ni pedir mote
    ld a, LAPRAS            ; ID de Lapras
    ld b, 15                ; Nivel 15
    call GivePokemonSilent  ; Llamamos a la función sin diálogos

    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl] ; Marcar que ya se entregó

    ret ; Salir sin mostrar texto ni interrupciones

; -------------------------------------------
; Función para dar un Pokémon sin diálogo ni motes
; -------------------------------------------
GivePokemonSilent:
    push af
    push hl
    push de
    push bc

    ; Obtener la cantidad de Pokémon en el equipo
    ld hl, wPartyCount
    ld a, [hl]
    cp 6
    jr nc, .no_space   ; Si el equipo está lleno, salir

    inc [hl]           ; Aumentar la cantidad de Pokémon en el equipo

    ; Calcular la posición del nuevo Pokémon en wPartyMons
    ld c, a
    dec c              ; Ajustar índice (0-based)
    ld b, 0
    ld hl, wPartyMon1Species
    call AddBCtoHL
    ld [hl], a         ; Guardar la especie del Pokémon

    ; Asignar nivel
    ld hl, wPartyMon1Level
    call AddBCtoHL
    ld [hl], b         ; Guardar el nivel

    ; Asignar ID del Entrenador Original (OT ID)
    ld hl, wPartyMon1ID
    call AddBCtoHL
    ld de, wPlayerID
    ld a, [de]
    ld [hl], a
    inc hl
    inc de
    ld a, [de]
    ld [hl], a

    ; Asignar nombre del OT (jugador)
    ld hl, wPartyMonOT
    call AddBCtoHL
    ld de, wPlayerName  ; Copiar el nombre del jugador como OT
    ld bc, NAME_LENGTH
    call CopyData

    pop bc
    pop de
    pop hl
    pop af
    ret

.no_space:
    pop bc
    pop de
    pop hl
    pop af
    ret

; -------------------------------------------
; Función auxiliar: HL += BC (desplazamiento)
; -------------------------------------------
AddBCtoHL:
    push de
    push af
    ld d, h
    ld e, l
    add hl, bc
    pop af
    pop de
    ret


Route12Gate1FGuardText:
    text "¡Bienvenido!"
    line "¡Disfruta tu aventura!"
    done

