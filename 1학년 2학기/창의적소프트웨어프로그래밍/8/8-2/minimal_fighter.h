// minimal_fighter.h
// Implement your minimal_fighter.cpp

#ifndef __minimal_fighter__
#define __minimal_fighter__
#include <iostream>
using namespace std;

enum EFighterStatus
{
    Invalid = 0,
    
    Alive,
    Dead,
};
typedef enum EFighterStatus FighterStatus;

class MinimalFighter
{
private:
    int mHp; //Health point
    int mPower; //Attack power
    FighterStatus mStatus; //Invalid, Alive, or Dead

public:
    MinimalFighter();
    MinimalFighter(int _hp, int _power);
    int hp(); //get mHp
    int power(); //get mPower
    FighterStatus status(); //get mStatus
    void setHp(int _hp); //set mHp
    void hit(MinimalFighter* _enemy); //run Hit command
    void attack(MinimalFighter* _enemy); //run Attack command
    void fight(MinimalFighter* _enemy); //run Fight command
};

#endif
