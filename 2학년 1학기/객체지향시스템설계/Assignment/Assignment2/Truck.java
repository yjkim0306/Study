package Assignment2;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class Truck
{
    private int ID;
    private Warehouse currentWarehouse;
    private int totalWeight;
    private int maxNumOfAllCargoes;
    private int maxNumOfHeavyCargoes;
    private int maxNumOfDangerousCargoes;
    private int maxNumOfLiquidCargoes;
    private double fuel = 0.0;
    private double fuelPerKm;
    private ArrayList<Cargo> cargoes = new ArrayList<>();
    public Truck(){}

    public Truck(int ID, Warehouse w, int totalWeight, int maxNumOfAllCargoes, int maxNumOfHeavyCargoes, int maxNumOfDangerousCargoes, int maxNumOfLiquidCargoes, double fuelPerKm)
    {
        this.ID = ID;
        currentWarehouse = w;
        this.totalWeight = totalWeight;
        this.maxNumOfAllCargoes = maxNumOfAllCargoes;
        this.maxNumOfHeavyCargoes = maxNumOfHeavyCargoes;
        this.maxNumOfDangerousCargoes = maxNumOfDangerousCargoes;
        this.maxNumOfLiquidCargoes = maxNumOfLiquidCargoes;
        this.fuelPerKm = fuelPerKm;
    }

    public int getID() {return ID;}
    public Warehouse getCurrentWarehouse() {return currentWarehouse;}
    public double getFuel() {return fuel;}

    public ArrayList<Cargo> getCurrentCargoes()
    {
        Cargo.sortCargo(cargoes);
        return cargoes;
        // returns the list of all cargoes currently in the truck sorted by ID.
    }

    public boolean sailTo(Warehouse w)
    {
        double distance = currentWarehouse.getDistance(w);
        double totalConsumption = fuelPerKm;
        for(int i = 0; i < cargoes.size(); i++)
            totalConsumption += cargoes.get(i).consumption() * cargoes.get(i).weight;
        if(fuel >= distance * totalConsumption) {
            currentWarehouse.outgoingTruck(this);
            currentWarehouse = w;
            fuel -= totalConsumption * distance;
            currentWarehouse.incomingTruck(this);
            return true;
        }
        else
            return false;
        // return true if a truck successfully sailed to the destination warehouse.
    }

    public void reFuel(double amount)
    {
        fuel += amount;
        // adds fuel to a truck.
    }

    public boolean load(Cargo c) {
        int currentWeight = 0;
        int currentNumOfHeavyCargoes = 0, currentNumOfDangerousCargoes = 0, currentNumOfLiquidCargoes = 0;
        for (int i = 0; i < cargoes.size(); i++) {
            currentWeight += cargoes.get(i).getWeight();
            if (cargoes.get(i).consumption() == 2.5)
                currentNumOfHeavyCargoes++;
            else if (cargoes.get(i).consumption() == 3.5)
                currentNumOfLiquidCargoes++;
            else if (cargoes.get(i).consumption() == 4.0)
                currentNumOfDangerousCargoes++;
        }
        if (totalWeight >= c.getWeight() + currentWeight) {
            if (cargoes.size() + 1 <= maxNumOfAllCargoes) {
                if (c.consumption() == 1.5) { // basic cargo
                    currentWarehouse.getCargoes().remove(c);
                    cargoes.add(c);
                    return true;
                } else if (c.consumption() == 2.5 && currentNumOfHeavyCargoes + 1 <= maxNumOfHeavyCargoes && currentNumOfHeavyCargoes + currentNumOfDangerousCargoes + currentNumOfLiquidCargoes + 1 <= maxNumOfHeavyCargoes) { // heavy cargo
                    currentWarehouse.getCargoes().remove(c);
                    cargoes.add(c);
                    return true;
                } else if (c.consumption() == 3.5 && currentNumOfLiquidCargoes + 1 <= maxNumOfLiquidCargoes && currentNumOfHeavyCargoes + currentNumOfDangerousCargoes + currentNumOfLiquidCargoes + 1 <= maxNumOfHeavyCargoes) { // liquid cargo
                    currentWarehouse.getCargoes().remove(c);
                    cargoes.add(c);
                    return true;
                } else if (c.consumption() == 4.0 && currentNumOfDangerousCargoes + 1 <= maxNumOfDangerousCargoes && currentNumOfHeavyCargoes + currentNumOfDangerousCargoes + currentNumOfLiquidCargoes + 1 <= maxNumOfHeavyCargoes) { // dangerous cargo
                    currentWarehouse.getCargoes().remove(c);
                    cargoes.add(c);
                    return true;
                }
            }
        }
        return false;
        // return true if a cargo was successfully loaded to a truck
    }

    public boolean unload(Cargo c)
    {
        if(cargoes.contains(c))
        {
            cargoes.remove(c);
            currentWarehouse.cargoes.add(c);
            return true;
        }
        return false;
        // return true if a cargo was successfully unloaded from a truck
    }
}