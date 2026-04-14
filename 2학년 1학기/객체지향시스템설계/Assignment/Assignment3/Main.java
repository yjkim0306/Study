import java.io.*;
import java.util.InputMismatchException;

public class Main {
    public static void main(String[] args) {
        CommandLineInterface cli = new CommandLineInterface();
        ContactManager manager = new ContactManager(cli);
        int choice;

        while (true) {
            try {
                choice = cli.getMainMenu();
                if (choice < 1 || choice > 9)
                    throw new MenuChoiceException(choice);
                switch (choice) {
                    case 1 -> manager.setStorageSize();
                    case 2 -> {
                        PrintStream output = new PrintStream("ContactBook.txt");
                        manager.saveToFile(output);
                    }
                    case 3 -> {
                        FileInputStream input = new FileInputStream("ContactBook.txt");
                        manager.loadFromFile(input);
                    }
                    case 4 -> manager.createContact();
                    case 5 -> {
                        ContactInfo ci = manager.searchContact();
                        if (ci == null)
                            System.out.println("Contact not found");
                        else {
                            System.out.println("Contact found");
                            System.out.println(ci);
                        }
                    }
                    case 6 -> manager.deleteContact();
                    case 7 -> manager.editContact();
                    case 8 -> cli.printContactInfo(manager);
                    case 9 -> System.exit(0);
                }
            }
            catch (MenuChoiceException e)
            {
                cli.printErrorMessage("Enter a number between 1 ~ 9.\nTry again.");
            }
            catch (FileNotFoundException e)
            {
                cli.printErrorMessage("File name [" + args[0] + "] not found.");
            }
            catch(InputMismatchException e)
            {
                cli.printErrorMessage("The information must be between 3 ~ 20 characters.");
            }
            catch(phoneNumException e)
            {
                cli.printErrorMessage("Phone number must be of format: 010-0000-0000.");
            }
            catch(ContactSizeException e)
            {
                cli.printErrorMessage("You cannot store more contact than the size of total contacts.");
            }
        }
    }
}