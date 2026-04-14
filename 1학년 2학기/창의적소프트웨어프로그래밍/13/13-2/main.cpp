/* 221104 LAB 13 */
#include <iostream>
#include <string>
#include <vector>
#include "canvas.h"
using namespace std;
int main()
{
    vector<Shape*> shapes;
    vector<string> v_string;
    int width, height;
    cin >> width >> height;
    Canvas* canvas = new Canvas(width, height);
    canvas->Print();
    while(1)
    {
        string input;
        cin >> input;
        if(input == "quit") break;
        else if(input == "add")
        {
            string shape;
            cin >> shape;
            if(shape == "rect")
            {
                int x_, y_, width_, height_;
                char brush_;
                cin >> x_ >> y_ >> width_ >> height_ >> brush_;
                shapes.push_back(new Rectangle(x_, y_, width_, height_, brush_));
                string space = "";
                space = shape + " " + to_string(x_) + " " + to_string(y_) + " " + to_string(width_) + " " + to_string(height_) + " " + brush_;
                v_string.push_back(space);
            }
            else if(shape == "tri_down")
            {
                int x_, y_, height_;
                char brush_;
                cin >> x_ >> y_ >> height_ >> brush_;
                shapes.push_back(new DownTriangle(x_, y_, height_, brush_));
                string space = "";
                space = shape + " " + to_string(x_) + " " + to_string(y_) + " " + to_string(height_) + " " + brush_;
                v_string.push_back(space);
            }
            else if(shape == "tri_up")
            {
                int x_, y_, height_;
                char brush_;
                cin >> x_ >> y_ >> height_ >> brush_;
                shapes.push_back(new UpTriangle(x_, y_, height_, brush_));
                string space = "";
                space = shape + " " + to_string(x_) + " " + to_string(y_) + " " + to_string(height_) + " " + brush_;
                v_string.push_back(space);
            }
            else if(shape == "diamond")
            {
                int x_, y_, height_;
                char brush_;
                cin >> x_ >> y_ >> height_ >> brush_;
                shapes.push_back(new Diamond(x_, y_, height_, brush_));
                string space = "";
                space = shape + " " + to_string(x_) + " " + to_string(y_) + " " + to_string(height_) + " " + brush_;
                v_string.push_back(space);
            }
        }
        else if(input == "dump")
        {
            for(int i = 0; i < v_string.size(); i++)
            {
                cout << i << " " << v_string[i] << endl;
            }
        }
        else if(input == "draw")
        {
            
            for(int i = 0; i < shapes.size(); i++)
            {
                shapes[i]->Draw(canvas);
            }
            canvas->Print();
        }
    }
    delete canvas;
    for(int i = 0; i < shapes.size(); i++)
    {
        delete shapes[i];
    }
    return 0;
}