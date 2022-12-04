#include <iostream>
#include <string>
#include <set>

int main()
{
    unsigned int biggest = 0;
    unsigned int sum = 0;
    auto exit = 0;
    std::string line;
    std::set<unsigned int> counts;

    while (std::getline(std::cin, line) && exit < 2)
    {
        // std::cout << "got: '" << line << "'\n";
        if ("" == line)
        {
            if (biggest < sum)
            {
                biggest = sum;
            }
            counts.insert(sum);
            sum = 0;
            ++exit;
        }
        else
        {
            sum += stoul(line);
            exit = 0;
        }
    }

    std::cout << "biggest: " << biggest << std::endl;
    auto last = counts.rbegin();
    sum = 0;
    for (auto i = 1; i < 4; ++i)
    {
        std::cout << i << "th biggest: " << *last << std::endl;
        sum += *last;
        last++;
    }
    std::cout << "top 3 sum: " << sum << std::endl;
}