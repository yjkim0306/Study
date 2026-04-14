/* 221110 LAB 14 */
#include "shape.cpp"
using namespace std;
int main()
{
    ios::sync_with_stdio(false);
    cin.tie();
    cout.tie();
    vector<Shape*> arr;
    while(1)
    {
        char input;
        double w, h;
        cin >> input;
        if(input == '0') 
        {
            for(int i = 0; i < arr.size(); i++)
            {
                cout << arr[i]->getArea() << "\n";
            }
            break;
        }
        else if(input == 'r')
        {
            cin >> w >> h;
            arr.push_back(new Rectangle(w,h));
        }
        else if(input == 't')
        {
            cin >> w >> h;
            arr.push_back(new Triangle(w, h));
        } 
   }
   for(int i = 0; i < arr.size(); i++)
   {
    delete arr[i];
   }
   return 0;
}