package Week7;
import java.util.Scanner;

public class Practice1 {
    public static int[][] drawSnail(int n) {
        int idx = 1;
        int print = n;
        int right = -1;
        int bottom = 0;
        int top = 1;
        int[][] arr = new int[n][n];
        for(int i = n; i > 0; i--)
        {
            for(int j = 0; j < print; j++)
            {
                right += top;
                arr[bottom][right] = idx;
                idx++;
            }

            print--;

            for(int j = 0; j < print; j++)
            {
                bottom += top;
                arr[bottom][right] = idx;
                idx++;
            }

            top = top * (-1);
        }

        return arr;
    }

    public static void main(String[] args) {
        int n;
        Scanner sc = new Scanner(System.in);
        n = sc.nextInt();
        int[][] arr = new int[n][n];
        arr = drawSnail(n);

        for(int i = 0; i < n; i++)
        {
            for(int j = 0; j < n; j++)
            {
                System.out.printf("%d ", arr[i][j]);
            }
            System.out.println();
        }
    }
}