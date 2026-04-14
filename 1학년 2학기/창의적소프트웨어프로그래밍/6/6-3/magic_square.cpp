/* 220930 LAB 6 */
#include <iostream>
using namespace std;
void magicSquare(int N, int** arr)
{
    int x = 0, y = N/2;
    int cnt = 0;
    for(int i = 0; i < N*N; i++)
    {
        cnt++;
        if(x<0) x += N;
        if(y>=N) y -= N;
        arr[x][y] = cnt;
        if(cnt%N== 0)
        {
            x++;
            continue;
        }
        x--;
        y++;
    }
}

int N;
int main()
{ 
    cin >> N;
    if(N < 3 || N%2 == 0) return 0;
    int** arr = new int*[N];
    for(int i = 0; i < N; i++)
    {
        arr[i] = new int[N];
    }
    magicSquare(N, arr);
    for(int i = 0; i < N; i++){
        for(int j = 0; j < N; j++)
        {
            cout << arr[i][j] << " ";
        }
        cout << "\n";
    }
    for(int i =0; i < N; i++)
    {
        delete[] arr[i];
    }
    delete[] arr;

    return 0;
}