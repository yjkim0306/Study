package Week7;
import java.util.Scanner;
import java.util.Random;
public class Practice2 {
    public static void printArray(int[][] arr, boolean[][] match)
    {
        System.out.printf("%7d%5d%5d%5d%n", 1, 2, 3, 4);

        for(int i = 1; i <= 4; i++)
        {
            System.out.printf("%d ", i);
            for(int j = 1; j <= 4; j++)
            {
                if(match[i][j] == true)
                {
                    System.out.printf("%5d", arr[i][j]);
                }
                else if(match[i][j] == false)
                {
                    System.out.printf("%5c", '*');
                }
            }
            System.out.println();
        }
    }
    public static void main(String[] args)
    {
        Scanner sc = new Scanner(System.in);
        Random rnd = new Random();

        int[][] arr = new int[5][5];
        boolean[][] match = new boolean[5][5];
        int[] temp = new int[16];
        int x1, y1, x2, y2, idx = 0;

        for(int i = 0; i < 16; i++)
        {
            int cnt = 0;
            temp[i] = rnd.nextInt(1, 9);
            for(int j = 0; j < i; j++)
            {
                if(temp[i] == temp[j] && cnt == 0)
                {
                    cnt++;
                    continue;
                }
                if(temp[i] == temp[j] && cnt == 1)
                {
                    i--;
                    cnt = 0;
                }
            }
        }

        for(int i = 1; i <= 4; i++)
        {
            for(int j = 1; j <= 4; j++)
            {
                arr[i][j] = temp[idx++];
//                    System.out.printf("%d ", arr[i][j]);
            }
//                System.out.println();
        }

        int exitVar = 0;
        while(true)
        {
            System.out.print("Enter Coordinate: ");
            x1 = sc.nextInt();
            y1 = sc.nextInt();
            x2 = sc.nextInt();
            y2 = sc.nextInt();

            if (arr[x1][y1] == arr[x2][y2])
            {
                match[x1][y1] = true;
                match[x2][y2] = true;
                System.out.printf("%d == %d%n", arr[x1][y1], arr[x2][y2]);
                exitVar += 2;
                printArray(arr, match);
            }

            else if (arr[x1][y1] != arr[x2][y2])
            {
                System.out.printf("%d != %d%n", arr[x1][y1], arr[x2][y2]);
                printArray(arr, match);
            }

            if(exitVar == 16)
            {
                System.exit(0);
            }

            System.out.println();
        }
    }
}
