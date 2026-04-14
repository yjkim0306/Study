/* 221006 LAB 7 */
#include <iostream>
#include <string>
using namespace std;
struct Person{
    double score;
    string name;
};

int main(int argc, char** argv)
{
    int N = (argc-1)/2;
    Person* student = new Person[N];
    for(int i = 1; i < argc; i++)
    {
        if(i%2 == 1) student[(i-1)/2].name = argv[i];
        else student[(i-1)/2].score = atof(argv[i]);
    }
    for(int i = 0; i < N; i++)
    {
        cout << "Name:" << student[i].name << ", Score:" << student[i].score << "\n";
    }
    delete[] student;

    return 0;
}