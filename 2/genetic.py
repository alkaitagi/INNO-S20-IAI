import itertools
import types
import random
from PIL import Image, ImageDraw, ImageFont


def randcolor():
    return tuple(random.randint(0, 255) for _ in range(3))


def new():
    individual = types.SimpleNamespace()
    individual.image = Image.new('RGB', (field, field), (255, 255, 255))
    individual.pixels = individual.image.load()
    individual.draw = ImageDraw.Draw(individual.image)
    individual.genes = [None] * genelen
    return individual


def draw(individual, i, color):
    individual.genes[i] = color
    individual.pixels[areas[i][0], areas[i][1]] = color
    # individual.draw.ellipse(areas[i], color)


def fit(individual):
    fit = 0
    for i in range(field):
        for j in range(field):
            iPixel = individual.pixels[i, j]
            sPixel = source.pixels[i, j]
            for c in range(3):
                fit += (iPixel[c] - sPixel[c]) ** 2

    individual.fit = fit
    return fit


def crossover(A, B):
    individual = new()
    pivot = random.randint(0, genelen - 1)
    for i in range(genelen):
        draw(individual, i, (A if i < pivot else B).genes[i])

    return individual


def mutate(individual):
    for i in random.choices(range(genelen), k=mutation):
        draw(individual, i, randcolor())


def populate(N):
    population = []
    for _ in range(N):
        individual = new()
        for i in range(genelen):
            draw(individual, i, randcolor())

        fit(individual)
        population.append(individual)

    return population


source = types.SimpleNamespace()
source.image = Image.open("image.png")
source.pixels = source.image.load()

field = source.image.size[0]
diameter = 1
areas = []
popcount = 10
for i in range(field // diameter):
    for j in range(field // diameter):
        p = (diameter * i, diameter * j)
        areas.append((p[0], p[1], p[0] + diameter, p[1] + diameter))

genelen = len(areas)
mutation = int(0.02 * genelen)
crosspool = int(0.5 * popcount)
pairs = list(itertools.combinations(range(popcount), 2))


population = populate(popcount)
while True:
    for pair in random.choices(pairs, k=crosspool):
        child = crossover(population[pair[0]], population[pair[1]])
        mutate(child)
        fit(child)
        population.append(child)

    population.sort(reverse=True, key=lambda x: x.fit)
    del population[popcount:]

    population[0].image.save("result.png")
    print("saved")
