.686
.model	flat
option casemap :none 

include game.inc
include brick.inc

extern g_hIns:dword
extern g_iInitBackGround:dword

.const 
g_clsName dw "T", "e", "t", "r", "i", "s", "-", "S", "D", "K", 0
g_szGrade db 06h, 52h, 70h, 65h, 1ah, 0ffh, 00h, 00h ;分数：
.data
game Game <>
g_redraw db 1
oldMap@WndProc db 60h dup (?)
first@WndProc db 1 dup (?)
WM_USER@WndProc@Game dd 0
.code
;Game::Game()
Game@Game proc stdcall uses ebx
	;ebx = this
	mov ebx, ecx
	;Map m_map;
	lea ecx, [ebx + offset Game.m_map]
	call Map@Map
	;Map m_drawMap;
	lea ecx, [ebx + offset Game.m_drawMap]
	call Map@Map
	;goal = 0;
	mov dword ptr [ebx + offset Game.goal], 0
	;m_redrawNext = true;
	mov byte ptr [ebx + offset Game.m_redrawNext], 1
	ret
Game@Game endp

;Game::~Game()
Game0@Game proc stdcall uses ebx
	mov ebx, ecx
	;Map m_map;
	lea ecx, [ebx + offset Game.m_map]
	call Map0@Map
	;Map m_drawMap;
	lea ecx, [ebx + offset Game.m_drawMap]
	call Map0@Map
	ret
Game0@Game endp

;void Game::start()
Start@Game proc stdcall
	;InitGame();
	call InitGame@Game
	ret
Start@Game endp

;void Game::restart()
Restart@Game proc stdcall uses ebx
	;ebx = this
	mov ebx, ecx
	;delete m_brick;
	mov eax, [ebx + offset Game.m_brick]
	push eax
	call delete@Brick
	;delete m_nextBrick;
	mov eax, [ebx + offset Game.m_nextBrick]
	push eax
	call delete@Brick
	;InitGame();
	mov ecx, ebx
	call InitGame@Game
	ret
Restart@Game endp

;void Game::InitGame()
InitGame@Game proc stdcall uses esi
	;esi = this
	mov esi, ecx
	;srand((unsigned)time(NULL));
	push 0
	call dword ptr time
	add esp, 4
	push eax
	call dword ptr srand
	add esp, 4
	;m_brick = new Brick(m_map);
	lea eax, [esi + offset Game.m_map]
	push eax
	call new@Brick
	mov [esi + offset Game.m_brick], eax
	;m_nextBrick = new Brick(m_map);
	lea eax, [esi + offset Game.m_map]
	push eax
	call new@Brick
	mov [esi + offset Game.m_nextBrick], eax
	;m_redrawNext = true;
	mov byte ptr [esi + offset Game.m_redrawNext], 1
	;goal = 0;
	mov dword ptr [esi + offset Game.goal], 0
	;m_map.reset();
	lea ecx, [esi + offset Game.m_map]
	call Reset@Map
	;UpdateScene();
	mov ecx, esi
	call UpdateScene@Game
	ret
InitGame@Game endp

;void Game::UpdateScene()
UpdateScene@Game proc stdcall uses ebx esi edi
	;ebx = this
	mov ebx, ecx
	;m_drawMap = m_map;
	lea esi, [ebx + offset Game.m_map]
	lea edi, [ebx + offset Game.m_drawMap]
	mov ecx, sizeof Map / 4
	rep movsd
	;for (i = 0; i < 4; i++)
	xor esi, esi
LoopBegin:
	;if (m_brick->getAxisRow() + i < GAME_ROW)
	mov ecx, [ebx + offset Game.m_brick]
	call GetAxisRow@Brick
	add eax, esi
	cmp eax, GAME_ROW
	jge LoopCompare
	;m_drawMap.changeRow(m_brick->getAxisRow() + i,
			;m_map.getRow(m_brick->getAxisRow() + i)
			;| ((*m_brick)[i] << (24 - m_brick->getAxisCol())));
	mov ecx, [ebx + offset Game.m_brick]
	call GetAxisRow@Brick
	add eax, esi
	push eax
	lea ecx, [ebx + offset Game.m_map]
	call GetRow@Map	
	mov edi, eax	;m_map.getRow(m_brick->getAxisRow() + i)
	mov ecx, [ebx + offset Game.m_brick]
	call GetAxisRow@Brick
	mov ecx, 24
	sub ecx, eax	;24 - m_brick->getAxisCol()
	mov ecx, [ebx + offset Game.m_brick]
	push esi
	call OperatorAt@Brick 
	shl eax, cl ;((*m_brick)[i] << (24 - m_brick->getAxisCol()))
	or eax, edi
	push eax	;arg2
	mov ecx, [ebx + offset Game.m_brick]
	call GetAxisRow@Brick
	add eax, esi
	push eax	;arg1
	lea ecx, [ebx + offset Game.m_drawMap]
	call ChangeRow@Map

