ifndef	GAME_INC
GAME_INC equ <1>

include map.inc

Game struct 4
	m_map			Map <>
	m_drawMap		Map <>
	m_brick			dd ?
	m_nextBrick		dd ?
	goal			dd ?
	m_redrawNext	db ?
Game ends

externdef game:Game

;Game::Game()
Game@Game proto stdcall
;Game::~Game()
Game0@Game proto stdcall
;void Game::start()
Start@Game proto stdcall
;void Game::restart()
Restart@Game proto stdcall
;void Game::InitGame()
InitGame@Game proto stdcall
;void Game::UpdateScene()
UpdateScene@Game proto stdcall
;int Game::FixBrick()
FixBrick@Game proto stdcall
;int Game::OnUp()
OnUp@Game proto stdcall 
;int Game::OnDown()
OnDown@Game proto stdcall 
;int Game::OnLeft()
OnLeft@Game proto stdcall 
;int Game::OnRight()
OnRight@Game proto stdcall 
;void Game::calculateGoal(int lines)
CalculateGoal@Game proto stdcall lines:dword
;HRESULT Game::Initialize(HINSTANCE hInstance)
Initialize@@Game proto stdcall hInstance:dword
;LRESULT Game::WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
WndProc@@Game proto stdcall hwnd:dword, message:dword, wParam:dword, lParam:dword


ELSE
echo -----------------------------------------
echo WARNING Duplicate include game.inc
echo -----------------------------------------
ENDIF