;registers definition
;system regs
OPCN	equ	0fffeh
OPSEL	equ	0fffdh
OPHA	equ	0fffch
DULA	equ	0fffbh
IULA	equ	0fffah
TULA	equ	0fff9h
SULA	equ	0fff8h
WCY2	equ	0fff6h
WCY1	equ	0fff5h
WMB	equ	0fff4h
RFC	equ	0fff2h
TCKS	equ	0fff0h

;peripheral regs
IRQ	equ	104h
IIW1	equ	104h
IPFW	equ	104h
IMDW	equ	104h
IMKW	equ	105h
IIW2	equ	105h
IIW3	equ	105h
IIW4	equ	105h


TCT0	equ	114h
TCT1	equ	115h
TCT2	equ	116h
TMD	equ	117h

SRB	equ	124h
STB	equ	124h
SST	equ	125h
SCM	equ	125h
SMD	equ	126h
SIMK	equ	127h

DICM	equ	130h
DCH	equ	131h
DBCL	equ	132h
DBCH	equ	133h
DBAL	equ	134h
DBAH	equ	135h
DBAU	equ	136h
DDCL	equ	138h
DDCH	equ	139h
DMD	equ	13ah
DST	equ	13bh
DMK	equ	13ch


;constants
DIV16_96		equ 	12; clock 7.3728MHz, clock prescale 4, 16 clocks per bit, 9600bps
TSTPTN equ 0a5h


	org 0h

;entry point (0f000h:0000h)

ENTRY:


;init peripheral
	mov dx,OPCN
	mov al,00001111b	;intl1=scu,intl2=tct1
	out dx,al

	mov dx,OPSEL
	mov al,00001111b	;scu,tcu,icu,dmau enable
	out dx,al

	mov dx,OPHA
	mov al,1h	;internal periph.high addr=1h(0100h)
	out dx,al

	mov dx,DULA
	mov al,30h	;dmau low address=3xh(013xh)
	out dx,al

	mov dx,IULA
	mov al,04h	;icu low address=04h(0104h-0107h)
	out dx,al

	mov dx,TULA
	mov al,14h	;tcu low address=14h(0114h-0117h)
	out dx,al

	mov dx,SULA
	mov al,24h	;scu low address=24h(0124h-0127h)
	out dx,al

	mov dx,WMB
	mov al,73h	;lmb=lower512kb,umb=highest 128kb
	out dx,al

	mov dx,WCY1
	mov al,11000101b	;io 3waits,um 0waits,mm,lm 0waits
	out dx,al

	mov dx,WCY2
	mov al,00001001b	;dma 2waits, refresh 0waits
	out dx,al

	mov dx,RFC
	mov al,00001011b	;disable refresh, timer factor 11
	out dx,al

	mov dx,TCKS
	mov al,00000001b	;all timers internal clock prescale by 4
	out dx,al

;set peripherals registers

;
	mov dx,TMD
	mov al,00110110b	;set tct0 in mode 3
	out dx,al
	mov dx,TCT0
	mov al,00
	out dx,al
	mov al,0f0h
	out dx,al

	mov dx,TMD
	mov al,01110110b	;set tct1 in mode 3
	out dx,al
	mov dx,TCT1
	mov al,DIV16_96	;9600bpsx16
	out dx,al
	mov al,00h
	out dx,al

	mov dx,TMD
	mov al,10110110b	;set tct2 in mode 3
	out dx,al
	mov dx,TCT2
	mov al,33h	;freq. ca. 1kHz
	out dx,al
	mov al,07h
	out dx,al

;set scu
	mov dx,SMD
	mov al,01001110b	;stop:1,parity:n,data:8,clk:1/16
	out dx,al

	mov dx,SCM
	mov al,00110101b	
;SRDY,clear error flag, txd, reception enable, transmission enable
	out dx,al

	mov dx,SIMK
	mov al,00000010b	;tbrdy:masked,rbrdy:not masked
	out dx,al

	mov dx,IIW1
	mov al,00010010b	;edge trigger, single, no iiw4write
	out dx,al

	mov dx,IIW2
	mov al,00000000b	;int vector set to 0
	out dx,al

	mov dx,IIW3
	mov al,00000000b	;none slave input
	out dx,al

	mov dx,IIW4
	mov al,00000011b	;self f1 mode
	out dx,al

	mov dx,IMKW
	mov al,11111111b	;all ints are masked
	out dx,al

	mov dx,IPFW
	mov al,00000000b	;
	out dx,al

	mov dx,IMDW
	mov al,00001000b	;nop
	out dx,al

	mov dx,DICM
	mov al,00000000b	;dma0 reset
	out dx,al

	mov dx,DCH
	mov al,00000000b	;dma1 reset
	out dx,al

	mov dx,DBCL
	mov al,00000000b	;dma2 reset
	out dx,al

	mov dx,DBCH
	mov al,00000000b	;dma3 reset
	out dx,al

	mov dx,DBAL
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DBAH
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DBAU
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DDCL
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DDCH
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DMD
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DST
	mov al,00000000b	;dma reset
	out dx,al

	mov dx,DMK
	mov al,00000000b	;dma reset
	out dx,al