LoopCompare:
	inc esi
	cmp esi, 4
	jl LoopBegin
	ret
UpdateScene@Game endp

;int Game::FixBrick()
FixBrick@Game proc stdcall uses ebx esi edi
	;ebx = this
	mov ebx, ecx
	;for (i = 0; i < 4; i++)
	xor esi, esi
LoopBegin:
	;m_map.changeRow(m_brick->getAxisRow() + i,
			;m_map.getRow(m_brick->getAxisRow() + i)
			;| ((*m_brick)[i] << (24 - m_brick->getAxisCol())));
	mov ecx, [ebx + offset Game.m_brick]
	call GetAxisRow@Brick
	add eax, esi
	push eax
	lea ecx, [ebx + offset Game.m_map]
	call GetRow@Map	
	mov edi, eax	;m_map.getRow(m_brick->getAxisRow() + i)
	mov ecx, [ebx + offset Game.m_brick]
	call GetAxisRow@Brick
	mov ecx, 24
	sub ecx, eax	;24 - m_brick->getAxisCol()
	mov ecx, [ebx + offset Game.m_brick]
	push esi
	call OperatorAt@Brick 
	shl eax, cl ;((*m_brick)[i] << (24 - m_brick->getAxisCol()))
	or eax, edi
	push eax	;arg2
	mov ecx, [ebx + offset Game.m_brick]
	call GetAxisRow@Brick
	add eax, esi
	push eax	;arg1
	lea ecx, [ebx + offset Game.m_map]
	call ChangeRow@Map

	;Compare
	inc esi
	cmp esi, 4
	jl LoopBegin
	;return m_map.TryDeleteLines();
	lea ecx, [ebx + offset Game.m_map]
	call TryDeleteLines@Map
	ret
FixBrick@Game endp 

;int Game::OnUp()
OnUp@Game proc stdcall 
	;m_brick->TryRotate();
	;return 0;
	mov ecx, [ecx + offset Game.m_brick]
	call TryRotate@Brick
	xor eax, eax
	ret
OnUp@Game endp

;int Game::OnDown()
OnDown@Game proc stdcall uses ebx
	;ebx = this
	mov ebx, ecx

	;if (m_brick->TryMove(0, 1))
	push 1
	push 0
	mov ecx, [ebx + offset Game.m_brick]
	call TryMove@Brick
	test eax, eax
	jz EXIT
	;	calculateGoal(FixBrick());
	mov ecx, ebx
	call FixBrick@Game
	push eax
	mov ecx, ebx
	call CalculateGoal@Game
	;	if (m_map.getRow(0) != g_iInitBackGround[0])
	push 0
	lea ecx, [ebx + offset Game.m_map]
	call GetRow@Map
	mov edx, dword ptr ds:[g_iInitBackGround]
	cmp eax, edx
	je Label1
	;		return -1;
	mov eax, -1
	ret
	Label1:
	;	delete m_brick;
	mov eax, [ebx + offset Game.m_brick]
	push eax
	call delete@Brick
	;	m_brick = m_nextBrick;
	mov eax, [ebx + offset Game.m_nextBrick]
	mov [ebx + offset Game.m_brick], eax
	;	m_nextBrick = new Brick(m_map);
	lea eax, [ebx + offset Game.m_map]
	push eax
	call new@Brick
	mov [ebx + offset Game.m_nextBrick], eax
	;	m_redrawNext = true;
	mov byte ptr[ebx + offset Game.m_redrawNext], 1
EXIT:
	;return 0;
	xor eax, eax
	ret
OnDown@Game endp

