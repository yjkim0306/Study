/* 221013 LAB 8 */
//main.cpp
#include <iostream>
#include <string>
#include "accounts.h"
using namespace std;
int main()
{
    AccountManager WooriBank;
    char input;
    int len = -1, user, to_user, amnt;
    while(1)
    {
        cout << "Job?" << "\n";
        cin >> input;
        if(input != 'N' && len < 0)
        {
            cin >> user >> amnt;
            cout << "Account does not exist" << "\n";
        }
        else if(input == 'N') 
        {
            len++;
            if(len > 9)
            {
                cout << "Maximum number of accounts is 10\n" << "\n";
                continue;
            }
            cout << "Account for user " << len << " registered" << "\n";
            WooriBank.check(len);
        }
        else if(input == 'D')
        {
            cin >> user >> amnt;
            WooriBank.deposit(user, amnt);
            WooriBank.check(user);
        }
        else if(input == 'W')
        {
            cin >> user >> amnt; 
            WooriBank.withdraw(user, amnt);
            WooriBank.check(user);
        }
        else if(input == 'T')
        {
            cin >> user >> to_user >> amnt;
            if(user > len || to_user > len)
            {
                cout << "Account does not exist\n" << "\n";
                continue;
            }
            else
            {
                WooriBank.transfer(user, to_user, amnt);
                if(user > to_user)
                {
                    WooriBank.check(to_user);
                    WooriBank.check(user);
                }
                else
                {
                    WooriBank.check(user);
                    WooriBank.check(to_user);
                }
            }
        }
        else if(input == 'Q') break;
        cout << "\n";
    }
    return 0;
}