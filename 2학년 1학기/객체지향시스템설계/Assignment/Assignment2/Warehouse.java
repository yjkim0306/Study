package Assignment2;
import java.util.ArrayList;
public class Warehouse
{
    private int ID;
    private double X;
    private double Y;
    public ArrayList<Cargo> cargoes = new ArrayList<>();
    private ArrayList<Truck> history = new ArrayList<>(); // keeps track of every truck that has visited
    private ArrayList<Truck> current = new ArrayList<>(); // keeps track of the truck currently here

    public Warehouse() {}
    public Warehouse(int ID)
    {
        this.ID = ID;
    }
    public Warehouse(int ID, double X, double Y)
    {
        this.ID = ID;
        this.X = X;
        this.Y = Y;
    }

    public int getID() {return ID;}
    public double getX() {return X;}
    public double getY() {return Y;}
    public ArrayList<Cargo> getCargoes() {
        Cargo.sortCargo(cargoes);
        return cargoes;
    }
    public ArrayList<Truck> getHistory(){return history;}
    public ArrayList<Truck> getCurrent(){return current;}
    public double getDistance(Warehouse other)
    {
        return Math.sqrt(Math.pow(X - other.getX(), 2) + Math.pow(Y - other.getY(), 2));
        // calculate the distance between the object itself and another Warehouse.
    }

    public void incomingTruck(Truck t)
    {
        if(!current.contains(t))
            current.add(t);
        else
            System.out.println("Truck is already in the warehouse.");
        // add this truck to current ArrayList.
    }

    public void outgoingTruck(Truck t)
    {
        if(!history.contains(t) && current.contains(t)) {
            history.add(t);
            current.remove(t);
        }
        else
            System.out.println("Truck has already been in the warehouse before.");
        // add this truck to history ArrayList.
    }
}
