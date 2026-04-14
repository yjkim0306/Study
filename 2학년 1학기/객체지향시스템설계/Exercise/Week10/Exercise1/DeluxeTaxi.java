package Week10.Practice1;

public class DeluxeTaxi extends Taxi{
    private double farePerKilometer;
    private double baseDistance;
    private double baseFee;
    public DeluxeTaxi(int carNum, double ratePerKilometer)
    {
        super(carNum);
        farePerKilometer = ratePerKilometer;
        baseDistance = 3.0;
        baseFee = 5.0;
    }

    public String toString()
    {
        return super.toString() + (" Fare per km: " + farePerKilometer + ", Base distance: " + baseDistance + ", Base fee: " + baseFee);
    }

    public double getPaid(double dis)
    {
        if(dis < baseDistance)
            return baseFee;
        else
            return baseFee + farePerKilometer * (dis - baseDistance);
    }
}
