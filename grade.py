from pylatex import Document, Section, Enumerate, Command, Package
from pylatex.utils import italic, NoEscape
import yaml, csv, sys

class Comments:

    def __init__(self, yaml_file, csv_file):

        with open(yaml_file, 'r') as file:
            data = yaml.safe_load(file)

        self.name = data["name"]
        self.job  = data["job"]
        self.number = str(data["number"])
        self.points = [c["points"] for c in data["score"]]
        self.weights = [c["weight"] for c in data["score"]]
        self.comments = [c["comment"] for c in data["score"]]

    def get_filename(self):
        return "-".join([self.job, self.number, self.code]) + ".pdf"


class Grade(Document):
    def __init__(self, yaml_file, csv_file):
        super().__init__()

        with open(yaml_file, 'r') as file:
            data = yaml.safe_load(file)

        self.student_name = data["name"]
        self.class_name = data["class"]
        self.job  = data["job"]
        self.number = data["number"]
        self.filename = self.get_filename(csv_file)
        self.points = [c["points"] for c in data["score"]]
        self.comments = [c["comment"] for c in data["score"]]

        self.weights = [c["weight"] for c in data["score"]]

        # Some packages
        self.preamble.append(Package("babel", options=["spanish", "mexico"]))
        self.preamble.append(Package("geometry", options=["a4paper", "top=2cm"]))
        self.preamble.append(Package("xcolor", options="dvipsnames"))
        self.preamble.append(Package("pifont"))
        self.preamble.append(Package("pdfpages"))

        # Removes page numbering
        self.preamble.append(NoEscape(r'\pagenumbering{gobble}'))

        # Some macros
        self.preamble.append(NoEscape(r'\newcommand{\omark}{{\color{OliveGreen}\ding{52}}}'))
        self.preamble.append(NoEscape(r'\newcommand{\xmark}{{\color{Bittersweet}\ding{56}}}'))

        # Title
        self.preamble.append(Command('title', self.get_title()))
        self.preamble.append(Command('author', self.get_author()))
        self.preamble.append(Command('date', ''))
        self.append(NoEscape(r'\maketitle'))

        self.put_comments()

    def get_author(self):
        return NoEscape(r'\huge{' + self.student_name + '}' + self.get_grade())

    def get_title(self):
        title = ' '.join([self.job, str(self.number), 'de', self.class_name])
        return NoEscape(r'\Large{\textsc{' + title + '}}')

    def get_grade(self):
        return r' \\ \\ \textbf{\huge{' + str(self.weighted_average()) + ' de 100}}'

    def simple_average(self):
        return int(sum(self.points) / len(self.points) * 100)

    def weighted_average(self):
        return int(sum([p * w for p,w in zip(self.points, self.weights)]) / len(self.points) * 100)

    def get_filename(self, csv_file):
        with open(csv_file, newline='') as file:
            reader = csv.reader(file, delimiter=',', quotechar='|')
            for row in reader:
                if self.student_name == row[1]:
                    return str.lower('-'.join([self.job, "{:02d}".format(self.number), row[0]]))

    def put_points(self, p):
        if p == 1.0:
            return r'\textbf{[\omark](' + '{:.2f}'.format(p) + " pts)} "
        else:
            return r'\textbf{[\xmark](' + '{:.2f}'.format(p) + " pts)} "

    def put_comments(self):
        with self.create(Section('Comentarios', numbering=False)):
            with self.create(Enumerate()) as enum:
                for p,c in zip(self.points, self.comments):
                    enum.add_item(NoEscape(self.put_points(p) + c))

    def generate_graded_work(self):
        self.generate_pdf(self.filename + "-calificada", clean_tex=True)


if __name__ == '__main__':

    doc = Grade(sys.argv[1], sys.argv[2])
    doc.generate_graded_work()
