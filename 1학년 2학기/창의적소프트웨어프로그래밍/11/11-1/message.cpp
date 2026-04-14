/* 221028 LAB 11 */
#include "message.h"
using namespace std;
void MessageBook::AddMessage(int num, const string& msg)
{
    messages_.insert(make_pair(num, msg));
}

void MessageBook::DeleteMessage(int num)
{
    messages_.erase(num);
}

vector<int> MessageBook::GetNumbers()
{
    vector<int> v;
    for(map<int, string>::iterator it = messages_.begin(); it != messages_.end(); ++it)
    {
        v.push_back(it->first);
    }
    return v;
}

const string& MessageBook::GetMessage(int num)
{
    const string& mes = messages_.find(num)->second;
    return mes;
}