;int Game::OnLeft()
OnLeft@Game proc stdcall 
	; ecx = this
	;m_brick->TryMove(-1, 0);
	;return 0;
	mov ecx, [ecx + offset Game.m_brick]
	push 0
	push -1
	call TryMove@Brick
	xor eax, eax
	ret
OnLeft@Game endp

;int Game::OnRight()
OnRight@Game proc stdcall 
	; ecx = this
	;m_brick->TryMove(1, 0);
	;return 0;
	mov ecx, [ecx + offset Game.m_brick]
	push 0
	push 1
	call TryMove@Brick
	xor eax, eax
	ret
OnRight@Game endp

;void Game::calculateGoal(int lines)
CalculateGoal@Game proc stdcall lines:dword
	;ecx = this
	;switch (lines)
	mov eax, lines
	dec eax
	cmp eax, 3
	ja DEFAULT
	jmp CASE_TABLE[eax * 4]
CASE1:
	;goal += 1;
	inc [ecx + offset Game.goal]
CASE2:	
	;goal += 3;
	add [ecx + offset Game.goal], 3
CASE3:
	;goal += 6;
	add [ecx + offset Game.goal], 6
CASE4:
	;goal += 10;
	add [ECX + offset Game.goal], 10
DEFAULT:
	ret
CASE_TABLE:
	DD CASE1
	DD CASE2
	DD CASE3
	DD CASE4
CalculateGoal@Game endp

;HRESULT Game::Initialize(HINSTANCE hInstance)
Initialize@@Game proc stdcall uses ebx hInstance:dword
	local wcex:WNDCLASS

	; Register window class.
	mov dword ptr [wcex.style], 3 ;CS_HREDRAW | CS_VREDRAW;
	mov dword ptr [wcex.lpfnWndProc], offset WndProc@@Game
	mov dword ptr [wcex.cbClsExtra], 0
	mov dword ptr [wcex.cbWndExtra], 4 ; sizeof(LONG_PTR)
	mov eax, hInstance
	mov dword ptr [wcex.hInstance], eax
	mov dword ptr [wcex.hbrBackground], 0eh ;(HBRUSH)COLOR_HIGHLIGHTTEXT;
	mov dword ptr [wcex.lpszMenuName], IDR_MENU1 ; MAKEINTRESOURCE(IDR_MENU1);
	push 7f00H ;IDI_APPLICATION
	push 0
	call dword ptr LoadIcon
	mov dword ptr [wcex.hIcon], eax
	push 7f00H  ;IDC_ARROW
	push 0
	call dword ptr LoadCursor	
	mov dword ptr [wcex.hCursor], eax
	mov dword ptr [wcex.lpszClassName], offset g_clsName  ;TEXT("Tetris-SDK");
	lea eax, dword ptr [wcex]
	push eax
	call dword ptr RegisterClass
	; Create window.
	push 0
	mov eax, hInstance
	push eax
	push 0
	push 0
	push 80000000h	;CW_USEDEFAULT
	push 80000000h
	push 80000000h
	push 80000000h
	push 00cf0000h	;WS_OVERLAPPEDWINDOW
	mov eax, offset g_clsName
	push eax
	push eax 
	push 0
	call dword ptr CreateWindowEx
	mov ebx, eax
	;ShowWindow
	push 5	;SW_SHOW
	push ebx
	call dword ptr ShowWindow
	;UpdateWindow
	push ebx
	call dword ptr UpdateWindow
	xor eax, eax
	ret
Initialize@@Game endp


;LRESULT Game::WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
WndProc@@Game proc stdcall uses ebx esi edi \
			hwnd:dword, \
			message:dword, \
			wParam:dword, \
			lParam:dword
	local hDC:dword
	local loopI:dword
	local loopJ:dword
	local strPrint[20]:word
	local wszGoal[5]:word
	local rect[4]:dword
	mov eax, message
	cmp eax, 1		;WM_CREATE
	je WM_CREATE
	cmp eax, 111h	;WM_COMMAND
	je WM_COMMAND
	cmp eax, 400h	;WM_USER
	je CASE_WM_USER
	cmp eax, 0fh	;WM_PAINT
	je WM_PAINT
	cmp eax, 113h	;WM_TIMER
	je WM_TIMER
	cmp eax, 2		;WM_DESTROY
	je WM_DESTROY
	cmp eax, 100h	;WM_KEYDOWN
	je WM_KEYDOWN
	jmp DEFAULT
