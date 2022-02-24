import os
import csv
import shutil


def get_students_list(list_path):

    with open(list_path, 'r') as csvfile:

        sl_reader = csv.reader(csvfile, delimiter=',')
        sl_dict = {row[0]:row[1] for row in sl_reader}

        return sl_dict


def find_homeworks(directory):

    hws = [hw for hw in os.listdir(directory) if hw.startswith('tarea') and hw.endswith('.pdf')]

    return hws


def get_homework_number(hws):

    numbers = [int(hw[6:8]) for hw in hws]

    if len(set(numbers)) == 1:

        return numbers[0]

    else:

        return 'Mixed homeworks'


def get_homework_names(hws, list_path):

    students_list = get_students_list(list_path)
    names = [students_list[hw[9:-4]] for hw in hws]

    return names


def get_template(template_path):

    with open(template_path, 'r') as template:

        return [template.readlines()]


def copy_template(template_path, list_path,  directory):

    hws = find_homeworks(directory)
    names = get_homework_names(hws, list_path)
    number = get_homework_number(hws)
    templates = get_template(template_path) * len(hws)
    titles = [[f'# Tarea {number} de {name}\n'] for name in names]
    new_templates = [titles[i] + template for i, template in enumerate(templates)]
    new_path = [directory + hw[:-4] + '-comentarios.md' for hw in hws]

    for i, template in enumerate(new_templates):

        with open(new_path[i], 'w') as t:

            t.writelines(template)

        print(titles[i][0][2:-1])
        print(f'>> {new_path[i]}\n')

    return 0

copy_template('/home/jueves/repos/grading/commentaries-template.md', '/home/jueves/repos/grading/Test/test_student_list.csv', '/home/jueves/repos/grading/Test/')
