/* 221118 LAB 16 */
#include "my_vector.cpp"
using namespace std;
int main()
{
    MyVector a, b;
    while(1)
    {
        string input;
        cin >> input;
        if(input == "quit") break;
        else if(input == "new")
        {
            int length;
            cin >> length;
            MyVector aa(length), bb(length);
            cout << "enter a\n";
            cin >> aa;
            cout << "enter b\n";
            cin >> bb;

            a = aa;
            b = bb;
        }
        else if(input == "a" || input == "b")
        {
            string op;
            cin >> op;
            if(input == "a")
            {
                if(op == "+")
                {
                    char operand;
                    cin >> operand;
                    if(operand >= 48 && operand <= 57)
                    {
                        MyVector v(a);
                        v = a + (operand - '0');
                        cout << v << endl;
                    }
                    else if(operand >=97 && operand <= 122)
                    {
                        if(operand == 'a')
                        {
                            MyVector v(a);
                            v = a + a;
                            cout << v << endl;
                        }
                        else if(operand == 'b')
                        {
                            MyVector v(a);
                            v = a + b;
                            cout << v << endl;
                        }
                    }
                }
                else if(op == "-")
                {
                    char operand;
                    cin >> operand;
                    if(operand >= 48 && operand <= 57)
                    {
                        MyVector v(a);
                        v = a - (operand - '0');
                        cout << v << endl;
                    }
                    else if(operand >=97 && operand <= 122)
                    {
                        if(operand == 'a')
                        {
                            MyVector v = a - a;
                            cout << v << endl;
                        }
                        else if(operand == 'b')
                        {
                            MyVector v = a - b;
                            cout << v << endl;
                        }
                    }
                }
            }
            else if(input == "b")
            {
                if(op == "+")
                {
                    char operand;
                    cin >> operand;
                    if(operand >= 48 && operand <= 57)
                    {
                        MyVector v(b);
                        v = b + (operand - '0');
                        cout << v << endl;
                    }
                    else if(operand >=97 && operand <= 122)
                    {
                        if(operand == 'a')
                        {
                            MyVector v(b);
                            v = b + a;
                            cout << v << endl;
                        }
                        else if(operand == 'b')
                        {
                            MyVector v(b);
                            v = b + b;
                            cout << v << endl;
                        }
                    }
                }
                else if(op == "-")
                {
                    char operand;
                    cin >> operand;
                    if(operand >= 48 && operand <= 57)
                    {
                        MyVector v(b);
                        v = b - (operand - '0');
                        cout << v << endl;
                    }
                    else if(operand == 'a' || operand == 'b')
                    {
                        if(operand == 'a')
                        {
                            MyVector v = b - a;
                            cout << v << endl;
                        }
                        else if(operand == 'b')
                        {
                            MyVector v = b - b;
                            cout << v << endl;
                        }
                    }
                }
            }
        }
    }
    return 0;
}