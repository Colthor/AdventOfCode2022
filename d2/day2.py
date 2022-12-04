def beats(them, me):
    match them:
        case 'A':  # rock
            match me:
                case 'X':  # rock
                    return 3
                case 'Y':  # paper
                    return 6
                case 'Z':  # scisssors
                    return 0
        case 'B':  # paper
            match me:
                case 'X':  # rock
                    return 0
                case 'Y':  # paper
                    return 3
                case 'Z':  # scisssors
                    return 6
        case 'C':  # scissors
            match me:
                case 'X':  # rock
                    return 6
                case 'Y':  # paper
                    return 0
                case 'Z':  # scisssors
                    return 3


def calc(go):
    value = 0
    match go[1]:
        case 'X':
            value = 1
        case 'Y':
            value = 2
        case 'Z':
            value = 3
    value += beats(go[0], go[1])
    return value


filename = input()
infile = open(filename, 'r')

score = 0

for line in infile:
    go = line.split()
    if len(go) > 1:
        roundscore = calc(go)
        print(go, roundscore)
        score += roundscore
print(score)
