package Week13;

public class ComplexNumber {
    protected RealNumber real;
    protected RealNumber imaginary;
    public ComplexNumber(RealNumber real, RealNumber imaginary)
    {
        this.real = real;
        this.imaginary = imaginary;
    }
    public static class RealNumber
    {
        protected int dividend;
        protected int divisor;
        public RealNumber(int dividend, int divisor)
        {
            this.dividend = dividend;
            this.divisor = divisor;
        }
        public String toString()
        {
            return dividend + "/" + divisor;
        }
    }

}
