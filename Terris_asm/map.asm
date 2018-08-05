.686
.model	flat
option casemap :none 

public g_iInitBackGround
include defines.inc
include map.inc

.const 
g_iInitBackGround DD 080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	080100000H
	DD	0fff00000H


.code 

;Map::Map()
Map@Map proc stdcall uses esi
	;ecx = this
	;for (int i = 0; i < GAME_ROW; i++)
	xor esi, esi
LoopBegin:
	;m_rows[i] = g_iInitBackGround[i];
	mov eax, g_iInitBackGround[esi * 4]
	mov [ecx + esi * 4], eax
	;compare
	inc esi
	cmp esi, GAME_ROW
	jl LoopBegin
	ret
Map@Map endp

;Map::~Map()
Map0@Map proc stdcall
	ret
Map0@Map endp

;void Map::reset()
Reset@Map proc stdcall uses esi
	;ecx = this
	;for (int i = 0; i < GAME_ROW; i++)
	xor esi, esi
LoopBegin:
	;m_rows[i] = g_iInitBackGround[i];
	mov eax, g_iInitBackGround[esi * 4]
	mov [ecx + esi * 4], eax
	;compare
	inc esi
	cmp esi, GAME_ROW
	jl LoopBegin
	ret
Reset@Map endp

;unsigned int Map::getRow(size_t index) const
GetRow@Map proc stdcall index:dword
	;ecx = this
	;return m_rows[index];
	mov eax, index
	mov eax, [ecx + eax * 4]
	ret
GetRow@Map endp

;void Map::changeRow(size_t index, int data)
ChangeRow@Map proc stdcall index:dword, data:dword
	;ecx = this
	;m_rows[index] = data;
	mov eax, data
	mov edx, index
	mov [ecx + edx * 4], eax
	ret
ChangeRow@Map endp

;int Map::TryDeleteLines()
TryDeleteLines@Map proc stdcall uses esi edi
	;ecx = this
	;edx = i
	;edi = count

	;int count = 0;
	xor edi, edi
	;for (i = GAME_ROW - 2; i > 0; i--)
	mov edx, GAME_ROW - 2 
LoopIBegin:
	;if (m_rows[i] == 0xFFF00000)
	cmp dword ptr[ecx + edx * 4], 0FFF00000H
	jne LoopICompare
	;for (j = i; j > 0; j--)
	mov eax, edx
	test eax, eax
	jle LoopJEnd
LoopJBegin:
	;	m_rows[j] = m_rows[j - 1];
	mov esi, [ecx + eax * 4 - 4]
	mov [ecx + eax * 4], esi
LoopJCompare:
	dec eax
	test eax, eax
	jg LoopJBegin
LoopJEnd:
	;m_rows[0] = g_iInitBackGround[0];
	mov eax, dword ptr ds:[g_iInitBackGround]
	mov [ecx], eax
	;i++;
	inc edx
	;count++;
	inc edi

LoopICompare:
	dec edx
	test edx, edx
	jg LoopIBegin

	mov eax, edi
	ret
TryDeleteLines@Map endp
END