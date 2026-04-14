package Week3;

import java.util.Scanner;
public class Practice1 {
    public static void main(String[] args)
    {
        Scanner keyboard = new Scanner(System.in);

        keyboard.useDelimiter("[,\r\n]");
        int a = keyboard.nextInt();
        int b = keyboard.nextInt();

        System.out.printf("dividend: %d%n", a);
        System.out.printf("divisor: %d%n", b);
        System.out.printf("quotient: %d%n", a / b);
        System.out.printf("remainder: %d%n", a % b);

    }
}
