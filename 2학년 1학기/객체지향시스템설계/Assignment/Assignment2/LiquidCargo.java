package Assignment2;
public class LiquidCargo extends HeavyCargo
{
    public LiquidCargo()
    {
        super();
    }
    public LiquidCargo(int ID, int weight)
    {
        super(ID, weight);
    }

    public double consumption()
    {
        return 3.5;
    }
}
