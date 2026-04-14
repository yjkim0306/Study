public abstract class ContactInfo {
    protected String name;
    protected String phoneNum;
    public ContactInfo(String name, String phoneNum)
    {
        this.name = name;
        this.phoneNum = phoneNum;
    }
    public abstract ContactInfo getInfo(ContactInfo c);
    public abstract String toString();
}