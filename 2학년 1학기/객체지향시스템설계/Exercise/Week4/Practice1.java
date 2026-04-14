package Week4;

import java.util.Scanner;
public class Practice1 {
    public static String Palindrome(String s)
    {
        String ans = "";
        for(int i = 0; i < s.length(); i++)
        {
            String s1 = expand(s, i, i);
            if(s1.length() > ans.length())
                ans = s1;
            String s2 = expand(s, i, i + 1);
            if(s2.length() > ans.length())
                ans = s2;
        }
        return ans;
    }
    public static String expand(String str, int start, int end)
    {
        while(start >= 0 && end < str.length() && str.charAt(start) == str.charAt(end))
        {
            start--;
            end++;
        }
        return str.substring(start + 1, end);
    }
    public static void main(String[] args)
    {
        Scanner sc = new Scanner(System.in);
        System.out.println("Input string S :");
        String str = sc.nextLine();
        String ans = Palindrome(str);
        System.out.println("Longest Palindrome: " + ans);
    }
}