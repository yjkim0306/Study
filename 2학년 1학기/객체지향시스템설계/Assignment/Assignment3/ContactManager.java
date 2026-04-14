import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;
import java.io.*;
public class ContactManager {
    private int numOfLine = 0;
    public ContactManager(CommandLineInterface cli)
    {
        this.cli = cli;
    }
    public class MyStorage<ContactInfo>
    {
        private int currentSize = 0;
        private int maxSize = 0;
        protected ArrayList<ContactInfo> contacts = new ArrayList<>();
        protected ArrayList<NormalContact> normalContacts = new ArrayList<>();
        protected ArrayList<ClubContact> clubContacts = new ArrayList<>();
        protected ArrayList<DepartmentContact> departmentContacts = new ArrayList<>();
    }
    protected MyStorage<ContactInfo> contactStorage = new MyStorage<>();
    private CommandLineInterface cli;

    public void setStorageSize()
    {
        contactStorage.maxSize = cli.getSetSizeMenu();
    }

    public void saveToFile(PrintStream output){
        for(int i = 0; i < contactStorage.normalContacts.size(); i++) {
            output.println("Normal contact: " + contactStorage.normalContacts.get(i).name + " " + contactStorage.normalContacts.get(i).phoneNum + " " + contactStorage.normalContacts.get(i).relation);
            numOfLine++;
        }
        for(int i = 0; i < contactStorage.clubContacts.size(); i++) {
            output.println("Club contact: " + contactStorage.clubContacts.get(i).name + " " + contactStorage.clubContacts.get(i).phoneNum + " " + contactStorage.clubContacts.get(i).clubName);
            numOfLine++;
        }
        for(int i = 0; i < contactStorage.departmentContacts.size(); i++) {
            output.println("Department contact: " + contactStorage.departmentContacts.get(i).name + " " + contactStorage.departmentContacts.get(i).phoneNum + " " + contactStorage.departmentContacts.get(i).department);
            numOfLine++;
        }
    }

    public void loadFromFile(FileInputStream input) throws FileNotFoundException, ContactSizeException
    {
        Scanner inputStream = new Scanner(input);

        while(inputStream.hasNextLine())
        {
            String line = inputStream.nextLine();
            if (numOfLine + contactStorage.currentSize > contactStorage.maxSize)
            {
                inputStream.close();
                throw new ContactSizeException();
            }
            String[] arr = line.split(" ");

            if(arr.length >= 4)
            {
                String var = arr[0].trim();
                String name = arr[2].trim();
                String phoneNum = arr[3].trim();
                String info = arr[4].trim();

                switch (var) {
                    case "Normal" -> {
                        ContactInfo contact1 = new NormalContact(name, phoneNum, info);
                        NormalContact normalContact = new NormalContact(name, phoneNum, info);
                        contactStorage.contacts.add(contact1);
                        contactStorage.normalContacts.add(normalContact);
                    }
                    case "Club" -> {
                        ContactInfo contact2 = new ClubContact(name, phoneNum, info);
                        ClubContact clubContact = new ClubContact(name, phoneNum, info);
                        contactStorage.contacts.add(contact2);
                        contactStorage.clubContacts.add(clubContact);
                    }
                    case "Department" -> {
                        ContactInfo contact3 = new DepartmentContact(name, phoneNum, info);
                        DepartmentContact departmentContact = new DepartmentContact(name, phoneNum, info);
                        contactStorage.contacts.add(contact3);
                        contactStorage.departmentContacts.add(departmentContact);
                    }
                    default -> System.out.println("Invalid variable for contactType.");
                }
            }
        }

        inputStream.close();
    }

    public void createContact() throws phoneNumException, ContactSizeException
    {
        contactStorage.currentSize++;
        if(contactStorage.currentSize > contactStorage.maxSize) {
            contactStorage.currentSize--;
            throw new ContactSizeException();
        }

        ArrayList<String> arrayList = cli.getCreateContactMenu();
        switch (arrayList.get(3)) {
            case "normal" -> {
                NormalContact contact = new NormalContact(arrayList.get(0), arrayList.get(1), arrayList.get(2));
                contactStorage.contacts.add(contact);
                contactStorage.normalContacts.add(contact);
            }
            case "club" -> {
                ClubContact contact = new ClubContact(arrayList.get(0), arrayList.get(1), arrayList.get(2));
                contactStorage.contacts.add(contact);
                contactStorage.clubContacts.add(contact);
            }
            case "department" -> {
                DepartmentContact contact = new DepartmentContact(arrayList.get(0), arrayList.get(1), arrayList.get(2));
                contactStorage.contacts.add(contact);
                contactStorage.departmentContacts.add(contact);
            }
        }
    }