WM_CREATE:
	;game.start();
	mov ecx, offset game
	call Start@Game	
	;SetTimer(hwnd, 1, 1000, NULL);
	push 0
	push 1000
	push 1
	push hwnd
	call dword ptr SetTimer
	;game.UpdateScene();
	mov ecx, offset game	
	call UpdateScene@Game	
	;PostMessage(hwnd, WM_USER, NULL, 1);
	push 1
	push 0
	push WM_USER
	push hwnd
	call dword ptr PostMessage	
	;return 0;
	xor eax, eax
	ret
WM_COMMAND:
	;WORD wHiWord = HIWORD(wParam); //0表示是菜单
	;WORD wLwWord = LOWORD(wParam); //菜单项的ID
	mov ecx, wParam
	mov eax, ecx
	shr eax, 16
	;if (wHiWord == 0)
	test eax, eax
	jne EXIT
	;	switch (wLwWord)
	movzx eax, cx
	cmp eax, ID_EASYLEVEL
	je EASY
	cmp eax, ID_NORMALLEVEL
	je NORMAL
	cmp eax, ID_HARDLEVEL
	je HARD
	jmp NO_LEVEL
	;	case ID_EASYLEVEL:
EASY:
	;		KillTimer(hwnd, 1);
	push 1
	push hwnd
	call dword ptr KillTimer	
	;		SetTimer(hwnd, 1, 1000, NULL);
	push 0
	push 1000
	push 1
	push hwnd
	call dword ptr SetTimer	
	;		InvalidateRect(hwnd, NULL, FALSE);
	push 0
	push 0
	push hwnd
	call dword ptr InvalidateRect	
	;		game.restart();
	mov ecx, offset game
	call Restart@Game
	;		break;
	jmp NO_LEVEL
	;	case ID_NORMALLEVEL:
NORMAL:
	;		KillTimer(hwnd, 1);
	push 1
	push hwnd
	call dword ptr KillTimer	
	;		SetTimer(hwnd, 1, 500, NULL);
	push 0
	push 500
	push 1
	push hwnd
	call dword ptr SetTimer	
	;		InvalidateRect(hwnd, NULL, FALSE);
	push 0
	push 0
	push hwnd
	call dword ptr InvalidateRect	
	;		game.restart();
	mov ecx, offset game
	call Restart@Game
	;		break;
	jmp NO_LEVEL
	;	case ID_HARDLEVEL:
HARD:
	;		KillTimer(hwnd, 1);
	push 1
	push hwnd
	call dword ptr KillTimer	
	;		SetTimer(hwnd, 1, 300, NULL);
	push 0
	push 300
	push 1
	push hwnd
	call dword ptr SetTimer	
	;		InvalidateRect(hwnd, NULL, FALSE);
	push 0
	push 0
	push hwnd
	call dword ptr InvalidateRect	
	;		game.restart();
	mov ecx, offset game
	call Restart@Game
	;		break;
	jmp NO_LEVEL
NO_LEVEL:
	;return 0;
	xor eax, eax
	ret
CASE_WM_USER:
	;HDC hDC = GetDC(hwnd);
	push hwnd
	call dword ptr GetDC	
	mov hDC, eax
	;static Map oldMap = game.m_drawMap;
	;static bool first = true;
	mov eax, dword ptr ds:[WM_USER@WndProc@Game]
	test eax, eax 
	jz STATIC_INIT
STATIC_INIT_OVER:
	;if (first)
	cmp byte ptr ds:[first@WndProc], 0
	jne NOT_FIRST
IF_FIRST:
	;for (int i = 0; i < GAME_ROW; i++)
	xor esi, esi
LOOPI_FIRST:
	;for (int j = 0; j < GAME_COL; j++)
	xor edi, edi
LOOPJ_FIRST:
	mov loopI, esi
	mov loopJ, edi
	;if ((game.m_drawMap.getRow(i) << j) & 0x80000000)
	mov ecx, offset game
	lea ecx, [ecx + offset Game.m_drawMap]
	push esi
	call GetRow@Map
	mov ecx, edi
	shl eax, cl
	test eax, eax
	jns DRAW2_FIRST
	;DrawIconEx(hDC, j * 16, i * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON1)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON1
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	shl esi, 4
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
	jmp LOOP_COMPARE_FIRST
