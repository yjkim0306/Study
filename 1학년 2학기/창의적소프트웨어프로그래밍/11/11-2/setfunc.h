/* 221028 LAB 11 */
#include <iostream>
#include <set>
#include <string>
#pragma once
using namespace std;
class SetFunc
{
public:
    set<int> parseSet(const string& str);
    void printSet(const set<int>& s);
    set<int> getUnion(const set<int>& set0, const set<int>& set1);
    set<int> getIntersection(const set<int>& set0, const set<int>& set1);
    set<int> getDifference(const set<int>& set0, const set<int>& set1);
private:
    set<int> set_0;
    set<int> set_1;
};