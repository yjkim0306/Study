/* 221104 LAB 13 */
#include "animal.h"

inline Animal::Animal(string name_, int age_)
{
    name = name_;
    age = age_;
}

inline Zebra::Zebra(string name_, int age_, int numStripes_) : Animal(name_, age_)
{
    name = name_;
    age = age_;
    numStripes = numStripes_;
}

inline Cat::Cat(string name_, int age_, string favoriteToy_) : Animal(name_,age_)
{
    name = name_;
    age = age_;  
    favoriteToy = favoriteToy_;  
}
inline void Animal::printInfo() {}

inline void Zebra::printInfo()
{
    std::cout << "Zebra, Name: " << name << ", Age: " << age << ", Number of stripes: " << numStripes << std::endl;
}

inline void Cat::printInfo()
{
    std::cout << "Cat, Name: " << name << ", Age: " << age << ", Favorite toy: " << favoriteToy << std::endl;
}