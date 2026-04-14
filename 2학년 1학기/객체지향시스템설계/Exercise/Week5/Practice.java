package Week5;

import java.util.Scanner;
import java.util.Random;
import java.util.StringTokenizer;
import java.util.Calendar;

public class Practice {
    public static void main(String[] args)
    {
        Scanner sc = new Scanner(System.in);

        String info = sc.nextLine();

        StringTokenizer st1 = new StringTokenizer(info);
        String name = st1.nextToken();
        String date = st1.nextToken();

        StringTokenizer st2 = new StringTokenizer(date, "/");

        int year = Integer.parseInt(st2.nextToken());
        int month = Integer.parseInt(st2.nextToken());
        int day = Integer.parseInt(st2.nextToken());

        Student stu = new Student(name, year, month, day);
        int age = stu.calAge(stu);

        String name2 = sc.nextLine();
        Student cmp = new Student(name2, year);

        int month2 = cmp.getMonth();
        int day2 = cmp.getDay();
        int age2 = cmp.calAge(cmp);

        if(!stu.checkDate(stu))
        {
            System.out.println("invalid input");
            System.exit(0);
        }

        System.out.printf("%s %d/%d/%d age: %d%n", name, year, month, day, age);
        System.out.printf("%s %d/%d/%d age: %d%n", name2, year, month2, day2, age2);
        if(stu.isOlder(cmp))
        {
            System.out.printf("%s is older than %s", name, name2);
        }
        else if(!stu.isOlder(cmp))
        {
            System.out.printf("%s is older than %s", name2, name);
        }
    }
}
