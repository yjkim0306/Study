/* 221118 LAB 16 */
#include "my_vector2.cpp"
using namespace std;
int main()
{
    MyVector2* a = new MyVector2();
    MyVector2* b = new MyVector2();
    while(1)
    {
        string input;
        cin >> input;
        if(input == "quit") break;
        else if(input == "new")
        {
            int length;
            cin >> length;
            delete a;
            delete b;
            a = new MyVector2(length);
            b = new MyVector2(length);
            cout << "enter a\n";
            cin >> *a;
            cout << "enter b\n";
            cin >> *b;
        }
        else if(input == "a")
        {
            string op;
            cin >> op;
            if(op == "+")
            {
                char operand;
                cin >> operand;
                if(operand >= 48 && operand <= 57)
                {
                    MyVector2 v(*a + (operand - '0'));
                    cout << v << endl;
                }
                else if(operand == 'a')
                {
                    MyVector2 v(*a + (*a));
                    cout << v << endl;
                }
                else if(operand == 'b')
                {
                    MyVector2 v(*a + (*b));
                    cout << v << endl;
                }
            }
            else if(op == "-")
            {
                char operand;
                cin >> operand;
                if(operand >= 48 && operand <= 57)
                {
                    MyVector2 v(*a - (operand - '0'));
                    cout << v << endl;
                }
                else if(operand == 'a')
                {
                    MyVector2 v(*a - (*a));
                    cout << v << endl;
                }
                else if(operand == 'b')
                {
                    MyVector2 v(*a - (*b));
                    cout << v << endl;
                }
            }
        }
        else if(input == "b")
        {
            string op;
            cin >> op;
            if(op == "+")
            {
                char operand;
                cin >> operand;
                if(operand >= 48 && operand <= 57)
                {
                    MyVector2 v(*b + (operand - '0'));
                    cout << v << endl;
                }
                else if(operand == 'a')
                {
                    MyVector2 v(*b + (*a));
                    cout << v << endl;
                }
                else if(operand == 'b')
                {
                    MyVector2 v(*b + (*b));
                    cout << v << endl;
                }
            }
            else if(op == "-")
            {
                char operand;
                cin >> operand;
                if(operand >= 48 && operand <= 57)
                {
                    MyVector2 v(*b - (operand - '0'));
                    cout << v << endl;
                }
                else if(operand == 'a')
                {
                    MyVector2 v(*b - (*a));
                    cout << v << endl;
                }
                else if(operand == 'b')
                {
                    MyVector2 v(*b - (*b));
                    cout << v << endl;
                }
            }
        }
    }
    delete a;
    delete b;
    return 0;
}