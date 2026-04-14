public class DepartmentContact extends ContactInfo{
    protected String department;
    public DepartmentContact(String name, String phoneNum, String department)
    {
        super(name, phoneNum);
        this.department = department;
    }
    @Override
    public ContactInfo getInfo(ContactInfo c)
    {
        return this;
    }

    @Override
    public String toString()
    {
        return "name: " + name + " / phone number: " + phoneNum + " / department: " + department;
    }
}
