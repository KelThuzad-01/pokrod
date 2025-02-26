Route12Gate1F_TextPointers:
    def_text_pointers
    dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1F_Script:
    ; Verificar si ya se entregó Lapras
    ld a, [wStatusFlags4]
    bit BIT_GOT_LAPRAS, a
    ret nz  ; Si ya se entregó, no hacer nada

    ; Simular pulsación del botón B para cerrar el mote
    ld a, $02  ; Código del botón B
    ldh [hJoyHeld], a  ; Simula que el jugador presionó B

    ; Dar Lapras automáticamente
    lb bc, LAPRAS, 15   ; Especificar Lapras nivel 15
    call GivePokemon    ; Entregar el Pokémon

    ; Marcar Lapras como entregado
    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]

    ret


Route12Gate1FGuardText:
    text "¡Bienvenido!"
    line "¡Disfruta tu aventura!"
    done

