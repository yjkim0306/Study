package Assignment2;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Scanner;
import java.util.ArrayList;
public class Main {
    public static void main(String[] args) throws FileNotFoundException {

        // Generate a new Scanner object to access data from the input file in the directory indicated by "args[0]".
        Scanner in = new Scanner(new File(args[0]));

        // Your Implementation

        int N = in.nextInt();
        ArrayList<Truck> truck = new ArrayList<>();
        ArrayList<Warehouse> warehouse = new ArrayList<>();
        ArrayList<Cargo> cargo = new ArrayList<>();

        int countCargo = 0, countWarehouse = 0, countTruck = 0;
        for (int i = 0; i < N; i++)
        {
            int eventID = in.nextInt();
            Cargo tempCargo = null;
            switch(eventID)
            {
                case 1: // Create a cargo
                    int warehouseID = in.nextInt();
                    int weight = in.nextInt();
                    String str = in.nextLine();
                    if(str.equals(" L")) {
                        tempCargo = new LiquidCargo(countCargo, weight);
                        warehouse.get(warehouseID).getCargoes().add(tempCargo);
                        cargo.add(tempCargo);
                        countCargo++;
                    }
                    else if(str.equals(" D")) {
                        tempCargo = new DangerousCargo(countCargo, weight);
                        warehouse.get(warehouseID).getCargoes().add(tempCargo);
                        cargo.add(tempCargo);
                        countCargo++;
                    }
                    else{
                        if(weight <= 1000) {
                            tempCargo = new BasicCargo(countCargo, weight);
                        }
                        else
                        {
                            tempCargo = new HeavyCargo(countCargo, weight);
                        }
                        warehouse.get(warehouseID).getCargoes().add(tempCargo);
                        cargo.add(tempCargo);
                        countCargo++;
                    }
                    break;

                case 2: // Create a truck
                    warehouseID = in.nextInt();
                    Warehouse w = warehouse.get(warehouseID);
                    int totalWeight = in.nextInt();
                    int maxNumOfAllCargoes = in.nextInt();
                    int maxNumOfHeavyCargoes = in.nextInt();
                    int maxNumOfDangerousCargoes = in.nextInt();
                    int maxNumOfLiquidCargoes = in.nextInt();
                    double fuelPerKm = in.nextDouble();
                    Truck tempTruck = new Truck(countTruck, w, totalWeight, maxNumOfAllCargoes, maxNumOfHeavyCargoes, maxNumOfDangerousCargoes, maxNumOfLiquidCargoes, fuelPerKm);
                    warehouse.get(warehouseID).getCurrent().add(tempTruck);
                    truck.add(tempTruck);
                    countTruck++;
                    break;

                case 3: // Create a warehouse
                    double x_Coordinate = in.nextDouble();
                    double y_Coordinate = in.nextDouble();
                    Warehouse tempWarehouse = new Warehouse(countWarehouse, x_Coordinate, y_Coordinate);
                    warehouse.add(tempWarehouse);
                    countWarehouse++;
                    break;

                case 4: // Load a cargo to a truck
                    int truckID = in.nextInt();
                    int cargoID = in.nextInt();
                    if (!truck.get(truckID).load(cargo.get(cargoID))) {
                        System.out.printf("[Error]: Cannot load cargo number %d into truck %d.%n", cargoID, truckID);
                        break;
                    }

                    break;

                case 5: // Unload a cargo from a truck
                    truckID = in.nextInt();
                    cargoID = in.nextInt();
                    if(!truck.get(truckID).unload(cargo.get(cargoID)))
                    {
                        System.out.printf("[Error]: Cannot unload cargo #%d from truck #%d.%n", cargoID, truckID);
                        break;
                    }
                    break;

                case 6: // Truck moves to another warehouse
                    truckID = in.nextInt();
                    warehouseID = in.nextInt();
                    if(!truck.get(truckID).sailTo(warehouse.get(warehouseID)))
                    {
                        System.out.printf("[Error]: Cannot move truck #%d from warehouse #%d to warehouse #%d.%n", truckID, truck.get(truckID).getCurrentWarehouse().getID(), warehouseID);
                        break;
                    }
                    break;

                case 7: // Refuel a truck
                    truckID = in.nextInt();
                    double fuel = in.nextDouble();
                    truck.get(truckID).reFuel(fuel);
                    break;

                default:
                    System.out.println("[Error]: Invalid event ID");
                    break;
            }
        }

        // Close the Scanner object.
        in.close();

        // Generate a new PrintStream object to output data to the file in the directory indicated by "args[1]"
        PrintStream out = new PrintStream(new File(args[1]));
        // Print the string to the output file.

        for(int i = 0; i < warehouse.size(); i++)
        {
            out.printf("Warehouse %d: (%.1f, %.1f)%n", i, warehouse.get(i).getX(), warehouse.get(i).getY());
            ArrayList<Cargo> tempCargo = new ArrayList<>();
            tempCargo.addAll(warehouse.get(i).getCargoes());
            while(tempCargo.size() != 0)
            {
                if(tempCargo.get(0).consumption() == 1.5)
                {
                    out.print("  BasicCargo:");
                    while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 1.5){
                        out.printf(" %d", tempCargo.get(0).getID());
                        tempCargo.remove(0);
                    }
                    out.println();
                }
                else if(tempCargo.get(0).consumption() == 2.5)
                {
                    out.print("  HeavyCargo:");
                    while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 2.5){
                        out.printf(" %d", tempCargo.get(0).getID());
                        tempCargo.remove(0);
                    }
                    out.println();
                }
                else if(tempCargo.get(0).consumption() == 4.0)
                {
                    out.print("  DangerousCargo:");
                    while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 4.0){
                        out.printf(" %d", tempCargo.get(0).getID());
                        tempCargo.remove(0);
                    }
                    out.println();
                }
                else if(tempCargo.get(0).consumption() == 3.5)
                {
                    out.print("  LiquidCargo:");
                    while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 3.5){
                        out.printf(" %d", tempCargo.get(0).getID());
                        tempCargo.remove(0);
                    }
                    out.println();
                }
            }
            ArrayList<Truck> tempTruck = new ArrayList<>();
            tempTruck.addAll(warehouse.get(i).getCurrent());

            if(tempTruck.size() != 0)
            {
                for(int j = 0; j < tempTruck.size(); j++)
                {
                    out.printf("  Truck %d: %.1f%n", tempTruck.get(j).getID(), tempTruck.get(j).getFuel());
                    tempCargo.clear();
                    tempCargo.addAll(tempTruck.get(j).getCurrentCargoes());
                    while(tempCargo.size() != 0)
                    {
                        if(tempCargo.get(0).consumption() == 1.5)
                        {
                            out.print("    BasicCargo:");
                            while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 1.5) {
                                out.printf(" %d", tempCargo.get(0).getID());
                                tempCargo.remove(0);
                            }
                        out.println();
                        }
                        else if(tempCargo.get(0).consumption() == 2.5)
                        {
                            out.print("    HeavyCargo:");
                            while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 2.5) {
                                out.printf(" %d", tempCargo.get(0).getID());
                                tempCargo.remove(0);
                            }
                            out.println();
                        }
                        else if(tempCargo.get(0).consumption() == 4.0)
                        {
                            out.print("    DangerousCargo:");
                            while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 4.0) {
                                out.printf(" %d", tempCargo.get(0).getID());
                                tempCargo.remove(0);
                            }
                            out.println();
                        }
                        else if(tempCargo.get(0).consumption() == 3.5)
                        {
                            out.print("    LiquidCargo:");
                            while(tempCargo.size() != 0 && tempCargo.get(0).consumption() == 3.5) {
                                out.printf(" %d", tempCargo.get(0).getID());
                                tempCargo.remove(0);
                            }
                            out.println();
                        }
                    }
                }
            }
        }

        // Close the PrintStream object.
        out.close();
    }
}