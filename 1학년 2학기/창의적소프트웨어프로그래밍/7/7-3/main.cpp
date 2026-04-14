/* 221006 LAB 7 */
#include "minimax.cpp"
using namespace std;
int main(int argc, char **argv)
{
    int N = argc;
    int max, min;
    int* arr = new int[N];
    for(int i = 0; i < argc; i++)
    {
        arr[i] = atoi(argv[i+1]);
    }
    getMinMax(*arr, N, max, min);
    cout << "min: " << min << "\n";
    cout << "max: " << max << "\n";
    delete[] arr;

    return 0;
}