package Week11.Practice2;
import java.util.Scanner;
public class Main {
    public static void main(String[] args)
    {
        boolean done = false;
        while(!done) {
            try{
                Scanner sc = new Scanner(System.in);
                System.out.print("Enter ID: ");
                String ID = sc.nextLine();
                System.out.print("Enter Account number: ");
                int account_num = sc.nextInt();
                System.out.print("Enter Account balance: ");
                int balance = sc.nextInt();
                Account account = new Account(ID, account_num, balance);
                System.out.println(account.toString());
                done = true;
            }
            catch(Exception e)
            {
                System.out.println(e.getMessage() + " Try again!");
            }
        }
    }
}
