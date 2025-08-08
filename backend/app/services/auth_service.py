from sqlalchemy.orm import Session
from app.models.user import User
from app.utils.hash_pw import verify_pw
from app.utils.jwt_handler import create_access_token

def authenticate_user(db: Session, email: str, password: str):
    print("Email from form:", email)
    user = db.query(User).filter(User.email == email).first()
    print("User from DB:", user)
    if not user:
        print("User not found")
        return None
    if not verify_pw(password, user.password):
        print("Password mismatch")
        return None
    return user


def create_token_for_user(user: User):
    token_data = {
        "sub": str(user.user_id),
        "username": user.username,
        "role": user.role.value,
        "photo_url": user.photo_url
    }
    token = create_access_token(token_data)
    return token