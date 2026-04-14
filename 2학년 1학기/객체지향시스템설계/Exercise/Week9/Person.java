package Week9;

import java.util.Random;
import java.util.Date;

public class Person {
    private String name;
    private Date born;
    private Date died;

    private boolean consistent(Date birth, Date death)
    {
        if(birth == null) return false;
        else if(death == null) return true;
        else return (birth.compareTo(death) <= 0);
    }

    public Person(){}
    public Person(String _name, Date _born, Date _died)
    {
        if(!consistent(_born, _died))
        {
            System.out.println("Inconsistent dates");
            System.exit(1);
        }
        else {
            this.name = _name;
            this.born = new Date(_born.getYear(), _born.getMonth(), _born.getDate());
            if(_died != null)
                this.died = new Date(_died.getYear(), _died.getMonth(), _died.getDate());
            else
                this.died = null;
        }
    }

    public String toString()
    {
        String result = "Name : " + this.name + ", Born in " + born.getYear() + "/" + born.getMonth() + "/" + born.getDate();
        if(this.died != null)
            result += ", died in" + died.getYear() + "/" + died.getMonth() + "/" + died.getDate();

        return result;
    }

    public String getName()
    {
        return this.name;
    }

    public Date getBorn()
    {
        return new Date(born.getYear(), born.getMonth(), born.getDate());
    }

    public Date getDied()
    {
        if(died == null) return null;
        return new Date(died.getYear(), died.getMonth(), died.getDate());
    }

    public void setName(String _name)
    {
        this.name = _name;
    }

    public void setBorn(Date _born)
    {
        if(_born == null)
        {
            System.out.println("Invalid date");
            return;
        }
        this.born = new Date(_born.getYear(), _born.getMonth(), _born.getDate());
    }

    public void setDied(Date _died)
    {
        if(_died == null)
            this.died = null;
        this.died = new Date(_died.getYear(), _died.getMonth(), _died.getDate());
    }

    public boolean equals(Person other)
    {
        if(other == null)
            return false;
        else
            return (this.name.equals(other.name) && this.born.equals(other.born) && datesMatch(this.died, other.died));
    }

    private static boolean datesMatch(Date date1, Date date2)
    {
        if(date1 == null)
            return (date2 == null);
        else if(date2 == null)
            return false;
        else
            return(date1.equals(date2));
    }
}
