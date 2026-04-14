/* 221006 LAB 7 */
#include <iostream>
#include <cstdlib>

using namespace std;
int main(int argc, char** argv)
{
    int n = atoi(argv[2]);
    for(int i = 0; i < n; i++)
    {
        cout << argv[1] <<  "\n";
    }
    return 0;
}