package Assignment1;

import java.util.Scanner;
import java.util.Random;

public class main {
    public static void main(String[] args) {
        Scanner keyboard = new Scanner(System.in);
        int[] winningNum = new int[8];
        int[] randomNum = new int[8];
        int[] rank = new int[8];

        int N, M, remain = 0;
        while (true)
        {
            do {
                System.out.printf("Input your money and number of lottery tickets:%n<< ");
                N = keyboard.nextInt(); // user's money
                M = keyboard.nextInt(); // number of tickets

                if (N == 0 || M == 0)
                {
                    System.out.println(">> End of program");
                    System.exit(0);
                }

                N += remain;

                if(N - 10 * M < 0)
                    continue;
                remain = N - 10 * M;
            } while (N < 10 * M);

            System.out.print(">> Round Winning number : ");
            LotteryGenerator l = new LotteryGenerator();
            LotteryChecker m = new LotteryChecker();
            winningNum = l.randomGenerator();
            for (int i = 0; i < 6; i++)
                System.out.printf("%d ", winningNum[i]);
            System.out.printf("+ %d%n", winningNum[6]);
            while (true)
            {
                if (M == 0) break;

                randomNum = l.randomGenerator();

                System.out.print(">> Lottery number : ");
                for (int i = 0; i < 6; i++) {
                    System.out.printf("%d ", randomNum[i]);
                }
                System.out.printf("%s %s", m.win(winningNum, randomNum, m), m.printRank(winningNum, randomNum, m));
                System.out.print("\n");
                M--;
            }
            rank = m.getRankCount();

            System.out.printf(">> Remaining money : %d\n", remain);
            System.out.printf(">> 1st place: %d%n", rank[0]);
            System.out.printf(">> 2nd place: %d%n", rank[1]);
            System.out.printf(">> 3rd place: %d%n", rank[2]);
            System.out.printf(">> 4th place: %d%n", rank[3]);
        }
    }
}