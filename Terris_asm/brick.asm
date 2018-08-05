.686
.model	flat
option casemap :none 

include defines.inc
include brick.inc
include map.inc


.const
g_iBrickPool DD  0f0000000H  ;I
	DD	080808080H
	DD	0f0000000H
	DD	080808080H
	DD	0e0400000H	;T
	DD	040c04000H
	DD	040e00000H
	DD	040604000H
	DD	040406000H	;L
	DD	000e08000H
	DD	060202000H
	DD	00020e000H
	DD	04040c000H	;J
	DD	080e00000H
	DD	060404000H
	DD	000e02000H
	DD	0c0600000H	;Z
	DD	040c08000H
	DD	0c0600000H
	DD	040c08000H
	DD	060c00000H	;S
	DD	080c04000H
	DD	060c00000H
	DD	080c04000H
	DD	0c0c00000H	;O
	DD	0c0c00000H
	DD	0c0c00000H
	DD	0c0c00000H

.code
;int Brick::operator[](size_t index) const
OperatorAt@Brick proc stdcall index:dword
	;ecx = this
	mov eax, index
	mov eax, [ecx + eax * 4]

	ret
OperatorAt@Brick endp

;Brick& operator=(const Brick& other)
OperatorEqual@Brick proc stdcall uses esi other:dword
	;ecx = this
	mov edx, other
	;m_data[0] = other.m_data[0];
	mov eax, [edx + offset Brick.m_data]
	mov [ecx + offset Brick.m_data], eax
	;m_data[1] = other.m_data[1];
	mov eax, [edx + offset Brick.m_data + 4]
	mov [ecx + offset Brick.m_data + 4], eax
	;m_data[2] = other.m_data[2];
	mov eax, [edx + offset Brick.m_data + 8]
	mov [ecx + offset Brick.m_data + 8], eax
	;m_data[3] = other.m_data[3];
	mov eax, [edx + offset Brick.m_data + 12]
	mov [ecx + offset Brick.m_data + 12], eax	
	;m_type = other.m_type;
	mov eax, [edx + offset Brick.m_type]
	mov [ecx + offset Brick.m_type], eax
	;m_rotate = other.m_rotate;
	mov eax, [edx + offset Brick.m_rotate]
	mov [ecx + offset Brick.m_rotate], eax
	;m_axisRow = other.m_axisRow;
	mov eax, [edx + offset Brick.m_axisRow]
	mov [ecx + offset Brick.m_axisRow], eax
	;m_axisCol =  other.m_axisCol;
	mov eax, [edx + offset Brick.m_axisCol]
	mov [ecx + offset Brick.m_axisCol], eax
	;return *this;
	mov eax, ecx

	ret
OperatorEqual@Brick endp

;Brick::Brick(const Map & map)
Brick@Brick proc stdcall uses ebx map:dword
	;ebx = this
	mov ebx, ecx
	; : m_map(map)
	mov eax, map
	mov [ebx + offset Brick.m_map], eax
	;m_type = (rand() % BRICK_TYPES_NUM);
	call dword ptr rand
	cdq
	mov ecx, BRICK_TYPES_NUM
	idiv ecx
	mov [ebx + offset Brick.m_type], edx
	;m_rotate = rand() % 4;
	call dword ptr rand
	and eax, 3
	mov [ebx + offset Brick.m_rotate], eax
	;m_data[0] = g_iBrickPool[m_type][m_rotate] >> 24 & 0x000000FF;
	mov edx, dword ptr [ebx + offset Brick.m_type] 
	mov eax, dword ptr [ebx + offset Brick.m_rotate]
	lea edx, [eax + edx * 4]
	movzx eax, byte ptr g_iBrickPool[edx * 4 + 3]
	mov [ebx + offset Brick.m_data], eax
	;m_data[1] = g_iBrickPool[m_type][m_rotate] >> 16 & 0x000000FF;
	movzx eax, byte ptr g_iBrickPool[edx * 4 + 2]
	mov [ebx + offset Brick.m_data + 4], eax
	;m_data[2] = g_iBrickPool[m_type][m_rotate] >> 8 & 0x000000FF;
	movzx eax, byte ptr g_iBrickPool[edx * 4 + 1]
	mov [ebx + offset Brick.m_data + 8], eax
	;m_data[3] = g_iBrickPool[m_type][m_rotate] & 0x000000FF;
	movzx eax, byte ptr g_iBrickPool[edx * 4]
	mov [ebx + offset Brick.m_data + 12], eax
	;m_axisRow = 0;
	mov [ebx + offset Brick.m_axisRow], 0
	;m_axisCol = GAME_COL / 2;
	mov [ebx + offset Brick.m_axisCol], GAME_COL / 2

	mov eax, ebx
	ret
Brick@Brick endp

;Brick::~Brick()
Brick0@Brick proc stdcall 
	ret 
Brick0@Brick endp

