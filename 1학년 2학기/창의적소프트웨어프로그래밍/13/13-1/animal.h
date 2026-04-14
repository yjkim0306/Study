/* 221104 LAB 13 */
#include <iostream>
#include <string>
#include <vector>
using namespace std;
class Animal
{
protected:
    string name;
    int age;
public:
    Animal(string name_, int age_);
    virtual void printInfo();
};

class Zebra : public Animal
{
private:
    int numStripes;
public:
    Zebra(string name_, int age_, int numStripes_);
    void printInfo();
};

class Cat : public Animal
{
private:
    string favoriteToy;
public:
    Cat(string name_, int age_, string favoriteToy_);
    void printInfo();
};