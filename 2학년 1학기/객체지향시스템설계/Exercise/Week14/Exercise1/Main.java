package Week14.Practice1;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Iterator;
public class Main {
    public static void main(String[] args)
    {
        Scanner sc = new Scanner(System.in);
        System.out.print("Input max number: ");
        int n = sc.nextInt();

        ArrayList<Integer> printArray = Eratos.sieve(n);
        Iterator<Integer> i = printArray.iterator();
        while(i.hasNext()) {
            int j = i.next();
            if (j != 0)
                System.out.print(j + " ");
        }
    }
}