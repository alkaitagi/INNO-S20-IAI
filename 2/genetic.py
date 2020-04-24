import types
import random
from PIL import Image, ImageDraw, ImageFont


def randcolor():
    return tuple(random.randint(0, 255) for _ in range(3))


def new():
    individual = types.SimpleNamespace()
    individual.image = Image.new('RGB', (field, field), (0, 0, 0))
    individual.pixels = individual.image.load()
    individual.draw = ImageDraw.Draw(individual.image)
    individual.genes = [None] * genelen
    return individual


def copy(original):
    individual = types.SimpleNamespace()
    individual.image = original.image.copy()
    individual.pixels = individual.image.load()
    individual.draw = ImageDraw.Draw(individual.image)
    individual.genes = original.genes[:]
    individual.fit = original.fit
    return individual


def draw(individual, i, color):
    area = areas[i]
    individual.genes[i] = color
    individual.draw.ellipse(area, color)


def fit(individual, rect=None):
    if rect == None:
        rect = (0, 0, field, field)

    fit = 0
    for i in range(rect[0], rect[2]):
        for j in range(rect[1], rect[3]):
            iPixel = individual.pixels[i, j]
            sPixel = source.pixels[i, j]
            for c in range(3):
                fit += (iPixel[c] - sPixel[c]) ** 2

    return fit


def crossover(A, B):
    pivot = random.randint(0, genelen - 1)
    if pivot < genelen // 2:
        A, B = B, A

    individual = copy(A)
    for i in range(genelen):
        if i > pivot:
            draw(individual, i, B.genes[i])

    individual.fit = fit(individual)
    return individual


def mutate(individual):
    for i in random.choices(range(genelen), k=mutation):
        individual.fit -= fit(individual, areas[i])
        draw(individual, i, randcolor())
        individual.fit += fit(individual, areas[i])


def populate(N):
    population = []
    for _ in range(N):
        individual = new()
        for i in range(genelen):
            draw(individual, i, randcolor())

        individual.fit = fit(individual)
        population.append(individual)

    return population


source = types.SimpleNamespace()
source.image = Image.open("image.png")
source.pixels = source.image.load()

field = source.image.size[0]
diameter = 32
areas = []
popcount = 5
for i in range(field // diameter):
    for j in range(field // diameter):
        p = (diameter * i, diameter * j)
        areas.append((p[0], p[1], p[0] + diameter, p[1] + diameter))

genelen = len(areas)
mutation = int(0.01 * genelen)
crosspool = int(0.5 * popcount)
pairs = list(range(popcount))


population = populate(popcount)
while True:
    for _ in range(crosspool):
        A = random.choice(pairs)
        pairs.remove(A)
        B = random.choice(pairs)
        pairs.append(A)

        child = crossover(population[A], population[B])
        mutate(child)
        population.append(child)

    population.sort(key=lambda x: x.fit)
    del population[popcount:]

    population[0].image.save("result.png")
    print(population[0].fit)
