/* 221013 LAB 8 */
#include <iostream>
#include "minimal_fighter.h"
using namespace std;

MinimalFighter::MinimalFighter()
{
    mHp = 0;
    mPower = 0;
    mStatus = Invalid;
}
MinimalFighter::MinimalFighter(int _hp, int _power)
{
    if(_hp > 0) mStatus = Alive;
    else if(_hp <= 0) mStatus = Dead;
    mHp = _hp;
    mPower = _power;
}
int MinimalFighter::hp()
{
    return mHp;
}

int MinimalFighter::power()
{
    return mPower;
}

FighterStatus MinimalFighter::status()
{
    return mStatus;
}

void MinimalFighter::setHp(int _hp)
{
    if(_hp <= 0)
    {
        mStatus = Dead;
    }
    else mStatus = Alive;
    mHp = _hp;
}
void MinimalFighter::hit(MinimalFighter* _enemy)
{
    int temp = _enemy->hp();
    temp = temp - mPower;
    _enemy->setHp(temp);
    mHp = mHp - _enemy->power();
}

void MinimalFighter::attack(MinimalFighter* _enemy)
{
    int temp = _enemy->hp();
    temp = temp - mPower;
    _enemy->setHp(temp);
    mPower = 0;
}

void MinimalFighter::fight(MinimalFighter* _enemy)
{
    int temp = _enemy->hp();
    while(mHp > 0 && temp > 0)
    {
        mHp = mHp - _enemy->power();
        temp = temp - mPower;
    }
    setHp(mHp);
    _enemy->setHp(temp);
}