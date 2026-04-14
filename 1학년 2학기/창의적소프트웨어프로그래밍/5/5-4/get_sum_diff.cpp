/* 220929 LAB 5 */
#include <iostream>

using namespace std;
void getSumDiff(int a, int b, int& sum, int& diff)
{
    sum = a + b;
    diff = a - b;
}

int main()
{
    int a, b, sum, diff;
    cin >> a >> b;
    getSumDiff(a, b, sum, diff);
    cout << "sum:" << sum << endl;
    cout << "diff:" << diff << endl;

    return 0;
}