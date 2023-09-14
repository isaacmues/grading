from pylatex import Document, Section, Command, TextColor
from pylatex.utils import NoEscape, bold
import yaml


class Calificacion(Document):

    def __init__(self, datos):
        super().__init__()

        self.estudiante = datos["nombre"]
        self.materia = datos["materia"]
        self.trabajo = ' '.join((datos["tipo"].capitalize(), str(datos["numero"])))
        self.comentarios = [datos["puntuacion"][k]["comentario"] for k in datos["puntuacion"]]
        self.puntos = [datos["puntuacion"][k]["puntos"] for k in datos["puntuacion"]]
        self.calificacion = self.calcula_calificacion()

        self.preamble.append(Command('title', self.crea_titulo()))
        self.preamble.append(Command('author', ''))
        self.preamble.append(Command('date', ''))
        self.append(NoEscape(r'\maketitle'))

    def fill_document(self):
        with self.create(Section('Comentarios')):
            self.append('Aquí irían los comentarios')

    def calcula_calificacion(self):
        return round(sum(self.puntos) / len(self.puntos) * 100)

    def crea_titulo(self):
        materia = ''.join((r'\Large{\textsc{', self.materia, r'}}'))
        trabajo = ''.join((r'\huge{', self.trabajo, ' de ', self.estudiante, r'}'))
        calificacion = bold(''.join((r'\Large{Calificación: ', str(self.calificacion), r' de 100}')), escape=False)

        return NoEscape(r' \\ '.join((materia, trabajo, calificacion)))


if __name__ == '__main__':

    # Carga los comentarios
    with open('test.yml', 'r') as file:
        datos = yaml.safe_load(file)

    doc = Calificacion(datos)
    doc.fill_document()

    print(doc.trabajo)

    doc.generate_pdf('test', clean_tex=False)
    tex = doc.dumps()
