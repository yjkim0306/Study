package Week10.Practice1;

public abstract class Taxi {
    protected int carNum;
    protected double distance;
    protected double income;

    public Taxi(int carNum)
    {
        this.carNum = carNum;
        distance = 0.0;
        income = 0.0;
    }

    public String toString()
    {
        return ("Taxi number: " + carNum + ", Total driving distance: " + distance + ", Income: " + income);
    }

    public abstract double getPaid(double distance);
    public void doDrive(double dis)
    {
        distance += dis;
        income += getPaid(dis);
    }
    public boolean earnMore(Taxi t)
    {
        if(income > t.income)
            return true;
        else
            return false;
    }
}
