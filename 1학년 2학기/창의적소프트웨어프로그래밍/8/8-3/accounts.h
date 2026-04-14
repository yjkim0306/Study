/* 221013 LAB 8*/
//accounts.h
#pragma once
#include <iostream>
using namespace std;

class Account
{
public:
    int ID = 0;
    int balance = 0;
};

class AccountManager
{
public:
    Account acc[10];
    void deposit(int user, int amount);
    void withdraw(int user, int amount);
    void transfer(int user, int to_user, int amount);
    void check(int user);
};