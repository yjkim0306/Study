package Week4;
import java.util.Scanner;
import java.util.Random;

public class Practice2 {
    static int status = 1;
    static int cnt = 0;
    public static void printFirst()
    {
        if(cnt == 0)
            System.out.print("insert action r(roll): ");
        else
            System.out.print("insert action r(roll), h(hold): ");
    }
    public static void printTurn(int status)
    {
        if(status == 1)
        {
            System.out.print("(You) ");
        }
        else if(status == 0)
        {
            System.out.print("(Computer) ");
        }
    }
    public static void changeTurn(int input)
    {
        if(input == 1)
            status--;
        else if(input == 0)
            status++;
        cnt = 0;
    }
    public static void main(String[] args)
    {
        Scanner sc = new Scanner(System.in);
        Random rnd = new Random();

        int score = 0;
        int YourScore = 0;
        int CPUScore = 0;

        while(true)
        {
            printTurn(status);
            printFirst();
            String command = "";
            if(status == 1)
            {
                command = sc.next();
                cnt++;
            }
            else if(status == 0)
            {
                if(score < 20)
                {
                    command = "r";
                    System.out.print(command);
                    System.out.printf("%n");
                }
                else
                {
                    command = "h";
                    System.out.print(command);
                    System.out.printf("%n");
                }

            }

            switch(command)
            {
                case "r":
                    int randomNum = rnd.nextInt(1, 6);
                    printTurn(status);
                    System.out.printf("dice rolled : %d\n", randomNum);
                    if(randomNum == 1)
                    {
                        printTurn(status);
                        System.out.printf("No score added%n");
                        printTurn(status);
                        System.out.printf("Your score %d, Computer score %d%n", YourScore, CPUScore);
                        System.out.printf("%n");
                        score = 0;
                        changeTurn(status);
                    }
                    else
                    {
                        score += randomNum;
                        cnt++;
                    }
                    break;
                case "h":
                    printTurn(status);
                    if(status == 1)
                    {
                        YourScore += score;
                        System.out.printf("%d added to You%n", score);
                    }
                    if(status == 0)
                    {
                        CPUScore += score;
                        System.out.printf("%d added to Computer%n", score);
                    }
                    printTurn(status);
                    System.out.printf("Your score %d, Computer score %d%n", YourScore, CPUScore);
                    System.out.printf("%n");
                    score = 0;
                    changeTurn(status);
                    break;
                default:
                    System.out.println("Please insert correct input.");
                    break;
            }

            if(YourScore >= 100)
            {
                System.out.printf("(Game) Your score %d, Computer score %d%n", YourScore, CPUScore);
                System.out.println("Congratulations! You win!");
                System.exit(0);
            }
            else if(CPUScore >= 100)
            {
                System.out.printf("(Game) Your score %d, Computer score %d%n", YourScore, CPUScore);
                System.out.println("Sorry, the computer wins.");
                System.exit(0);
            }

        }
    }
}
