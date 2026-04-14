package Assignment2;
public class BasicCargo extends Cargo // Weight 1000kg 이하
{
    public BasicCargo()
    {
        super();
    }
    public BasicCargo(int ID, int weight)
    {
        super(ID, weight);
    }

    public double consumption()
    {
        return 1.5;
    }
}
