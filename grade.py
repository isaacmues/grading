import os
import sys
from statistics import mean


def find_commentaries(directory):

    hws = [hw for hw in os.listdir(directory) if hw.startswith('tarea') and hw.endswith('-comentarios.md')]

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


def get_points(path):

    with open(path, 'r') as h:

        p = [float(l[l.rfind('(') + 1:l.rfind('pts')]) for l in h.readlines() if l.startswith('- ')]

    return p


def get_grade(points):

    return f'## Calificación: {mean(points) * 10:.1f}\n'


def make_table(points):

    entries = [f'| {i+1} | {p} |\n' for i,p in enumerate(points)]
    entries += [f'| **Total** | {sum(points):.2f} |\n']

    return entries

def grade(path):

    points = get_points(path)
    grade = get_grade(points)
    table = make_table(points)

    with open(path, 'r') as h:

        graded_hw = h.readlines()


    graded_hw.insert(2, grade)
    graded_hw = graded_hw[:6] + table + graded_hw[6:]

    return graded_hw

#print(''.join(grade('/home/jueves/repos/grading/Test/tarea_07-perez_osorio-comentarios.md')))

homework_directory = sys.argv[1]
print(find_commentaries(homework_directory))
