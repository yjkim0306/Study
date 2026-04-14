public class NormalContact extends ContactInfo{
    protected String relation;
    public NormalContact(String name, String phoneNum, String relation)
    {
        super(name, phoneNum);
        this.relation = relation;
    }

    @Override
    public ContactInfo getInfo(ContactInfo c) {
        return this;
    }

    @Override
    public String toString() {
        return "name: " + name + " / phone number: " + phoneNum + " / relation: " + relation;
    }
}
