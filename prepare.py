import os
import shutil

def find_homeworks(directory):

    hws = [hw for hw in os.listdir(directory) if hw.startswith('tarea') and hw.endswith('.pdf')]

    return hws


def get_homework_number(hws):

    numbers = [int(hw[6:8]) for hw in hws]

    if len(set(numbers)) == 1:

        return numbers[0]

    else:

        return 'Mixed homeworks'


def get_homework_names(hws):

    last_names = [hw[9:-4] for hw in hws]

    return last_names


def copy_template(template_path, directory):

    hws = find_homeworks(directory)
    names = get_homework_names(hws)

    new_templates = [hw[:-4] + '-comentarios.md' for hw in hws]

    for nt in new_templates:

        shutil.copy(template_path, directory + nt)

    return 0
