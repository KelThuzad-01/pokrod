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

    ; Configurar la información del Pokémon
    ld hl, wPartyCount
    ld a, [hl]
    cp 6
    jr nc, .no_space   ; Si el equipo está lleno, salir

    inc [hl]           ; Aumentar la cantidad de Pokémon en el equipo

    ; Apuntar al primer espacio libre en el equipo
    ld c, a
    ld b, 0
    ld hl, wPartyMon1Species
    add hl, bc
    ld [hl], a         ; Guardar el ID del Pokémon

    ; Asignar el nivel
    ld hl, wPartyMon1Level
    add hl, bc
    ld [hl], b         ; Guardar el nivel

    ; Configurar ID del Entrenador
    ld hl, wPartyMonOT
    add hl, bc
    ld de, wPlayerID
    ld a, [de]
    ld [hl], a
    inc hl
    inc de
    ld a, [de]
    ld [hl], a

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

Route12Gate1FGuardText:
    text "¡Bienvenido!"
    line "¡Disfruta tu aventura!"
    done

