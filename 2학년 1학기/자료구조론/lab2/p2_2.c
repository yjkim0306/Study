#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct student{
    char *name;
    int student_id;
    char *major;
}student;

int main(int argc, char **args)
{
    char *input_path, *output_path;
    FILE *fi, *fo;

    int num;
    int i;

    student* students;

    input_path = args[1];
    output_path = args[2];

    fi = fopen(input_path, "r");
    fo = fopen(output_path, "w");

    if(fi == NULL || fo == NULL) return 0;

    fscanf(fi, "%d", &num);

    if(num <= 2) return 0;

    students = (student*)malloc(num * sizeof(student));

    for(i = 0; i < num; i++)
    {
        students[i].name = malloc(sizeof(char) * 31);
        students[i].major = malloc(sizeof(char) * 31);
        
        fscanf(fi, "%s %d %s\n", students[i].name, &students[i].student_id, students[i].major);
        fprintf(fo, "%-8s %-15d %-s\n", students[i].name, students[i].student_id, students[i].major);
    }
    
    for(int i = 0; i < num; i++)
    {
        free(students[i].name);
        free(students[i].major);
    }

    free(students);

    fclose(fi);
    fclose(fo);

    return 0;
}