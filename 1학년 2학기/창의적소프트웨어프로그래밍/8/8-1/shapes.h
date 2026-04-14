//shapes.h
#pragma once
class Circle
{
private:
    int x_; //원의 중심의 x좌표
    int y_; //원의 중심의 y좌표
    int r_; //반지름
public:
    void cset(int x, int y, int r);
    void cArea();
    void cPerimeter();
};

class Rectangle
{
private:
    int x1_; //좌상단 x좌표
    int y1_; //좌상단 y좌표
    int x2_; //우하단 x좌표
    int y2_; //우하단 y좌표
public:
    void rset(int x1, int y1, int x2, int y2);
    void rArea();
    void rPerimeter();
};