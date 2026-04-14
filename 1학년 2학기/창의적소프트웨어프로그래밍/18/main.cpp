/* 221125 LAB 18 */
#include "list.h"
using namespace std;
int main()
{
    int array[5] = {12, 7, 9, 21 ,13};
    List<int> li(array, 5);
    cout << li << endl; // 12, 7, 9, 21 ,13

    li.pop_back();
    cout << li << endl; // 12, 7, 9, 21
    
    li.push_back(15);
    cout << li << endl; // 12, 7, 9, 21, 15

    li.pop_front();
    cout << li << endl; // 7, 9, 21, 15

    li.push_front(8);
    cout << li << endl; // 8, 7, 9, 21, 15

    li.insert_at(4, 19);
    cout << li << endl; // 8, 7, 9, 21, 19, 15

    li.remove_at(1);
    cout << li << endl; // 8, 9, 21, 19, 15

    return 0;
}