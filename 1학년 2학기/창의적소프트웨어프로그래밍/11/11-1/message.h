/* 221028 LAB 11 */
#include <iostream>
#include <vector>
#include <map>
#include <string>
using namespace std;
class MessageBook{
public:
    void AddMessage(int number, const string& message);
    void DeleteMessage(int number);
    vector<int> GetNumbers();
    const string& GetMessage(int number);

private:
    map<int, string> messages_;
};