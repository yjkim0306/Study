/* 221028 LAB 11 */
#include "setfunc.h"
using namespace std;
SetFunc func;
int main()
{
    string str;
    while(1)
    {
        getline(cin, str);
        if(str == "0") break;
        string str1 = "";
        string str2 = "";
        char op;

        string::iterator it = str.begin();

        while(it != str.end())
        {
            if(*it == '{' && (str1.find("}") == string::npos))
            {
                while(*it != '}')
                {
                    str1 += *it;
                    it++;
                }
                str1 += "}";
            }
            else if(*it == '{')
            {
                while(*it != '}')
                {
                    str2 += *it;
                    it++;
                }
                str2 += "}";
            }
            else if(*it == '+' || *it == '*' || *it == '-') op = *it;

            it++;
        }
        set<int> set1 = func.parseSet(str1);
        set<int> set2 = func.parseSet(str2);
        if(op == '+')
        {
            set<int> res = func.getUnion(set1, set2);
            func.printSet(res);
        }
        else if(op == '*')
        {
            set<int> res = func.getIntersection(set1, set2);
            func.printSet(res);
        }
        else if(op == '-')
        {
            set<int> res = func.getDifference(set1, set2);
            func.printSet(res);
        }
    }

    return 0;
}