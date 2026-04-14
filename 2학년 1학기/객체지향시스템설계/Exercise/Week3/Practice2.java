package Week3;

import java.util.Scanner;
public class Practice2 {
    public static void main(String[] args)
    {
        Scanner keyboard = new Scanner(System.in);

        int score = keyboard.nextInt();
        int GPA = score * 4 / 100;

        System.out.printf("(%d/100)*4=%d", score, GPA);
    }
}
