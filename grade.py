from pylatex import Document, Section, Command, TextColor
from pylatex.utils import NoEscape
import yaml


class Calificacion(Document):

    def __init__(self, titulo):
        super().__init__()

        self.preamble.append(Command('title', titulo))
        self.preamble.append(Command('author', ''))
        self.preamble.append(Command('date', ''))
        self.append(NoEscape(r'\maketitle'))

    def fill_document(self):
        with self.create(Section('Comentarios')):
            self.append('Aquí irían los comentarios')


def titulo(materia, estudiante):

    materia_sc = ''.join((r'\Large{\textsc{', materia, r'}}'))

    return NoEscape(r' \\ '.join((materia_sc, estudiante)))

if __name__ == '__main__':

    # Carga los comentarios
    with open('test.yml', 'r') as file:
        datos = yaml.safe_load(file)

    print(datos["nombre"])

    doc = Calificacion(
            titulo('Hermenéutica', datos["nombre"])
            )
    doc.fill_document()

    doc.generate_pdf('test', clean_tex=False)
    tex = doc.dumps()
