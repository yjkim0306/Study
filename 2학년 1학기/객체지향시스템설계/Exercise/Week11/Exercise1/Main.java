package Week11.Practice1;
import java.util.InputMismatchException;
import java.util.Scanner;
public class Main {
    public static boolean isCoprime(int a, int b) throws MyException
    {
        while(true)
        {
            int q = a / b;
            int r = a % b;
            if(r == 0)
                break;
            a = b;
            b = r;
        }

        if(b == 1)
            return true;
        return false;
    }

    public static void main(String[] args)
    {
        Scanner sc = new Scanner(System.in);
        try
        {
            System.out.println("Enter two numbers: ");
            int a = sc.nextInt();
            int b = sc.nextInt();

            if(a <= 1 || b <= 1)
                throw new MyException("Either a or b is less than or equal to 1; Enter a number larger than 1.");
            else if(a == b)
                throw new MyException("a and b are the same number; Enter different numbers for a and b.");
            else if(a > 10000 && b > 10000)
                throw new MyException("Both a and b are larger than 10000; Try smaller numbers.");

            if(isCoprime(a, b))
                System.out.println(a + " and " + b + " are coprime.");
            else
                System.out.println(a + " and " + b + " are not coprime.");
        }
        catch(InputMismatchException e)
        {
            System.out.println("Not a correctly written whole number; You must enter an integer.");
            System.exit(0);
        }
        catch(MyException e)
        {
            System.out.println(e.getMessage());
            System.exit(0);
        }
    }
}
