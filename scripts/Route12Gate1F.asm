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
    ld a, [wStatusFlags4]   ; Cargar el estado del evento
    bit BIT_GOT_LAPRAS, a   ; ¿Ya recibió Lapras?
    ret nz                  ; Si ya lo tiene, no hacer nada

    ; Simular diálogo con el guardia
    ld a, TEXT_ROUTE12GATE1F_GUARD
    ld [wCurNPCTextID], a
    call DisplayTextID  ; Mostrar el cuadro de texto como si habláramos con el guardia

    ; Dar Lapras nivel 15
    lb bc, LAPRAS, 15
    call GivePokemon
    jr nc, .storage_full    ; Si el equipo está lleno, mostrar aviso

    ; Mostrar la pantalla de mote
    call WaitForTextScrollButtonPress
    call EnableAutoTextBoxDrawing
    call DisplayNamingScreen  ; Mostrar la pantalla de nombre

    ; Mostrar el texto de descripción de Lapras
    ld hl, LaprasDescriptionText
    call PrintText

    ; Marcar Lapras como entregado
    ld hl, wStatusFlags4
    set BIT_GOT_LAPRAS, [hl]
    ret

.storage_full
    ld hl, StorageFullText
    call PrintText
    ret

LaprasDescriptionText:
    text "Lapras es un gran"
    line "nadador. ¡Cuídalo!"
    done

StorageFullText:
    text "No tienes espacio"
    line "para Lapras."
    done
