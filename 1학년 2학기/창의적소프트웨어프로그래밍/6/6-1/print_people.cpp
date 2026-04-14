/* 220930 LAB 6 */
#include <iostream>
#include <string>

using namespace std;
struct Person {
    string name;
    int age;
};

int main()
{
    int N;
    cin >> N;
    struct Person student[N];
    for(int i=0; i<N; i++)
    {
        cin >> student[i].name >> student[i].age;
    }
    for(int j=0; j<N; j++)
    {
        cout << "Name:" << student[j].name << ", Age: " << student[j].age << endl;
    }
    
    return 0;
}