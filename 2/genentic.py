import types
import random
from PIL import Image, ImageDraw, ImageFont


def randcolor():
    return tuple(random.randint(0, 255) for _ in range(3))


def getfit(individual):
    fit = 0
    for i in range(field):
        for j in range(field):
            iPixel = individual.pixels[i, j]
            sPixel = source.pixels[i, j]
            for c in range(3):
                fit += (iPixel[c] - sPixel[c]) ** 2

    return fit


def mutate(individual):
    


def populate(N):
    population = []
    for _ in range(N):
        individual = types.SimpleNamespace()
        individual.image = Image.new('RGB', source.size, (255, 255, 255))
        individual.pixels = individual.image.load()
        individual.draw = ImageDraw.Draw(individual.image)
        individual.genes = []
        for area in areas:
            color = randcolor()
            individual.genes.append(color)
            individual.draw.ellipse(area, color)

        population.append(individual)

    return population


field = 512
diameter = 4
areas = []
arearange = range(len(areas))

for i in range(field // diameter):
    for j in range(field // diameter):
        p = (diameter * i, diameter * j)
        areas.append((p[0], p[1], p[0] + diameter, p[1] + diameter))

source = types.SimpleNamespace()
source.image = Image.open("image.png")
source.pixels = source.image.load()

population = populate(10)

for _ in range(100000):
    draw(population[0])
    # for item in population:
    #     draw(item)

population[0].save("gen_image.png")
