/* 221117 LAB 15 */
#include "my_string2.cpp"
using namespace std;
int main()
{
    MyString2 a;
    MyString2 b;
    while(1)
    {
        string input;
        cin >> input;
        if(input == "quit") break;
        else if(input == "new")
        {
            cout << "enter a\n";
            cin >> a;
            cout << "enter b\n";
            cin >> b;
        }
        else if(input == "a" || input == "b")
        {
            string op;
            cin >> op;
            if(op == "*")
            {
                int n;
                cin >> n;
                if(input == "a") 
                {
                    MyString2 str(a * n);
                    cout << str;
                }
                else if(input == "b")
                {
                    MyString2 str(b * n);
                    cout << str;
                }
            }
            else if(op == "+")
            {
                if(input == "a")
                {
                    string operand;
                    cin >> operand;
                    if(operand == "a")
                    {
                        MyString2 str(a + a);
                        cout << str;
                    }
                    else if(operand == "b")
                    {
                        MyString2 str(a + b);
                        cout << str;
                    }
                }
                if(input == "b")
                {
                    string operand;
                    cin >> operand;
                    if(operand == "a")
                    {
                        MyString2 str(b + a);
                        cout << str;
                    }
                    else if(operand == "b")
                    {
                        MyString2 str(b + b);
                        cout << str;
                    }
                }
            }
        }
    }

    return 0;
}