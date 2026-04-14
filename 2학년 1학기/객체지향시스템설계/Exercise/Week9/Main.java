package Week9;
import java.util.Scanner;
import java.util.Date;

public class Main {
    public static void main(String[] args)
    {
        /* This program assumes that both the doctor and the patient have not passed away yet.
           이 프로그램은 의사와 환자 모두 사망하지 않은 것을 가정하였습니다.
           For each input, please follow the format as specified in the question. Otherwise, it may bring unexpected result.
           입력하실 때 질문에 명시된 형태에 따라주시기 바랍니다. 정확히 입력되지 않을 경우 예상과 다른 결과가 도출될 수 있습니다. */

        Scanner sc = new Scanner(System.in);
        Doctor doctor = new Doctor();
        Physician physician = new Physician();

        System.out.print("Enter the name of the doctor: ");
        String doctorName = sc.nextLine();
        System.out.print("Enter the birth date of the doctor in the format of (YYYY/MM/DD): ");
        Scanner dateConverter = new Scanner(System.in);

        dateConverter.useDelimiter("[/\r\n]"); // splits each input by '/' ; used for date conversion
        int year = dateConverter.nextInt();
        int month = dateConverter.nextInt();
        int day = dateConverter.nextInt();
        Date date = new Date(year, month, day); // Doctor's birth date

        System.out.println("Are you a physician, " + doctorName + "? (Enter y or n)"); // Assumes that a doctor can be either a physician, or have not decided major yet
        String ans = sc.nextLine();

        doctor = new Doctor(doctorName, date, null, "hospital");
        System.out.println(doctor); // prints the information of doctor
        if(ans.equals("y"))
            physician = new Physician(doctorName, date, null, "hospital"); // if the doctor is a physician, creates the object physician

        String more = "y"; // controls the do-while loop
        do{
            System.out.print("Enter the name of the patient: ");
            String patientName = sc.nextLine();
            System.out.print("Enter the birth date of the patient in the format of (YYYY/MM/DD): ");
            year = dateConverter.nextInt();
            month = dateConverter.nextInt();
            day = dateConverter.nextInt();
            date = new Date(year, month, day); // Patient's birth date

            System.out.println("What department are you looking for? (Internal/Surgery/Dental)");
            String department = sc.nextLine();

            Patient patient = new Patient(patientName, date, null, department);

            System.out.println(patient); // prints the information of patient

            if(ans.equals("n"))
                doctor.examination(patient); // "I haven't decided my major yet."
            if(ans.equals("y"))
                physician.examination(patient); // "I'll take care of you!" OR "Sorry, but it's not my major"

            System.out.println();
            System.out.println("Next patient? (y/n)"); // Asks if there is next patient
            more = sc.nextLine();
        }while(more.equals("y"));
    }
}
