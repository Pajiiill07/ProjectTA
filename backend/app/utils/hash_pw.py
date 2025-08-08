from passlib.context import CryptContext

pw_hash = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)

def hash_pw(password: str)-> str:
    return pw_hash.hash(password)

def verify_pw(plain_password: str, hashed_password: str) -> bool:
    return pw_hash.verify(plain_password, hashed_password)