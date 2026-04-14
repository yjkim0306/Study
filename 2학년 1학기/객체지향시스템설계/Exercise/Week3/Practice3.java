package Week3;

import java.util.Scanner;
public class Practice3 {
    public static void main(String[] args)
    {
        String item[] = new String[4];
        int quantity[] = new int[4];
        double price[] = new double[4];
        Scanner keyboard = new Scanner(System.in);
        Scanner keyboardString = new Scanner(System.in);
        keyboardString.useDelimiter("\n");

        for(int i = 1; i <= 3; i++)
        {
            System.out.printf("Enter name of item %d: %n", i);
            item[i] = keyboardString.nextLine();
            System.out.printf("Enter quantity of item %d: %n", i);
            quantity[i] = keyboard.nextInt();
            System.out.printf("Enter price of item %d: %n", i);
            price[i] = keyboard.nextDouble();
        }

        System.out.println("Your bill:");
        System.out.printf("%n");
        System.out.printf("%-30s%-10s%-10s%-10s%n", "ITEM", "QUANTITY", "PRICE", "TOTAL");
        double subtotal = 0;

        for(int i = 1; i <= 3; i++)
        {
            System.out.printf("%-30s%-10d%-10.2f%-10.2f%n",item[i], quantity[i], price[i], quantity[i] * price[i]);
            subtotal += quantity[i] * price[i];
        }
        
        System.out.printf("%n");
        System.out.printf("%-50s%-10.2f%n", "SUBTOTAL", subtotal);
        System.out.printf("%-50s%-10.2f%n", "6.25% SALES TAX", subtotal * 0.0625);
        System.out.printf("%-50s%-10.2f%n", "TOTAL", subtotal * 1.0625);
    }
}
