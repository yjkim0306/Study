/* 221028 LAB 11 */
#include "setfunc.h"
using namespace std;
set<int> SetFunc::parseSet(const string& str)
{
    set<int> s;
    for(int i = 0; i < str.length(); i++)
    {
        if(str[i] == '-' || str[i] >= 48 && str[i] <= 57)
        {
            string temp = "";
            while(str[i] >= 48 && str[i] <= 57 || str[i] == '-')
            {
                temp += str[i];
                i++;
            }
            int n = atoi(temp.c_str());
            s.insert(n);
            temp = "";
        }
    }
    return s;
}

void SetFunc::printSet(const set<int>& s)
{
    cout << "{ ";
    for(set<int>::iterator it = s.begin(); it != s.end(); it++)
    {
        cout << *it << " ";
    }
    cout << "}" << "\n";
}

set<int> SetFunc::getUnion(const set<int>& set0, const set<int>& set1)
{
    set<int> res; 
    for(set<int>::iterator it = set0.begin(); it != set0.end(); it++)
    {
        res.insert(*it);
    }
    for(set<int>::iterator it = set1.begin(); it != set1.end(); it++)
    {
        res.insert(*it);
    }
    return res;
}

set<int> SetFunc::getIntersection(const set<int>& set0, const set<int>& set1)
{
    set<int> res;
    for(set<int>::iterator it = set0.begin(); it != set0.end(); it++)
    {
        for(set<int>::iterator it2 = set1.begin(); it2 != set1.end(); it2++)
        {
            if(*it == *it2) res.insert(*it);
        }
    }
    return res;
}

set<int> SetFunc::getDifference(const set<int>& set0, const set<int>& set1)
{
    set<int> res;
    for(set<int>::iterator it = set0.begin(); it != set0.end(); it++)
    {
        res.insert(*it);
        for(set<int>::iterator it2 = set1.begin(); it2 != set1.end(); it2++)
        {
            if(*it2 == *it) res.erase(*it);
        }
    }
    return res;
}

