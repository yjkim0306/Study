package Week6.Exercise1.util;
import Week6.Exercise1.Person;
import java.util.Calendar;

public class AgeCalculator {
    public static int calAge(Person p)
    {
        Calendar today = Calendar.getInstance();
        if(today.get(Calendar.MONTH) + 1 < p.getMonth() || (today.get(Calendar.MONTH) + 1 == p.getMonth() && (today.get(Calendar.DAY_OF_MONTH) < p.getDay())))
            return today.get(Calendar.YEAR) - p.getYear() - 1;
        else return today.get(Calendar.YEAR) - p.getYear();
    }

    public static int isOlder(Person p1, Person p2)
    {
        if(calAge(p1) > calAge(p2))
            return 1;
        else if(calAge(p1) == calAge(p2))
            return 0;
        else
            return -1;
    }

}
