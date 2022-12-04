def beats(them, me):
    match them:
        case 'A':  # rock
            match me:
                case 'X':  # lose - scissors
                    return 0 + 3
                case 'Y':  # draw - rock
                    return 3 + 1
                case 'Z':  # win - paper
                    return 6 + 2
        case 'B':  # paper
            match me:
                case 'X':  # lose - rock
                    return 0 + 1
                case 'Y':  # draw - paper
                    return 3 + 2
                case 'Z':  # win - scisssors
                    return 6 + 3
        case 'C':  # scissors
            match me:
                case 'X':  # lose - paper
                    return 0 + 2
                case 'Y':  # draw - scissors
                    return 3 + 3
                case 'Z':  # win - rock
                    return 6 + 1


def calc(go):
    value = 0
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
