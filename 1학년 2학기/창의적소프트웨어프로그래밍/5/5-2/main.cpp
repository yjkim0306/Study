/* 220929 LAB 5 */
#include <iostream>

using namespace std;
int main()
{
    int N;
    cin >> N;
    int *numArr = new int[N];
    for(int i = 0; i < N; i++)
    {
        cin >> numArr[i];
    }
    int max = numArr[0];
    int min = numArr[0];
    for(int i = 0; i < N; i++)
    {
        if(max < numArr[i]) max = numArr[i];
    }
    for(int i = 0; i < N; i++)
    {
        if(min > numArr[i]) min = numArr[i];
    }
    cout << "min: " << min << endl;
    cout << "max: " << max << endl;

    delete[] numArr;
    return 0;
}