import itertools
import types
import random
from PIL import Image


class Population:

    def __init__(self, N, genelen, mutation, crossing):
        self.mutated = int(0.02 * genelen)
        self.crossed = int(crossing * N)
        self.paired = list(itertools.combinations(range(N), 2))

    def loadSource(self, filename):
        source = types.SimpleNamespace()
        source.image = Image.open(filename)
        source.pixels = source.image.load()

        self.source = source
        self.W, self.H = source
