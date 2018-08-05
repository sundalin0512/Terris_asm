ifndef	BRICK_INC
BRICK_INC equ <1>

Brick struct 4
	m_data		dd 4 dup (?)
	m_type		dd ?
	m_rotate	dd ?
	m_axisRow	dd ?
	m_axisCol	dd ?
	m_map		dd ?
Brick ends

;Brick::Brick(const Map & map)
Brick@Brick proto stdcall map:dword
;Brick::~Brick()
Brick0@Brick proto stdcall 
;int Brick::operator[](size_t index) const
OperatorAt@Brick proto stdcall index:dword 
;Brick& operator=(const Brick& other)
OperatorEqual@Brick proto stdcall other:dword
;int Brick::getAxisRow() const
GetAxisRow@Brick proto stdcall 
;int Brick::getAxisCol() const
GetAxisCol@Brick proto stdcall 
;int Brick::TryRotate()
TryRotate@Brick proto stdcall 
;int Brick::TryMove(int x, int y)
TryMove@Brick proto stdcall x:dword, y:dword
;Brick::operator new(Map& map)
new@Brick proto stdcall map:dword
;Brick::operator delete(Brick* brick)
delete@Brick proto stdcall pThis:dword
ELSE
echo -----------------------------------------
echo WARNING Duplicate include brick.inc
echo -----------------------------------------
ENDIF