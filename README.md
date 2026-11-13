# ♟️ Chess.com Clone (Flutter & FastAPI)

A full-stack, real-time chess application built using **Flutter** for cross-platform mobile/web views and **FastAPI** for a high-performance Python backend with **MongoDB Atlas** persistence.

---

## 🚀 Features

* **Real-time Chess Engine**: Full move validation, strict King-in-check checking, and game-ending states (checkmate & stalemate).
* **User Authentication**: Secure JWT-based login and signup using bcrypt password hashing.
* **Game History & Tracking**: Save completed matches and retrieve player game history.
* **Dynamic Home Screen**: Custom player profile headers showing ratings and interactive authentication controls.
* **Cross-Platform**: Optimized for Android, iOS, and Web.

---

## 🛠️ Tech Stack

* **Frontend:** Flutter (Dart), `http`, `shared_preferences`
* **Backend:** FastAPI (Python), Motor (Async MongoDB Driver), Uvicorn, PyJWT, Passlib
* **Database:** MongoDB Atlas (Cloud)

---

## 📂 Project Structure

```text
chess_app/
├── backend/
│   ├── app/
│   │   ├── models/        # Pydantic data schemas (User, Game)
│   │   ├── routes/        # API endpoints (Auth, Games)
│   │   ├── services/      # Business logic & JWT/password hashing
│   │   ├── config.py      # Database connection configuration
│   │   └── main.py        # FastAPI entry point & CORS setup
│   ├── .env               # Environment variables (Mongo URI, Secrets)
│   └── requirements.txt   # Python dependencies
└── lib/
    ├── core/
    │   ├── constants/     # App color themes and layout constants
    │   └── services/      # Flutter HTTP client & SharedPreferences service
    ├── features/
    │   ├── auth/          # Login & Signup screens and widgets
    │   ├── game/          # Chessboard UI and move validation logic
    │   └── home/          # Home screen, player profile card, and hamburger drawer
    └── main.dart          # Flutter app entry point