DRAW2_FIRST:
	;DrawIconEx(hDC, j * 16, i * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON2)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON2
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	shl esi, 4
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
LOOP_COMPARE_FIRST:
	mov esi, loopI
	mov edi, loopJ
	inc edi
	cmp edi, GAME_COL
	jl LOOPJ_FIRST
	inc esi
	cmp esi, GAME_ROW
	jl LOOPI_FIRST
	mov byte ptr ds:[first@WndProc], 0

	jmp END_IF_FIRST
NOT_FIRST:
	;for (int i = 0; i < GAME_ROW; i++)
	xor esi, esi
LOOPI_NOT_FIRST:
	;for (int j = 0; j < GAME_COL; j++)
	xor edi, edi
LOOPJ_NOT_FIRST:
	mov loopI, esi
	mov loopJ, edi
	;if (((game.m_drawMap.getRow(i) << j) & 0x80000000) != ((oldMap.getRow(i) << j) & 0x80000000))
	mov ecx, offset game
	lea ecx, [ecx + offset Game.m_drawMap]
	push esi
	call GetRow@Map
	mov ecx, edi
	shl eax, cl
	and eax, 80000000h
	mov ebx, eax
	mov ecx, offset oldMap@WndProc
	push esi
	call GetRow@Map
	mov ecx, edi
	shl eax, cl
	and eax, 80000000h
	cmp eax, ebx
	je LOOP_COMPARE_NOT_FIRST
	;if ((game.m_drawMap.getRow(i) << j) & 0x80000000)
	mov ecx, offset game
	lea ecx, [ecx + offset Game.m_drawMap]
	push esi
	call GetRow@Map
	mov ecx, edi
	shl eax, cl
	test eax, eax
	jns DRAW2_NOT_FIRST
	;DrawIconEx(hDC, j * 16, i * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON1)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON1
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	shl esi, 4
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
	jmp LOOP_COMPARE_NOT_FIRST
DRAW2_NOT_FIRST:
	;DrawIconEx(hDC, j * 16, i * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON2)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON2
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	shl esi, 4
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
LOOP_COMPARE_NOT_FIRST:
	mov esi, loopI
	mov edi, loopJ
	inc edi
	cmp edi, GAME_COL
	jl LOOPJ_NOT_FIRST
	inc esi
	cmp esi, GAME_ROW
	jl LOOPI_NOT_FIRST
END_IF_FIRST:
	;oldMap = game.m_drawMap;
	mov esi, offset game + offset Game.m_drawMap
	mov edi, offset oldMap@WndProc
	mov ecx, sizeof Map / 4
	rep movsd
	;if (game.m_redrawNext)
	cmp byte ptr game[offset Game.m_redrawNext], 0
	je DONT_REDRAWNEXT
	;for (int i = 0; i < 4; i++)
	xor esi, esi
LOOPI_REDRAWNEXT:
	;for (int j = 0; j < 4; j++)
	xor edi, edi
LOOPJ_REDRAWNEXT:
	mov loopI, esi
	mov loopJ, edi
	;if (((*game.m_nextBrick)[i] >> (j + 4)) & 0x1)
	mov ecx, dword ptr game[offset Game.m_nextBrick]
	push esi
	call OperatorAt@Brick
	mov ecx, 4
	add ecx, edi
	sar eax, cl
	test al, 1
	jz ICON2_REDRAWNEXT
	;DrawIconEx(hDC, (7 - j + GAME_COL) * 16, (i + 4) * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON1)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON1
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	add esi, 4
	shl esi, 4
	add edi, 7 - GAME_COL
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
	jmp LOOP_COMPARE_REDRAWNEXT
ICON2_REDRAWNEXT:
	;DrawIconEx(hDC, (7 - j + GAME_COL) * 16, (i + 4) * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON2)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON2
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	add esi, 4
	shl esi, 4
	add edi, 7 - GAME_COL
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
LOOP_COMPARE_REDRAWNEXT:
	mov esi, loopI
	mov edi, loopJ
	inc edi
	cmp edi, 4
	jl LOOPJ_REDRAWNEXT
	inc esi
	cmp esi, 4
	jl LOOPI_REDRAWNEXT
