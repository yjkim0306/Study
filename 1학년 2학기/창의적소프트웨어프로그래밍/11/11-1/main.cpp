/* 221028 LAB 11 */
#include "message.cpp"
using namespace std;
int main()
{
    MessageBook msg;
    string str;
    int num;
    while(1)
    {
        cin >> str;
        if(str == "add")
        {
            cin >> num;
            cin.ignore();
            getline(cin, str);
            msg.AddMessage(num, str);
        }
        else if(str == "delete")
        {
            cin >> num;
            msg.DeleteMessage(num);
        }
        else if(str == "print")
        {
            cin >> num;
            cout << msg.GetMessage(num) << "\n";
        }
        else if(str == "list")
        {
            vector<int> v;
            v = msg.GetNumbers();
            for(vector<int>::iterator it = v.begin(); it != v.end(); ++it)
            {
                cout << *it << ": " << msg.GetMessage(*it) << "\n";
            }
        }
        else if(str == "quit") break;
    }

    return 0;
}