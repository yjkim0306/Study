package Week11.Practice1;

public class MyException extends Exception {
    public MyException()
    {
        super();
    }
    public MyException(String message)
    {
        super(message);
    }

    public String getMessage()
    {
        return "[MyException] " + super.getMessage();
    }
}
