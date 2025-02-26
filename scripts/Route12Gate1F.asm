Route12Gate1F_TextPointers:
    def_text_pointers
    dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1F_Script:
    ; Verificar si ya se entregó Lapras
    ld a, [wStatusFlags4]
    bit BIT_GOT_LAPRAS, a
    ret nz  ; Si ya se entregó, no hacer nada

    ; Guardar configuración actual
    ld a, [wOptions]
    push af                 ; Guardamos la configuración original

    ; Desactivar la opción de mote
    res 6, a                ; Borra el bit que habilita la pregunta de mote
    ld [wOptions], a        ; Guardamos la configuración temporal

    ; Dar Lapras automáticamente
    lb bc, LAPRAS, 20       ; Especificar Lapras nivel 20
    call GivePokemon        ; Entregar el Pokémon

    ; Restaurar configuración original
    pop af
    ld [wOptions], a        ; Restauramos el estado anterior de las opciones

    ; Marcar Lapras como entregado
    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]

    ret

Route12Gate1FGuardText:
    text "¡Bienvenido!"
    line "¡Disfruta tu aventura!"
    done