    public ContactInfo searchContact()
    {
        HashMap<Integer, String> info = cli.getSearchContactMenu();
        switch(info.keySet().hashCode())
        {
            case 1:
                for(ContactInfo c : contactStorage.contacts)
                    if(c.name.equals(info.get(info.keySet().hashCode())))
                        return c;
                break;
            case 2:
                for(ContactInfo c : contactStorage.contacts)
                    if(c.phoneNum.equals(info.get(info.keySet().hashCode())))
                        return c;
                break;
            case 3:
                for(NormalContact c : contactStorage.normalContacts)
                    if(c.relation.equals(info.get(info.keySet().hashCode())))
                        return c;
                break;
            case 4:
                for(ClubContact c : contactStorage.clubContacts)
                    if(c.clubName.equals(info.get(info.keySet().hashCode())))
                        return c;
                break;
            case 5:
                for(DepartmentContact c : contactStorage.departmentContacts)
                    if(c.department.equals(info.get(info.keySet().hashCode())))
                        return c;
                break;
        }

        return null;
    }

    public void deleteContact()
    {
        HashMap<Integer, String> info = cli.getDeleteContactMenu();
        switch (info.keySet().hashCode()) {
            case 1 -> {
                for (ContactInfo c : contactStorage.contacts)
                    if (c.name.equals(info.get(info.keySet().hashCode()))) {
                        contactStorage.contacts.remove(c);
                        switch (c.getClass().getName()) {
                            case "NormalContact" ->
                                    contactStorage.normalContacts.remove(c);
                            case "ClubContact" ->
                                    contactStorage.clubContacts.remove(c);
                            case "DepartmentContact" ->
                                    contactStorage.departmentContacts.remove(c);
                        }
                        break;
                    }
            }
            case 2 -> {
                for (ContactInfo c : contactStorage.contacts)
                    if (c.phoneNum.equals(info.get(info.keySet().hashCode()))) {
                        contactStorage.contacts.remove(contactStorage.contacts.indexOf(c));
                        switch (c.getClass().getName()) {
                            case "NormalContact" ->
                                    contactStorage.normalContacts.remove(c);
                            case "ClubContact" ->
                                    contactStorage.clubContacts.remove(c);
                            case "DepartmentContact" ->
                                    contactStorage.departmentContacts.remove(c);
                        }
                        break;
                    }
            }
            case 3 -> {
                for (ContactInfo c : contactStorage.contacts) {
                    if (c.getClass().getName().equals("NormalContact"))
                        if (((NormalContact) c).relation.equals(info.get(info.keySet().hashCode()))) {
                            contactStorage.contacts.remove(c);
                            break;
                        }
                }
                for (NormalContact nc : contactStorage.normalContacts) {
                    if (nc.relation.equals(info.get(info.keySet().hashCode()))) {
                        contactStorage.normalContacts.remove(nc);
                        break;
                    }
                }
            }
            case 4 -> {
                for (ContactInfo c : contactStorage.contacts) {
                    if (c.getClass().getName().equals("ClubContact"))
                        if (((ClubContact) c).clubName.equals(info.get(info.keySet().hashCode()))) {
                            contactStorage.contacts.remove(c);
                            break;
                        }
                }
                for (ClubContact cc : contactStorage.clubContacts) {
                    if (cc.clubName.equals(info.get(info.keySet().hashCode()))) {
                        contactStorage.clubContacts.remove(cc);
                        break;
                    }
                }
            }
            case 5 -> {
                for (ContactInfo c : contactStorage.contacts) {
                    if (c.getClass().getName().equals("DepartmentContact"))
                        if (((DepartmentContact) c).department.equals(info.get(info.keySet().hashCode()))) {
                            contactStorage.contacts.remove(c);
                            break;
                        }
                }
                for (DepartmentContact dc : contactStorage.departmentContacts) {
                    if (dc.department.equals(info.get(info.keySet().hashCode()))) {
                        contactStorage.departmentContacts.remove(dc);
                        break;
                    }
                }
            }
        }
        contactStorage.currentSize--;
    }

