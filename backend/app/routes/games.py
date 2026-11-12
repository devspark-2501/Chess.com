from fastapi import APIRouter
from app.config import get_database
from app.models.game import GameRecord

router = APIRouter()

@router.post("/save")
async def save_game(game: GameRecord):
    db = await get_database()
    games_collection = db["games"]

    game_dict = game.dict()
    result = await games_collection.insert_one(game_dict)

    return {"message": "Game saved successfully!", "game_id": str(result.inserted_id)}

@router.get("/history/{username}")
async def get_user_games(username: str):
    db = await get_database()
    games_collection = db["games"]

    cursor = games_collection.find({"$or": [{"white_player": username}, {"black_player": username}]})
    games = []
    async for document in cursor:
        document["_id"] = str(document["_id"])
        games.append(document)

    return {"games": games}