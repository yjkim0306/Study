package Week11.Practice2;

public class Account {
    private String ID;
    private int account_num;
    private int balance;

    public Account(String ID, int account_num, int balance) throws Exception
    {
        this.ID = ID;
        this.account_num = account_num;
        this.balance = balance;
        int digit0 = (int)ID.charAt(0);
        int digit1 = (int)ID.charAt(1);
        int digit2 = (int)ID.charAt(2);
        int digit3 = (int)ID.charAt(3);
        if(!((digit0 >= 65 && digit0 <= 90) || (digit0 >= 97 && digit0 <= 122)) || !(digit1 >= 48 && digit1 <= 57) || !(digit2 >= 48 && digit2 <= 57) || !(digit3 >= 48 && digit3 <= 57))
            throw new Exception("Invalid ID format: ID must start with a letter and should be followed by three digits.");
        else if(account_num < 10000 || account_num > 99999)
            throw new Exception("Invalid account number: Account number must be of five digits.");
        else if(balance <= 1000)
            throw new Exception("Invalid balance: Initial balance must be above $1000.");
    }
    public String toString()
    {
        return "ID: " + ID + ", Account #" + account_num + ", Balance: " + balance;
    }
}