    public void editContact()
    {
        HashMap<Integer, String[]> info = cli.getEditContactMenu();
        switch (info.keySet().hashCode()) {
            case 1 -> {
                for (ContactInfo c : contactStorage.contacts) {
                    if (c.name.equals(info.get(info.keySet().hashCode())[0])) {
                        contactStorage.contacts.get(contactStorage.contacts.indexOf(c)).name = info.get(info.keySet().hashCode())[1];
                        switch (c.getClass().getName()) {
                            case "NormalContact" ->
                                    contactStorage.normalContacts.get(contactStorage.normalContacts.indexOf(c)).name = info.get(info.keySet().hashCode())[1];
                            case "ClubContact" ->
                                    contactStorage.clubContacts.get(contactStorage.clubContacts.indexOf(c)).name = info.get(info.keySet().hashCode())[1];
                            case "DepartmentContact" ->
                                    contactStorage.departmentContacts.get(contactStorage.departmentContacts.indexOf(c)).name = info.get(info.keySet().hashCode())[1];
                        }
                    }
                }
            }
            case 2 -> {
                for (ContactInfo c : contactStorage.contacts) {
                    if (c.phoneNum.equals(info.get(info.keySet().hashCode())[0])) {
                        contactStorage.contacts.get(contactStorage.contacts.indexOf(c)).phoneNum = info.get(info.keySet().hashCode())[1];
                        switch (c.getClass().getName()) {
                            case "NormalContact" ->
                                    contactStorage.normalContacts.get(contactStorage.normalContacts.indexOf(c)).phoneNum = info.get(info.keySet().hashCode())[1];
                            case "ClubContact" ->
                                    contactStorage.clubContacts.get(contactStorage.clubContacts.indexOf(c)).phoneNum = info.get(info.keySet().hashCode())[1];
                            case "DepartmentContact" ->
                                    contactStorage.departmentContacts.get(contactStorage.departmentContacts.indexOf(c)).phoneNum = info.get(info.keySet().hashCode())[1];
                        }
                    }
                }
            }
            case 3 -> {
                for (ContactInfo c : contactStorage.contacts)
                    if (c.getClass().getName().equals("NormalContact"))
                        if (((NormalContact) c).relation.equals(info.get(info.keySet().hashCode())[0]))
                            ((NormalContact) contactStorage.contacts.get(contactStorage.contacts.indexOf(c))).relation = info.get(info.keySet().hashCode())[1];
                for (NormalContact c : contactStorage.normalContacts)
                    if (c.relation.equals(info.get(info.keySet().hashCode())[0]))
                        contactStorage.normalContacts.get(contactStorage.normalContacts.indexOf(c)).relation = info.get(info.keySet().hashCode())[1];
            }
            case 4 -> {
                for (ContactInfo c : contactStorage.contacts)
                    if (c.getClass().getName().equals("ClubContact"))
                        if (((ClubContact) c).clubName.equals(info.get(info.keySet().hashCode())[0]))
                            ((ClubContact) contactStorage.contacts.get(contactStorage.contacts.indexOf(c))).clubName = info.get(info.keySet().hashCode())[1];
                for (ClubContact c : contactStorage.clubContacts)
                    if (c.clubName.equals(info.get(info.keySet().hashCode())[0]))
                        contactStorage.clubContacts.get(contactStorage.clubContacts.indexOf(c)).clubName = info.get(info.keySet().hashCode())[1];
            }
            case 5 -> {
                for (ContactInfo c : contactStorage.contacts)
                    if (c.getClass().getName().equals("DepartmentContact"))
                        if (((DepartmentContact) c).department.equals(info.get(info.keySet().hashCode())[0]))
                            ((DepartmentContact) contactStorage.contacts.get(contactStorage.contacts.indexOf(c))).department = info.get(info.keySet().hashCode())[1];
                for (DepartmentContact c : contactStorage.departmentContacts)
                    if (c.department.equals(info.get(info.keySet().hashCode())[0]))
                        contactStorage.departmentContacts.get(contactStorage.departmentContacts.indexOf(c)).department = info.get(info.keySet().hashCode())[1];
            }
            default -> System.out.println("Invalid variable number entered.");
        }
    }
}
