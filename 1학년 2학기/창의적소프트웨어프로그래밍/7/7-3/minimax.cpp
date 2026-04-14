/* 221006 LAB 7 */
#include "minimax.h"
using namespace std;
inline void getMinMax(int* arr, int len, int& min, int& max)
{
    max = arr[0];
    min = arr[0];
    for(int i = 0; i < len; i ++)
    {
        if(max < arr[i]) max = arr[i];
    }
    for(int i = 0; i < len; i++)
    {
        if(min > arr[i]) min = arr[i];
    }
}
