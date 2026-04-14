package Assignment1;

public class LotteryChecker {
    private int[] rankCount = new int[4];
    public int[] getRankCount()
    {
        return rankCount;
    }
    public int Checker(int[] winningNum, int[] randomNum)
    {
        int cnt = 0, rank = 1;
        for(int i = 0; i < 5; i++)
        {
            for(int j = 0; j < 5; j++)
            {
                if(winningNum[i] == randomNum[j])
                    cnt++;
            }
    }
        switch(cnt)
        {
            case 6:
                rank = 1;
                break;
            case 5:
                for(int i = 0; i < 5; i++)
                {
                    if(randomNum[i] == winningNum[6])
                        rank = 1;
                    else
                        rank = 2;
                }
                break;
            case 4:
                for(int i = 0; i < 5; i++)
                {
                    if(randomNum[i] == winningNum[6])
                        rank = 2;
                    else
                        rank = 3;
                }
                break;
            case 3:
                for(int i = 0; i < 5; i++)
                {
                    if(randomNum[i] == winningNum[6])
                        rank = -1;
                    else
                        rank = 4;
                }
                break;
            default:
                rank = -1;
        }
        return rank;
    }

    public String win(int[] winningNum, int[] randomNum, LotteryChecker l)
    {
        if(l.Checker(winningNum, randomNum) <= 4 && l.Checker(winningNum, randomNum) >= 1)
            return "Winner";
        else
            return "Lose";
    }
    public String printRank(int[] winningNum, int[] randomNum, LotteryChecker l)
    {
        if (l.Checker(winningNum, randomNum) == 1)
        {
            rankCount[0]++;
            return "(1st place)";
        }
        else if (l.Checker(winningNum, randomNum) == 2)
        {
            rankCount[1]++;
            return "(2nd place)";
        }
        else if (l.Checker(winningNum, randomNum) == 3)
        {
            rankCount[2]++;
            return "(3rd place)";
        }
        else if (l.Checker(winningNum, randomNum) == 4)
        {
            rankCount[3]++;
            return "(4th place)";
        }
        return "";
    }

}