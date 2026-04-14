import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class BinarySearch {
    public static int binarySearch(int A[], int start, int end, int x)
    {
        if(start <= end)
        {
            int middle = start + (end - start) / 2;
            if(A[middle] == x)
                return middle;
            if(A[middle] > x)
                return binarySearch(A, start, middle - 1, x);
            else
                return binarySearch(A, middle + 1, end, x);
        }
        return -1;
    }

    public static void main(String[] args) throws FileNotFoundException
    {
        Scanner sc = new Scanner(new File(args[0]));
        int[] arr = new int[100000];
        int[] input = new int[100];

        for(int i = 0; i < 100; i++)
            input[i] = sc.nextInt();
        for(int i = 0; i < 100000; i++)
            arr[i] = sc.nextInt();

        for(int i = 0; i < 100; i++)
            System.out.println("target: " + input[i] + "\t index: " + binarySearch(arr, 0, arr.length - 1, input[i]));
    }
}

