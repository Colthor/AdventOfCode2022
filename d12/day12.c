#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

struct mapSquare
{
    int reached_in;
    unsigned char height;
};

int max_x = 0, max_y = 0;
int start_x = 0, start_y = 0;
int end_x = 0, end_y = 0;
struct mapSquare **map = NULL;

void findPath(int x, int y, unsigned char max_h, int dist)
{
    if (x < 0 || y < 0 || x >= max_x || y >= max_y)
        return;
    if (max_h < map[x][y].height)
        return;

    if (map[x][y].reached_in > dist)
    {
        map[x][y].reached_in = dist;
        int new_h = map[x][y].height + 1, new_dist = dist + 1;

        if (x == end_x && y == end_y)
            return;

        findPath(x + 1, y, new_h, new_dist);
        findPath(x - 1, y, new_h, new_dist);
        findPath(x, y + 1, new_h, new_dist);
        findPath(x, y - 1, new_h, new_dist);
    }
}

int main(int argc, char *argv[])
{
    if (0 == argc)
    {
        printf("Filename needed!\n");
        return 1;
    }
    FILE *fin = fopen(argv[1], "r");
    fpos_t fstart;
    fgetpos(fin, &fstart);
    char buffer[255];

    printf("Counting...\n");

    // count map size
    while (!feof(fin))
    {
        if (!fgets(buffer, 255, fin))
            break;

        int len = strlen(buffer) - 1;
        if (len > 1)
        {
            ++max_y;
            if (len > max_x)
            {
                max_x = len;
            }
        }
    }

    printf("Alloc...\n");

    // allocate 2D map array
    map = (struct mapSquare **)malloc(max_x * sizeof(struct mapSquare *));
    for (int x = 0; x < max_x; ++x)
        map[x] = (struct mapSquare *)malloc(max_y * sizeof(struct mapSquare));

    printf("fsetpos...\n");
    // read map
    fsetpos(fin, &fstart);
    int y = 0;
    printf("Reading...\n");
    while (!feof(fin))
    {
        if (!fgets(buffer, 255, fin))
            break;

        // printf("Line %d: %s\n", y, buffer);
        int len = strlen(buffer) - 1;
        if (len > 1)
        {
            for (int x = 0; x < len; x++)
            {
                if (buffer[x] < 'A' || buffer[x] > 'z')
                    break;

                if ('S' == buffer[x])
                {
                    // Start position
                    start_x = x;
                    start_y = y;
                    map[x][y].height = 0;
                }
                else if ('E' == buffer[x])
                {
                    // end position

                    end_x = x;
                    end_y = y;
                    map[x][y].height = 'z' - 'a';
                }
                else
                {
                    map[x][y].height = buffer[x] - 'a';
                }
                map[x][y].reached_in = 1000000;
            }
        }
        ++y;
    }
    printf("Pathing part 1...\n");
    clock_t start, end;
    start = clock();
    findPath(start_x, start_y, 0, 0);
    end = clock();
    printf("Found end in: %d steps, %d ns.\n", map[end_x][end_y].reached_in, (int)(end - start));

    printf("Pathing part 2...\n");
    start = clock();
    for (int x = 0; x < max_x; ++x)
    {
        printf("Row %d\n", x);
        for (int y = 0; y < max_y; ++y)
            findPath(x, y, 0, 0);
    }
    end = clock();
    printf("Found end in: %d steps, %d ns.\n", map[end_x][end_y].reached_in, (int)(end - start));

    printf("Cleaning up...\n");
    fclose(fin);

    // free map array
    for (int x = 0; x < max_x; ++x)
    {
        // printf("Freeing: %d\n", x);
        free((void *)map[x]);
    }
    // printf("Freeing: map\n");

    free((void *)map);
    return 0;
}