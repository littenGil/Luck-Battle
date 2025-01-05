.model small
.stack 100h

.data
    txt_title db " == LUCK BATTLE ==$"
    txt_Encounter db "  You encountered a monster! $"
    txt_Attack db "  You attacked the monster! $"
    txt_Run db "  You ran away from the monster! $"
    txt_MonsterAttack db "  The monster attacked you! $"
    txt_MonsterDead db "  The monster is dead! $"
    txt_PlayerDead db "  You are dead! $"
    txt_YouWin db "  You win! $"
    txt_YouLose db "  You lose! $"
    txt_Draw db "  It's a draw! $"
    txt_InvalidInput db "  Invalid input! $"
    txt_Thanks db "  Thanks for playing :) $"
    txt_Continue db "  (Press any key to go to continue) $"

    int_playerHealth db 0
    int_monsterHealth db 0  

    util_Input db 0 ; Input from user
    util_ComputerNum db 0 ; Random number from 1 to 3
    util_PlayerNum db 0 ; Player's choice
    util_Newline db 0Ah, 0Dh, '$'
    

    ch_fight db "  [1] Fight $"
    ch_run db "  [2] Run $"
    ch_play db "  [1] Play $"
    ch_quit db "  [2] Quit $"
    ch_choose db "  Choose: $"
    playerHealth db "  Player Health: $"
    monsterHealth db "  Monster Health: $"

    

.code
main:
    mov ax, @data
    mov ds, ax


home:
   call clrScr
   call newLine
   lea dx, txt_title
   call printLine
   call newLine
   lea dx, ch_play
   call printLine
   lea dx, ch_quit
   call printLine
   call newLine
   lea dx, ch_choose
   call print
   call scan
   cmp al, 1
   jne quit 
   call play


quit:
   cmp al, 2 
   jne invalidHome
   call clrscr
   call newLine
   lea dx, txt_Thanks 
   call printLine 
   call close

invalidHome:
lea dx, txt_InvalidInput
call printLine
call scan
call home 

play:
    call clrScr
    call newLine
    lea dx, txt_Encounter
    call printLine
    call newLine
    mov int_playerHealth, 5
    mov int_monsterHealth, 5

  playloop:
    call printPlayerHealth
    call printMonsterHealth
    call newLine

    lea dx, ch_fight
    call printLine
    lea dx, ch_run
    call printLine
    call newLine
    lea dx, ch_choose
    call print
    call scan
    cmp al, 1
    jne run
    call clrscr
    call newLine

;BATTLE DECISSION
    mov ah, 0
    int 1ah
    mov ax,dx
    mov dx,0
    mov bx,2
    div bx
    mov util_ComputerNum, dl
    cmp dl, 1
    jne monsterAttack
    lea dx, txt_Attack
    call printLine
    sub int_monsterHealth, 1
    call scan
    cmp int_monsterHealth, 0
    jg playloop
    call clrScr
    call newline
    lea dx, txt_MonsterDead
    call printLine
    lea dx, txt_YouWin 
    call printLine
    lea dx, txt_Continue
    call printLine
    call scan
    call home

run:
    cmp al, 2
    jne invalidPlay
    call clrScr
    call newLine
    lea dx, txt_Run
    call printLine
    lea dx, txt_Continue
    call printLine
    call scan
    call home

monsterAttack:
    lea dx, txt_MonsterAttack
    call printLine
    sub int_playerHealth, 1
    call scan
    cmp int_playerHealth, 0
    jg gotoplayloop
    call clrScr
    call newLine
    lea dx, txt_PlayerDead
    call printLine
    lea dx, txt_YouLose
    call printLine
    call newLine
    lea dx, txt_Continue
    call printLine
    call scan
    call home

gotoplayloop:
    call playloop


invalidPlay:
    lea dx, txt_InvalidInput
    call printLine
    call scan
    call clrscr
    call newLine
    call playloop

;FUNCTIONS
printPlayerHealth:
    lea dx, playerHealth
    call print
    mov al, int_playerHealth
    add al, "0"
    mov dl, al
    mov ah, 02h
    int 21h
    call newLine
    ret

printMonsterHealth:
    lea dx, monsterHealth
    call print
    mov al, int_monsterHealth
    add al, "0"
    mov dl, al
    mov ah, 02h
    int 21h
    call newLine
    ret

printLine:
    call print
    call newLine
    ret       

newLine:
    lea dx, util_Newline
    call print
    ret

print:
    mov ah, 09h
    int 21h
    ret

scan:
    mov ah, 08h
    int 21h    
    sub al,'0'
    ret       


clrScr:
    mov ah, 00h          
    mov al, 03h          
    int 10h
    ret

close:
    mov ah, 4Ch
    int 21h
end main