package Assignment2;
import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;

public abstract class Cargo {
    protected int ID;
    protected int weight;
    public Cargo(){}
    public Cargo(int ID, int weight)
    {
        this.ID = ID;
        this.weight = weight;
    }

    public int getID(){return ID;}
    public int getWeight(){return weight;}
    public abstract double consumption(); // return fuel consumption required by the cargo
    public static void sortCargo(ArrayList<Cargo> c)
    {
        if(c.size() == 0)
            return;

        for (int i = 0; i < c.size(); i++)
        {
            int temp = i;
            for(int j = i; j < c.size(); j++)
            {
                if(c.get(j).getID() < c.get(i).getID())
                    temp = j;
            }
            if(temp != i)
            {
                Cargo tempCargo = c.get(i);
                c.set(i, c.get(temp));
                c.set(temp, tempCargo);
            }
        }

        ArrayList<Cargo> arrayList = new ArrayList<>();
        for(int i = 0; i < 4; i++)
        {
            for(int j = 0; j < c.size(); j++)
            {
                if(c.get(j).consumption() == 1.5 && i == 0)
                    arrayList.add(c.get(j));
                else if(c.get(j).consumption() == 2.5 && i == 1)
                    arrayList.add(c.get(j));
                else if(c.get(j).consumption() == 4.0 && i == 2)
                    arrayList.add(c.get(j));
                else if(c.get(j).consumption() == 3.5 && i == 3)
                    arrayList.add(c.get(j));
            }
        }
        c.clear();
        for(int i = 0; i < arrayList.size(); i++)
            c.add(arrayList.get(i));
    }
    // sorts the cargoes by ID then categorizes the cargoes by type
}