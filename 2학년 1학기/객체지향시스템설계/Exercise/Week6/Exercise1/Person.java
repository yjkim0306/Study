package Week6.Exercise1;
import java.util.Calendar;
import java.util.Random;

public class Person {
    Calendar cal = Calendar.getInstance();
    Random rnd = new Random();
    private int year, month, day;

    public Person()
    {
        year = rnd.nextInt(1900, 2023);
        month = rnd.nextInt(1, 13);
        day = rnd.nextInt(1, cal.getActualMaximum(Calendar.DATE));
    }

    public int getYear() {
        return year;
    }

    public int getMonth()
    {
        return month;
    }

    public int getDay()
    {
        return day;
    }
}