DONT_REDRAWNEXT:
	;wchar_t strPrint[20] = (L"分数：");
	mov eax, dword ptr ds:[g_szGrade]
	MOV dword ptr ds:[strPrint], eax
	mov eax, dword ptr ds:[g_szGrade + 4]
	MOV dword ptr ds:[strPrint + 4], eax
	;_itow(game.goal, wszGoal, 10);
	push 10
	lea eax, [wszGoal]
	push eax
	push dword ptr ds:[game + offset Game.goal]
	call dword ptr itow	
	add esp, 12
	;wcscat(strPrint, wszGoal);
	lea	eax, DWORD PTR wszGoal
	push eax
	lea	eax, DWORD PTR strPrint
	push eax
	call wcscat	
	add esp, 8
	;DrawText(hDC, strPrint, -1, &RECT({ (GAME_COL) * 16, 0, (GAME_COL + 2) * 32, 2 * 32 }), DT_CENTER);
	push 1	;DT_CENTER
	mov dword ptr ds:[rect], GAME_COL * 16
	mov dword ptr ds:[rect + 4], 0
	mov dword ptr ds:[rect + 8], (GAME_COL + 2) * 32
	mov dword ptr ds:[rect + 12], 2 * 32 
	lea eax, [rect]
	push eax
	push -1
	lea eax, [strPrint]
	push eax
	push hDC
	call dword ptr DrawText
	;ReleaseDC(hwnd, hDC);
	push hDC
	push hwnd
	call dword ptr ReleaseDC	
	xor eax, eax
	ret

WM_PAINT:
	;HDC hDC = GetDC(hwnd);
	push hwnd
	call dword ptr GetDC	
	mov hDC, eax
	;for (int i = 0; i < GAME_ROW; i++)
	xor esi, esi
LOOPI_PAINT:
	;for (int j = 0; j < GAME_COL; j++)
	xor edi, edi
LOOPJ_PAINT:
	mov loopI, esi
	mov loopJ, edi
	;if ((game.m_drawMap.getRow(i) << j) & 0x80000000)
	mov ecx, offset game
	lea ecx, [ecx + offset Game.m_drawMap]
	push esi
	call GetRow@Map
	mov ecx, edi
	shl eax, cl
	test eax, eax
	jns DRAW2_PAINT
	;DrawIconEx(hDC, j * 16, i * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON1)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON1
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	shl esi, 4
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
	jmp LOOP_COMPARE_PAINT
DRAW2_PAINT:
	;DrawIconEx(hDC, j * 16, i * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON2)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON2
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	shl esi, 4
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
LOOP_COMPARE_PAINT:
	mov esi, loopI
	mov edi, loopJ
	inc edi
	cmp edi, GAME_COL
	jl LOOPJ_PAINT
	inc esi
	cmp esi, GAME_ROW
	jl LOOPI_PAINT

	;for (int i = 0; i < 4; i++)
	xor esi, esi
LOOPI_PAINT2:
	;for (int j = 0; j < 4; j++)
	xor edi, edi
LOOPJ_PAINT2:
	mov loopI, esi
	mov loopJ, edi
	;if (((*game.m_nextBrick)[i] >> (j + 4)) & 0x1)
	mov ecx, dword ptr game[offset Game.m_nextBrick]
	push esi
	call OperatorAt@Brick
	mov ecx, 4
	add ecx, edi
	sar eax, cl
	test al, 1
	jz ICON2_PAINT2
	;DrawIconEx(hDC, (7 - j + GAME_COL) * 16, (i + 4) * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON1)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON1
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	add esi, 4
	shl esi, 4
	neg edi
	add edi, 7 + GAME_COL
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
	jmp LOOP_COMPARE_PAINT2
ICON2_PAINT2:
	;DrawIconEx(hDC, (7 - j + GAME_COL) * 16, (i + 4) * 16, LoadIcon(g_hIns, MAKEINTRESOURCE(IDI_ICON2)), 16, 16, 0, NULL, DI_COMPAT | DI_NORMAL);
	push 7	;DI_COMPAT | DI_NORMA
	push 0
	push 0
	push 16
	push 16
	push IDI_ICON2
	push dword ptr ds:[g_hIns]
	call dword ptr LoadIcon	
	push eax
	add esi, 4
	shl esi, 4
	neg edi
	add edi, 7 + GAME_COL
	shl edi, 4
	push esi
	push edi
	push hDC
	call dword ptr DrawIconEx
