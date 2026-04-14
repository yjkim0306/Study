package Assignment1;

import java.util.Random;

public class LotteryGenerator {
    public static int[] randomGenerator()
    {
        int[] arr = new int[8];
        Random rnd = new Random();
        for (int i = 0; i < 7; i++)
        {
            arr[i] = rnd.nextInt(20) + 1;
            for (int j = 0; j < i; j++)
            {
                if (arr[i] == arr[j])
                    i--;
            }
        }
        return arr;
    }
}
