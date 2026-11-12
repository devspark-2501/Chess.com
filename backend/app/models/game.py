from pydantic import BaseModel
from typing import List

class GameRecord(BaseModel):
    white_player: str
    black_player: str
    winner: str  # 'white', 'black', or 'draw'
    time_control: int
    moves: List[str]