LOOP_COMPARE_PAINT2:
	mov esi, loopI
	mov edi, loopJ
	inc edi
	cmp edi, 4
	jl LOOPJ_PAINT2
	inc esi
	cmp esi, 4
	jl LOOPI_PAINT2
	;wchar_t strPrint[20] = (L"分数：");
	mov eax, dword ptr ds:[g_szGrade]
	MOV dword ptr ds:[strPrint], eax
	mov eax, dword ptr ds:[g_szGrade + 4]
	MOV dword ptr ds:[strPrint + 4], eax
	;_itow(game.goal, wszGoal, 10);
	push 10
	lea eax, [wszGoal]
	push eax
	push dword ptr ds:[game + offset Game.goal]
	call dword ptr itow	
	add esp, 12
	;wcscat(strPrint, wszGoal);
	lea	eax, DWORD PTR wszGoal
	push eax
	lea	eax, DWORD PTR strPrint
	push eax
	call wcscat	
	add esp, 8
	;DrawText(hDC, strPrint, -1, &RECT({ (GAME_COL) * 16, 0, (GAME_COL + 2) * 32, 2 * 32 }), DT_CENTER);
	push 1	;DT_CENTER
	mov dword ptr ds:[rect], GAME_COL * 16
	mov dword ptr ds:[rect + 4], 0
	mov dword ptr ds:[rect + 8], (GAME_COL + 2) * 32
	mov dword ptr ds:[rect + 12], 2 * 32 
	lea eax, [rect]
	push eax
	push -1
	lea eax, [strPrint]
	push eax
	push hDC
	call dword ptr DrawText
	;ReleaseDC(hwnd, hDC);
	push hDC
	push hwnd
	call dword ptr ReleaseDC	
	;ValidateRect(hwnd, NULL);
	push 0
	push hwnd
	call dword ptr ValidateRect	
	xor eax, eax
	ret
WM_TIMER:
	mov ecx, offset game
	call OnDown@Game	
	cmp eax, -1
	jne NOT_GAMEOVER
	xor eax, eax
	ret
NOT_GAMEOVER:
	mov ecx, offset game
	call UpdateScene@Game	
	push 1
	push 0
	push WM_USER
	push hwnd
	call dword ptr PostMessage	
	xor eax, eax
	ret
WM_DESTROY:
	push 0
	call dword ptr PostQuitMessage	
	xor eax, eax
	ret
WM_KEYDOWN:
	mov ecx, wParam
	cmp cl, 'W'
	je CASE_W
	cmp cl, 'S'
	je CASE_S
	cmp cl, 'A'
	je CASE_A
	cmp cl, 'D'
	je CASE_D
	cmp cl, 1bh  ;VK_ESCAPE
	je CASE_ESC
	jmp END_CASE_KEY
CASE_W:
	mov ecx, offset game
	call OnUp@Game	
	jmp END_CASE_KEY
CASE_S:
	mov ecx, offset game
	call OnDown@Game	
	jmp END_CASE_KEY
CASE_A:
	mov ecx, offset game
	call OnLeft@Game	
	jmp END_CASE_KEY
CASE_D:
	mov ecx, offset game
	call OnRight@Game	
	jmp END_CASE_KEY
CASE_ESC:
	push 0
	call dword ptr PostQuitMessage		
END_CASE_KEY:
	mov ecx, offset game
	call UpdateScene@Game	
	push 1
	push 0
	push WM_USER
	push hwnd
	call dword ptr PostMessage	
	;xor eax, eax
	;ret
DEFAULT:
	push lParam
	push wParam
	push message
	push hwnd
	call dword ptr DefWindowProc	
	ret
EXIT:
	xor eax, eax
	ret
STATIC_INIT:
	lea esi, [game]
	lea edi, oldMap@WndProc
	mov ecx, sizeof Map / 4
	rep movsd
	mov byte ptr ds:[first@WndProc], 1
	jmp STATIC_INIT_OVER
WndProc@@Game endp
END