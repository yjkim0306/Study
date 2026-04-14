/* 221013 LAB 8 */
//accounts.cpp
#include <iostream>
#include "accounts.h"
using namespace std;
void AccountManager::deposit(int user, int amount)
{
    if(acc[user].balance + amount > 1000000)
    {
        cout << "Failure: Deposit to user " << user << " " << amount << "\n";
    }
    else
    {
        acc[user].balance += amount;
        cout << "Success: Deposit to user " << user << " " << amount << "\n";
    }
}
void AccountManager::withdraw(int user, int amount)
{
    if(acc[user].balance < amount)
    {
        cout << "Faliure: Withdraw from user " << user << " " << amount << "\n";
    }
    else
    {
        acc[user].balance -= amount;
        cout << "Success: Withdraw from user " << user << " " << amount << "\n";
    }
}
void AccountManager::transfer(int user, int to_user, int amount)
{
    if(acc[user].balance < amount)
    {
        cout << "Failure: Transfer from user " << user << " to " << to_user << " " << amount << "\n";
    }
    else if(acc[to_user].balance + amount > 1000000)
    {
        cout << "Failure: Transfer from user " << user << " to " << to_user << " " << amount << "\n";
    }
    else
    {
        acc[user].balance -= amount;
        acc[to_user].balance += amount;
        cout << "Success: Transfer from user " << user << " to " << to_user << " " << amount << "\n";
    }
}
void AccountManager::check(int user)
{
    cout << "Balance of user " << user << ": " << acc[user].balance << "\n";
}