import java.util.*;

public class CommandLineInterface {
    private Scanner scanner;
    public CommandLineInterface()
    {
        scanner = new Scanner(System.in);
    }
    public int getMainMenu()
    {
        System.out.print("----<Main Menu>----\n1. Set size of total contacts\n2. Save the current contact to a file\n3. Load the saved contact file\n4. Register new contact\n5. Search contact\n6. Delete contact\n7. Edit contact\n8. View all contacts\n9. Exit\nSelect: ");
        return scanner.nextInt();
    }

    public int getSetSizeMenu()
    {
        System.out.print("Enter the size of the contact: ");
        return scanner.nextInt();
    }

    public ArrayList<String> getCreateContactMenu() throws phoneNumException {
        System.out.print("Create contact...\n1. normal contact\n2. club contact\n3. department contact\nSelect: ");
        int input = scanner.nextInt();
        System.out.print("name: ");
        String nullStr = scanner.nextLine();
        String name = scanner.nextLine();
        if(name.length() < 3 || name.length() > 20)
            throw new InputMismatchException();

        System.out.print("phone number: ");
        String phoneNum = scanner.nextLine();
        for(int i = 0; i < 13; i++)
        {
            if(i == 0 || i == 2)
            {
                if(phoneNum.charAt(i) != '0')
                    throw new phoneNumException();
                continue;
            }
            if(i == 1)
            {
                if(phoneNum.charAt(i) != '1')
                    throw new phoneNumException();
                continue;
            }
            if(i == 3 || i == 8)
            {
                if(phoneNum.charAt(i) != '-')
                    throw new phoneNumException();
                continue;
            }

            int phoneNumIndex = phoneNum.charAt(i);
            if(phoneNumIndex < 48 || phoneNumIndex > 57)
                throw new phoneNumException();
        }

        if(input == 1)
        {
            System.out.print("relation: ");
            String relation = scanner.nextLine();
            if(relation.length() < 3 || relation.length() > 20)
                throw new InputMismatchException();
            return new ArrayList<String>(List.of(name, phoneNum, relation, "normal"));
        }
        else if(input == 2)
        {
            System.out.print("club name: ");
            String clubName = scanner.nextLine();
            if(clubName.length() < 3 || clubName.length() > 20)
                throw new InputMismatchException();
            return new ArrayList<String>(List.of(name, phoneNum, clubName, "club"));
        }
        else if(input == 3)
        {
            System.out.print("department: ");
            String department = scanner.nextLine();
            if(department.length() < 3 || department.length() > 20)
                throw new InputMismatchException();
            return new ArrayList<String>(List.of(name, phoneNum, department, "department"));
        }
        else
            System.out.println("Enter a number between 1 ~ 3.");

        return null;
    }

    public HashMap getSearchContactMenu()
    {
        System.out.print("Search contact...\nChoose the variable\n1. name\n2. phone number\n3. relation\n4. club name\n5. department\nSelect: ");
        int input = scanner.nextInt();
        switch(input)
        {
            case 1:
                System.out.print("Enter the name: ");
                break;
            case 2:
                System.out.print("Enter the phone number: ");
                break;
            case 3:
                System.out.print("Enter the relation: ");
                break;
            case 4:
                System.out.print("Enter the club name: ");
                break;
            case 5:
                System.out.print("Enter the department: ");
                break;
            default:
                System.out.println("Enter a number between 1 ~ 5.");
        }
        String nullStr = scanner.nextLine();
        String str = scanner.nextLine();
        HashMap<Integer, String> info = new HashMap<Integer, String>();
        info.put(input, str);
        return info;
    }

    public HashMap getDeleteContactMenu()
    {
        System.out.println("Delete contact...");
        HashMap<Integer, String> info = getSearchContactMenu();

        return info;
    }

    public HashMap<Integer, String[]> getEditContactMenu()
    {
        System.out.println("Edit contact...");
        HashMap<Integer, String> tempInfo = getSearchContactMenu();
        HashMap<Integer, String[]> info = new HashMap<>();
        System.out.print("Enter the information: ");
        String editInfo = scanner.nextLine();
        String[] str = {tempInfo.get(tempInfo.keySet().hashCode()), editInfo};
        info.put(tempInfo.keySet().hashCode(), str);

        return info;
    }

    public void printContactInfo(ContactManager cm)
    {
        if(!cm.contactStorage.normalContacts.isEmpty()) {
            System.out.println("Normal Contacts");
            for (int i = 0; i < cm.contactStorage.normalContacts.size(); i++) {
                System.out.printf("\t" + (i + 1) + ". ");
                System.out.println(cm.contactStorage.normalContacts.get(i).toString());
            }
        }
        if(!cm.contactStorage.clubContacts.isEmpty()) {
            System.out.println("Club Contacts");
            for (int i = 0; i < cm.contactStorage.clubContacts.size(); i++) {
                System.out.printf("\t" + (i + 1) + ". ");
                System.out.println(cm.contactStorage.clubContacts.get(i).toString());
            }
        }
        if(!cm.contactStorage.departmentContacts.isEmpty()) {
            System.out.println("Department Contacts");
            for (int i = 0; i < cm.contactStorage.departmentContacts.size(); i++) {
                System.out.printf("\t" + (i + 1) + ". ");
                System.out.println(cm.contactStorage.departmentContacts.get(i).toString());
            }
        }
    }

    public void printErrorMessage(String str)
    {
        System.out.println("Exception occurred: " + str);
    }

}
