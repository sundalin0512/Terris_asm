.686
.model	flat
option casemap :none 

include game.inc

public g_hIns


.data
g_hIns dd 0

.code 
winMain PROC stdcall uses ebx
	local msg[28]:byte

	mov ecx, offset game
	call Game@Game
	push 0
	call dword ptr GetModuleHandle
	;g_hIns = hInstance;
	mov dword ptr[g_hIns], eax
	;HRESULT hr;
	;hr = Game::Initialize(hInstance);
	push eax
	call Initialize@@Game
	;if (SUCCEEDED(hr))
	test eax, eax
	js EXIT
	;while (GetMessage(&msg, NULL, 0, 0))
MessageLoop:
	push 0
	push 0
	push 0
	lea eax, msg
	push eax
	call dword ptr GetMessage
	test eax, eax
	jz EXIT
	;DispatchMessage(&msg);
	lea eax, msg
	push eax
	call dword ptr DispatchMessage
	jmp MessageLoop

EXIT:
	xor eax, eax
	ret
winMain endp

END winMain