;start
	mov dx,0200h
	mov al,0
	out dx,al		;turn off leds

	
	mov dx,TMD
	mov al,10110110b	;set tct2 in mode 3
	out dx,al
	mov dx,TCT2
	mov al,43h	;freq. ca. 1kHz
	out dx,al
	mov al,07h
	out dx,al
	
	mov cx,0C000h
SLOOP1:
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	loop SLOOP1

	
	mov dx,TMD
	mov al,10110000b	;set tct2 in mode 0
	out dx,al
	mov dx,TCT2
	mov al,2eh	;freq. ca. 1kHz
	out dx,al
	mov al,07h
	out dx,al

	

;initialize dram
;enable refresh
	mov dx,RFC
	mov al,10001011b	;enable refresh, timer factor 12
	out dx,al
	mov cx,54000
SLOOP2:
	nop
	nop
	nop

	loop SLOOP2



	mov dx,TMD
	mov al,10110110b	;set tct2 in mode 3
	out dx,al
	mov dx,TCT2
	mov al,0cch	;freq. ca. 250Hz
	out dx,al
	mov al,1ch
	out dx,al

;check ram

;check ram address ds:bx 
	mov cx,0 
	mov bx,0
	mov ax,0
	mov ds,ax
MEMCHECK:

;attempt to write data at ds:bx
	mov byte ptr[bx],TSTPTN
	nop
	nop
	nop
	nop
;read and compare data at [ds:bx]
;	mov dx,0
;;	mov cl, byte ptr[bx]
;	mov ch,cl
;	and ch,0f0h
;	shr ch,1
;	shr ch,1
;	shr ch,1
;	shr ch,1
;	and cl,00fh
;	mov di,bx
;	mov ax,ds
;	mov es,ax
;	mov ax,cs
;	mov ds,ax
;
;WAITRDH1:
;	mov dx,SST
;	in al,dx
;	test al,00000001b
;	jz WAITRDH1
;	
;TRNSMIH1:
;	mov bx,0
;	mov bl,ch
;	mov al,byte ptr[bx+1000h]
;	mov dx,STB
;	out dx,al
;
;WAITRDL1:
;	mov dx,SST
;	in al,dx
;	test al,00000001b
;	jz WAITRDL1
;	
;TRNSMIL1:
;	mov bx,0
;	mov bl,cl
;	mov al,byte ptr[bx+1000h]
;	mov dx,STB
;	out dx,al
;	mov ax,es
;	mov ds,ax
;	mov bx,di
;	mov cx,0
	nop
	nop
	nop
;if it failes exit count
	cmp byte ptr[bx],TSTPTN
	jnz EXITMCHK
;if it succeds increment offset
	inc bx
	jnz MEMCHECK
;if it reaches segment boundary increment segment by 4096 (next 64kib)
	mov ax,ds
	add ax, 1000h
;if it reaches the address ceiling (1mib) stop count memory
	jz MEMCHK2
 	mov ds,ax
	jmp MEMCHECK
MEMCHK2:
	mov ds,ax
	mov cx,1  ;extra digit cx:ds:bx=1:0000:0000
;back to the beginning of the loop

	
EXITMCHK:
;check no-RAM
	cmp cx,0
	jnz RAMSIZE
;if cx is non-zero, there is full range of ram
	mov ax,ds
;if ds is non-zero, there is some amount of ram greater than 64kib
	cmp ax,0
	jnz RAMSIZE
	cmp bx,0
;if bx is non-zero, there is some amount of ram less than 64kib
	jnz RAMSIZE
;no RAM, 
	mov dx,TCT2
	mov al,00h	;freq. ca. 60Hz
	out dx,al
	mov al,78h
	out dx,al

;do nothing more.
	hlt
	
RAMSIZE:
	;cx:high address, ds,data segment, bx:offset;
;store memory count at address from 0000h:0004h
	mov si,cx		;si:ds:bx=high:ds:bx
	mov cx,16	
	mov ax,ds
	mul cx	;(dx:ax)=16*ds
	add ax,bx	;(dx:ax)=16*ds+bx
	jnc RAMSIZE2
	inc dx
RAMSIZE2:
	mov di,dx		;(di:ax)=16*ds+bx
	mov bp,ax	;(di:bp)=16*ds+bx
	mov cx,si
	mov ax,16	;high address
	mul cx		;(dx:ax)=cx*16
	mov dx,di
	add dx,ax		;dx=dx+cx*16
	mov di,dx		;(di:bp)=1048576*cx+16*ds+bx
	
	
