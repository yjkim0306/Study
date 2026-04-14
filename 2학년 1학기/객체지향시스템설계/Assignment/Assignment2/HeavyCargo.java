package Assignment2;
public class HeavyCargo extends Cargo // Weight 1000kg 초하
{
    public HeavyCargo(){
        super();
    }
    public HeavyCargo(int ID, int weight)
    {
        super(ID, weight);
    }

    public double consumption()
    {
        return 2.5;
    }
}
