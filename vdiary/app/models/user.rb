class User < ActiveRecord::Base
    has_secure_password # ← method to enable 'BCRYPT' GEM MACRO : enables .PASSWORD=() and .PASSWORD_DIGEST and .AUTHENTICATE, automatically validates presense
    validates :name, presence: true, uniqueness: true # ← ACTIVE RECORD VALIDATION : ensures only UNIQUE NAME STRINGS exist in database :: ♥LOL TRULY UNIQUE NAMES VALIDATION ♥elohel

    has_many :entries #<---
    # ↑ OBJECT RELATIONSHIP -- indicates ownership of an ARRAY of ENTRY OBJECTS
end