;int Brick::getAxisRow() const
GetAxisRow@Brick proc stdcall 
	;ecx = this
	mov eax, [ecx + offset Brick.m_axisRow]
	ret
GetAxisRow@Brick endp 

;int Brick::getAxisCol() const
GetAxisCol@Brick proc stdcall 
	;ecx = this
	mov eax, [ecx + offset Brick.m_axisCol]
	ret
GetAxisCol@Brick endp 

;int Brick::TryRotate()
TryRotate@Brick proc stdcall uses esi edi ebx
	local tmpBrick : Brick 
	;ebx = this
	mov ebx, ecx

	;Brick tmpBrick(*this);
	mov esi, ebx
	lea edi, [tmpBrick]
	mov ecx, sizeof Brick / 4
	rep movsd
	;m_rotate = (m_rotate + 1) % 4;
	mov edx, [ebx + offset Brick.m_rotate]
	inc edx
	and edx, 3
	mov [ebx + offset Brick.m_rotate], edx
	;m_data[0] = g_iBrickPool[m_type][m_rotate] >> 24 & 0x000000FF;
	mov ecx, [ebx + offset Brick.m_type]
	lea ecx, [ecx * 4 + edx]
	movzx eax, byte ptr g_iBrickPool[ecx * 4 + 3]
	mov [ebx + offset Brick.m_data], eax
	;m_data[1] = g_iBrickPool[m_type][m_rotate] >> 16 & 0x000000FF;
	movzx eax, byte ptr g_iBrickPool[ecx * 4 + 2]
	mov [ebx + offset Brick.m_data + 4], eax
	;m_data[2] = g_iBrickPool[m_type][m_rotate] >> 8 & 0x000000FF;
	movzx eax, byte ptr g_iBrickPool[ecx * 4 + 1]
	mov [ebx + offset Brick.m_data + 8], eax
	;m_data[3] = g_iBrickPool[m_type][m_rotate] & 0x000000FF;
	movzx eax, byte ptr g_iBrickPool[ecx * 4]
	mov [ebx + offset Brick.m_data + 12], eax

	;for (i = 0; i < 4; i++)
	xor esi, esi
LoopBegin:
	;if (m_map.getRow(m_axisRow + i)
			;& (m_data[i] << (24 - m_axisCol)))
	mov eax, [ebx + offset Brick.m_axisRow]
	mov ecx, [ebx + offset Brick.m_map]
	add eax, esi
	push eax
	call GetRow@Map
	mov ecx, 24
	sub ecx, [ebx + offset Brick.m_axisCol]
	mov edx, [ebx + offset Brick.m_data]
	shl edx, cl
	test eax, edx
	jne CanRotate
	;compare
	inc esi
	cmp esi, 4
	jl LoopBegin

	;return 0
	xor eax, eax
	ret

CanRotate:
	;*this = tmpBrick;
	lea eax, [tmpBrick]
	push eax
	mov ecx, ebx
	call OperatorEqual@Brick
	;return 1;
	mov eax, 1
	ret
TryRotate@Brick endp

;int Brick::TryMove(int x, int y)
TryMove@Brick proc stdcall uses ebx esi edi x:dword, y:dword
	local tmpBrick : Brick 
	;ebx = this
	mov ebx, ecx

	;Brick tmpBrick(*this);
	mov esi, ebx
	lea edi, [tmpBrick]
	mov ecx, sizeof Brick / 4
	rep movsd
	;m_axisCol += x;
	mov eax, x
	add [ebx + offset Brick.m_axisCol], eax
	;m_axisRow += y;
	mov eax, y
	add [ebx + offset Brick.m_axisRow], eax

	;for (i = 0; i < 4; i++)
	xor esi, esi
LoopBegin:
	;if (m_map.getRow(m_axisRow + i)
			;& (m_data[i] << (24 - m_axisCol)))
	mov eax, [ebx + offset Brick.m_axisRow]
	mov ecx, [ebx + offset Brick.m_map]
	add eax, esi
	push eax
	call GetRow@Map
	mov ecx, 24
	sub ecx, [ebx + offset Brick.m_axisCol]
	mov edx, [ebx + offset Brick.m_data]
	shl edx, cl
	test eax, edx
	jne CanMove
	;compare
	inc esi
	cmp esi, 4
	jl LoopBegin

	;return 0
	xor eax, eax
	ret

CanMove:
	;*this = tmpBrick;
	lea eax, [tmpBrick]
	push eax
	mov ecx, ebx
	call OperatorEqual@Brick
	;return 1;
	mov eax, 1
	ret
TryMove@Brick endp

new@Brick proc stdcall uses ebx map:dword
	push sizeof Brick
	call dword ptr malloc
	mov ebx, eax
	add esp, 4
	mov ecx, eax
	push map
	call Brick@Brick
	mov eax, ebx
	ret
new@Brick endp

delete@Brick proc stdcall pThis:dword
	mov ecx, pThis
	call Brick0@Brick
	push pThis
	call dword ptr free
	add esp, 4
	ret
delete@Brick endp
END