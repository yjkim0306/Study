public class ClubContact extends ContactInfo{
    protected String clubName;
    public ClubContact(String name, String phoneNum, String clubName)
    {
        super(name, phoneNum);
        this.clubName = clubName;
    }
    @Override
    public ContactInfo getInfo(ContactInfo c)
    {
        return this;
    }
    public String toString()
    {
        return "name: " + name + " / phone number: " + phoneNum + " / club name: " + clubName;
    }
}
