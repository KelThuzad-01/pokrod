Route12Gate1F_Script:
    call EnableAutoTextBoxDrawing
    call CheckPlayerPosition  ; Verificar si el jugador está en (6,5)
    ret

CheckPlayerPosition:
    ld a, [wXCoord]  ; Cargar coordenada X del jugador
    cp 6             ; Comparar con la posición X del guardia
    jr nz, .done     ; Si no está en X = 6, salir

    ld a, [wYCoord]  ; Cargar coordenada Y del jugador
    cp 5             ; Comparar con la posición Y debajo del guardia (ajustado)
    jr nz, .done     ; Si no está en Y = 5, salir

    ; Si el jugador está en (6,5), entregar Lapras
    ld a, [wStatusFlags4]   ; Cargar el estado del evento
    bit BIT_GOT_LAPRAS, a   ; ¿Ya recibió Lapras?
    jr nz, .done            ; Si sí, salir

    call GiveLapras
    ret

.done
    ret

Route12Gate1F_TextPointers:
    def_text_pointers
    dw_const Route12Gate1FGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12Gate1FGuardText:
    text_asm
    ld a, [wStatusFlags4]   ; Cargar el estado del evento
    bit BIT_GOT_LAPRAS, a   ; ¿Ya recibió Lapras?
    jr nz, .already_have_it ; Si ya lo tiene, mostrar mensaje alternativo

.give_lapras
    call GiveLapras
    jp TextScriptEnd

.already_have_it
    ld hl, AlreadyHaveLaprasText
    call PrintText
    jp TextScriptEnd

GiveLapras:
    ld hl, GiveLaprasText
    call PrintText          ; Mostrar el mensaje inicial

    lb bc, LAPRAS, 15       ; Especificar Lapras nivel 15
    call GivePokemon        ; Intentar dar el Pokémon
    jr nc, .storage_full    ; Si el equipo y cajas están llenos, avisar

    ld a, [wAddedToParty]   ; ¿Se agregó a la caja o al equipo?
    and a
    call z, WaitForTextScrollButtonPress
    call EnableAutoTextBoxDrawing

    ; Mostrar la pantalla de mote correctamente
    call DisplayNamingScreen

    ld hl, LaprasDescriptionText
    call PrintText          ; Mostrar información del Lapras

    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]  ; Marcar que ya se recibió Lapras
    ret

.storage_full
    ld hl, StorageFullText
    call PrintText
    ret

; Definimos los textos

GiveLaprasText:
    text "Toma este Lapras."
    line "Es muy inteligente."
    done

LaprasDescriptionText:
    text "Lapras es un gran"
    line "nadador. Cuidalo!"
    done

AlreadyHaveLaprasText:
    text "Espero que estes"
    line "cuidando a Lapras."
    done

StorageFullText:
    text "No tienes espacio"
    line "para Lapras."
    done