SVTOREG:
;save mem. cap. to registers unused in this prog.
	mov ax,0
	mov ds,ax
	mov ax,4
SVTOADDR:
	
;	mov word ptr[2],bp	 
	
;	mov word ptr[4],di

	mov ax,cs
	mov ds,ax

PRRAMCAP:
;indicate bu sound
	mov al,00h
	mov dx,TCT2
	out dx,al
	mov ax,di
	shr ax,1
	xor al,0fh
	add al,4h	; al=!es+1+3  4h-12h
	out dx,al

;print RAM count
	
	mov bx,di
	mov cl,12
	shr bx,cl
	and bx,000fh
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY
	
TRANSMIT:
	mov dx,STB
	mov al,bl
	out dx,al

	mov bx,di
	mov cl,8
	shr bx,cl
	and bx,000fh
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY2:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY2
	
TRNSMIT2:
	mov dx,STB
	mov al,bl
	out dx,al

	mov bx,di
	mov cl,4
	shr bx,cl
	and bx,000fh
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY3:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY3
	
TRNSMIT3:
	mov dx,STB
	mov al,bl
	out dx,al

	mov bx,di
	and bx,000fh
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY4:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY4
	
TRNSMIT4:
	mov dx,STB
	mov al,bl
	out dx,al

	mov bx,bp
	mov cl,12
	shr bx,cl
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY5:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY5
	
TRNSMIT5:
	mov dx,STB
	mov al,bl
	out dx,al

	mov bx,bp
	mov cl,8
	shr bx,cl
	and bx,000fh
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY6:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY6
	
TRNSMIT6:
	mov dx,STB
	mov al,bl
	out dx,al

	mov bx,bp
	mov cl,4
	shr bx,cl
	and bx,000fh
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY7:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY7
	
TRNSMIT7:
	mov dx,STB
	mov al,bl
	out dx,al

	mov bx,bp
	and bx,000fh
	mov al,byte ptr[bx+1000h]
	mov bx,ax

WAITRDY8:
	mov dx,SST
	in al,dx
	test al,00000001b
	jz WAITRDY8
	
TRNSMIT8:
	mov dx,STB
	mov al,bl
	out dx,al

	mov cx,60000
SLOOP3:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	loop SLOOP3

;indicate bu sound
	mov al,00h
	mov dx,TCT2
	out dx,al
	mov ax,di
	shr ax,1
	mov al,0
	out dx,al

;recheck ram address ds:bx 
	mov cx,0 
	mov bx,0
	mov ax,0
	mov ds,ax
MRECHECK:
	;mov byte ptr[bx],TSTPTN
;read and compare data at [ds:bx]
;	mov dx,0
;	mov cl, byte ptr[bx]
;	mov ch,cl
;	and ch,0f0h
;	shr ch,1
;	shr ch,1
;	shr ch,1
;	shr ch,1
;	and cl,00fh
;	mov di,bx
;	mov ax,ds
;	mov es,ax
;	mov ax,cs
;	mov ds,ax

;REWTRDYH:
;	mov dx,SST
;	in al,dx
;	test al,00000001b
;	jz REWTRDYH
	
;RETRMITH:
;	mov bx,0
;	mov bl,ch
;	mov al,byte ptr[bx+1000h]
;	mov dx,STB
;	out dx,al
;
;REWTRDYL:
;	mov dx,SST
;	in al,dx
;	test al,00000001b
;	jz REWTRDYL
;	
;RETRMITL:
;	mov bx,0
;	mov bl,cl
;	mov al,byte ptr[bx+1000h]
;	mov dx,STB
;	out dx,al
;	mov ax,es
;	mov ds,ax
;	mov bx,di
;	mov cx,0
;	nop
;	nop
;	nop
;if it failes exit count
	cmp byte ptr[bx],TSTPTN
	jnz EXITMCH2
;if it succeds increment offset
	inc bx
	jnz MRECHECK
;if it reaches segment boundary increment segment by 4096 (next 64kib)
	mov ax,ds
	add ax, 1000h
;if it reaches the address ceiling (1mib) stop count memory
	jz MEMCK2
 	mov ds,ax
	jmp MRECHECK
MEMCK2:
	mov ds,ax
	mov cx,1  ;extra digit cx:ds:bx=1:0000:0000

	hlt
EXITMCH2:
	jmp EXITMCHK


;
;putc (blocking, overwrites ax,dx) arguments: bx,
BPUTC:


	

;
	org 1000h
	db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
;
;
;


	org 0fff0h
;jump to the entry point after reset
	jmp 0f000h:0000h



	end