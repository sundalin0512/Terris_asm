ifndef	MAP_INC
MAP_INC equ <1>

include defines.inc

Map struct 4
	m_rows	dd GAME_ROW dup(?)
Map ends

;Map::Map()
Map@Map proto stdcall
;Map::~Map()
Map0@Map proto stdcall
;void Map::reset()
Reset@Map proto stdcall
;unsigned int Map::getRow(size_t index) const
GetRow@Map proto stdcall index:dword
;void Map::changeRow(size_t index, int data)
ChangeRow@Map proto stdcall index:dword, data:dword
;int Map::TryDeleteLines()
TryDeleteLines@Map proto stdcall

ELSE
echo -----------------------------------------
echo WARNING Duplicate include map.inc
echo -----------------------------------------
ENDIF