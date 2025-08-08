from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    MYSQL_DATABASE_URL: str
    SECRET_KEY: str
    OPENAI_API_KEY: str

    class Config:
        env_file = ".env"

settings = Settings()