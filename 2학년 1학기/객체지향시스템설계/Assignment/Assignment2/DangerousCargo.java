package Assignment2;
public class DangerousCargo extends HeavyCargo
{
    public DangerousCargo()
    {
        super();
    }
    public DangerousCargo(int ID, int weight)
    {
        super(ID, weight);
    }

    public double consumption()
    {
        return 4.0;
    }
}
