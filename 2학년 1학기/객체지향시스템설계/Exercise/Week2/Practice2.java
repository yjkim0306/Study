package Week2;

public class Practice2 {
    public static void main(String[] args)
    {
        String input = "Walt Savitch";
        String output = null;

        int endIdx = 0;
        for(int i = 0; i < input.length(); i++)
        {
            if(input.charAt(i) == ' ')
            {
                break;
            }
            else
                endIdx++;
        }

        String temp1 = input.substring(0, endIdx);
        String temp2 = input.substring(endIdx + 1);

        temp1 = temp1.toLowerCase();
        temp2 = temp2.toLowerCase();

        String a = temp1.substring(1, 2);
        String b = temp2.substring(1, 2);

        a = a.toUpperCase();
        b = b.toUpperCase();

        temp1 = a + temp1.substring(2) + temp1.charAt(0) + "ay";
        temp2 = b + temp2.substring(2) + temp2.charAt(0) + "ay";

        output = temp1 + " " + temp2;

        System.out.println(output);
    }
}
