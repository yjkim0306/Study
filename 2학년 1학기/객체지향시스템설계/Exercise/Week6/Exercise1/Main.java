package Week6.Exercise1;

import Week6.Exercise1.util.AgeCalculator;

public class Main {
    public static void main(String[] args)
    {
        Person p1 = new Person();
        Person p2 = new Person();

        System.out.printf("Person 1: %d/%d/%d%n", p1.getYear(), p1.getMonth(), p1.getDay());
        System.out.printf("Person 2: %d/%d/%d%n", p2.getYear(), p2.getMonth(), p2.getDay());

        System.out.printf("Age of Person 1: %d%n", AgeCalculator.calAge(p1));
        System.out.printf("Age of Person 2: %d%n", AgeCalculator.calAge(p2));

        if(AgeCalculator.isOlder(p1, p2) == 1)
            System.out.println("Person 1 is older than Person 2.");
        else if(AgeCalculator.isOlder(p1, p2) == 0)
            System.out.println("Person 1 and Person 2 are the same age.");
        else if(AgeCalculator.isOlder(p1, p2) == -1)
            System.out.println("Person 2 is older than Person 1.");
    }
}