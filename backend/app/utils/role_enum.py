from enum import Enum

class UserRoleEnum(str, Enum):
    admin = "admin"
    user = "user"