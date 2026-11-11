from fastapi import APIRouter, HTTPException, status
from app.config import get_database
from app.models.user import UserRegister, UserLogin, UserResponse
from app.services.auth_service import hash_password, verify_password, create_access_token

router = APIRouter()

@router.post("/register", response_model=UserResponse)
async def register(user: UserRegister):
    db = await get_database()
    users_collection = db["users"]

    # Check if user already exists
    existing_user = await users_collection.find_one({"email": user.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    hashed_pw = hash_password(user.password)
    user_doc = {
        "username": user.username,
        "email": user.email,
        "password": hashed_pw,
        "rating": 1200
    }

    result = await users_collection.insert_one(user_doc)
    return UserResponse(
        id=str(result.inserted_id),
        username=user.username,
        email=user.email,
        rating=1200
    )

@router.post("/login")
async def login(user: UserLogin):
    db = await get_database()
    users_collection = db["users"]

    db_user = await users_collection.find_one({"username": user.username})
    if not db_user or not verify_password(user.password, db_user["password"]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid username or password")

    token = create_access_token({"sub": db_user["username"]})
    return {"access_token": token, "token_type": "bearer", "username": db_user["username"], "rating": db_user.get("rating", 1200)}