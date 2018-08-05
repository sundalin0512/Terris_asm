ifndef	DEFINES_INC
DEFINES_INC equ <1>

GAME_ROW		equ 24
GAME_COL		equ 12
BRICK_TYPES_NUM equ 7

includelib ucrt.lib
includelib legacy_stdio_definitions.lib

WNDCLASS struct 
    style			dd ?
    lpfnWndProc		dd ?
    cbClsExtra		dd ?
    cbWndExtra		dd ?
    hInstance		dd ?
    hIcon			dd ?
    hCursor			dd ?
    hbrBackground	dd ?
    lpszMenuName	dd ?
    lpszClassName	dd ?
WNDCLASS ends

EXTRN	__imp__rand:PROC
EXTRN	__imp__GetMessageW@16:PROC
EXTRN	__imp__DispatchMessageW@4:PROC
EXTRN	__imp__malloc:PROC
EXTRN	__imp__free:PROC
EXTRN	__imp___time64:PROC
EXTRN	__imp___itow:PROC
EXTRN	__imp__srand:PROC
EXTRN	__imp__PostMessageW@16:PROC
EXTRN	__imp__DefWindowProcW@16:PROC
EXTRN	__imp__PostQuitMessage@4:PROC
EXTRN	__imp__RegisterClassW@4:PROC
EXTRN	__imp__CreateWindowExW@48:PROC
EXTRN	__imp__ShowWindow@8:PROC
EXTRN	__imp__SetTimer@16:PROC
EXTRN	__imp__KillTimer@8:PROC
EXTRN	__imp__DrawTextW@20:PROC
EXTRN	__imp__UpdateWindow@4:PROC
EXTRN	__imp__GetDC@4:PROC
EXTRN	__imp__ReleaseDC@8:PROC
EXTRN	__imp__InvalidateRect@12:PROC
EXTRN	__imp__ValidateRect@8:PROC
EXTRN	__imp__LoadCursorW@8:PROC
EXTRN	__imp__LoadIconW@8:PROC
EXTRN	__imp__DrawIconEx@36:PROC
EXTRN	_wcscat:PROC
EXTRN	__imp__GetModuleHandleW@4:PROC
rand			equ __imp__rand
GetMessage		equ __imp__GetMessageW@16
DispatchMessage equ __imp__DispatchMessageW@4
malloc			equ __imp__malloc
free			equ __imp__free
time			equ __imp___time64
itow			equ __imp___itow
srand			equ __imp__srand
PostMessage		equ __imp__PostMessageW@16
DefWindowProc	equ	__imp__DefWindowProcW@16
PostQuitMessage	equ	__imp__PostQuitMessage@4
RegisterClass	equ	__imp__RegisterClassW@4
CreateWindowEx	equ	__imp__CreateWindowExW@48
ShowWindow		equ	__imp__ShowWindow@8
SetTimer		equ	__imp__SetTimer@16
KillTimer		equ	__imp__KillTimer@8
DrawText		equ	__imp__DrawTextW@20
UpdateWindow	equ	__imp__UpdateWindow@4
GetDC			equ	__imp__GetDC@4
ReleaseDC		equ	__imp__ReleaseDC@8
InvalidateRect	equ	__imp__InvalidateRect@12
ValidateRect	equ	__imp__ValidateRect@8
LoadCursor		equ	__imp__LoadCursorW@8
LoadIcon		equ	__imp__LoadIconW@8
DrawIconEx		equ	__imp__DrawIconEx@36
wcscat			equ _wcscat
GetModuleHandle	equ __imp__GetModuleHandleW@4

IDI_ICON1            equ           102
IDI_ICON2            equ           103
IDR_MENU1            equ           104
ID_EASYLEVEL         equ           40007
ID_NORMALLEVEL       equ           40008
ID_HARDLEVEL         equ           40009
WM_USER				 equ		   400h
ELSE
echo -----------------------------------------
echo WARNING Duplicate include defines.inc
echo -----------------------------------------
ENDIF