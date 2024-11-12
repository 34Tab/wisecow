import sys
import random

# List of cow sayings
sayings = [
    "Mooooove over!",
    "Have an udderly great day!",
    "Let's milk this moment!",
    "Holy cow!",
    "Got milk?"
]

def get_random_saying():
    return random.choice(sayings)

def create_cow(message):
    return f'''
    {message}
    \\   ^__^
     \\  (oo)\\_______
        (__)\\       )\\/\\
            ||----w |
            ||     ||
    '''

if __name__ == "__main__":
    message = get_random_saying()
    print(create_cow(message))
