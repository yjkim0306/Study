/* 220930 LAB 6 */
#include <iostream>
#include <algorithm>

using namespace std;

void sort_int(int a, int* arr)
{
    int temp;
    for(int i = 0; i < a; i++)
    {
        for(int j = 0; j < a-1-i; j++)
        {
            if(arr[j] > arr[j+1])
            {
                temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}
int main()
{
    int N;
    cin >> N;
    if(N <= 0) return 0;
    int arr[N];
    for(int i = 0; i < N; i++)
    {
        cin >> arr[i];
    }
    sort_int(N, arr);
    for(int i = 0; i < N; i++)
    {
        cout << arr[i] << " ";
    }
    cout << endl;
    
    return 0;
}