package Week14.Practice1;
import java.util.ArrayList;

public class Eratos {
    public static ArrayList<Integer> sieve(int n)
    {
        ArrayList<Integer> arr = new ArrayList<>(n);

        for(int i = 1; i <= n; i++)
            arr.add(0);
        boolean[] prime = new boolean[n + 1];
        prime[1] = true;

        for(int i = 2; i <= n; i++)
        {
            for(int j = 2; i * j <= n; j++)
                prime[i * j] = true;
        }

        for(int i = 1; i <= n; i++)
            if(!prime[i])
                arr.set(i, i);
        return arr;
    }
}
