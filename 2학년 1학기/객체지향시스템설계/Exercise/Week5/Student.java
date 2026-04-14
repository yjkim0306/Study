package Week5;
import java.util.Calendar;
import java.util.Random;
public class Student {
    private String name;
    private int year;
    private int month;
    private int day;

    public Student(String name, int year, int month, int day)
    {
        this.name = name;
        this.year = year;
        this.month = month;
        this.day = day;
    }

    public Student(String name, int year)
    {
        this.name = name;
        this.year = year;
        Random rnd = new Random();
        Calendar cal = Calendar.getInstance();
        month = rnd.nextInt(1, 13);
        day = rnd.nextInt(1, cal.getActualMaximum(Calendar.DATE));
    }

    public String getName()
    {
        return name;
    }

    public int getYear()
    {
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

    public boolean checkDate(Student stu)
    {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, stu.getYear());
        cal.set(Calendar.MONTH, stu.getMonth() - 1);
        if(stu.getDay() > cal.getActualMaximum(Calendar.DAY_OF_MONTH) || stu.getYear() < 1000 || stu.getYear() > 9999 || stu.getMonth() < 1 || stu.getMonth() > 12)
            return false;
        else
            return true;
    }

    public int calAge(Student stu)
    {
        Calendar today = Calendar.getInstance();
        if(today.get(Calendar.MONTH) + 1 < stu.getMonth() || (today.get(Calendar.MONTH) + 1 == stu.getMonth() && (today.get(Calendar.DAY_OF_MONTH) < stu.getDay())))
            return today.get(Calendar.YEAR) - stu.getYear() - 1;
        else
            return today.get(Calendar.YEAR) - stu.getYear();
    }

    public boolean isOlder(Student cmp)
    {
        return (month < cmp.getMonth()) || (month == cmp.getMonth() && day < cmp.getDay());
    }

}
