import types
import random
import cv2
import numpy as np


def randcolor():
    return tuple(random.randint(0, 255) for _ in range(3))


def draw(individual, i, color):
    radius = diameter // 2
    individual.image = cv2.circle(
        individual.image, (areas[i][0] + radius, areas[i][1] + radius), radius, color, -1)
    individual.genes[i] = color


def fit(individual, rect=None):
    if rect == None:
        rect = (0, 0, field, field)

    fit = 0
    for i in range(rect[0], rect[2]):
        for j in range(rect[1], rect[3]):
            iPixel = individual.image[i, j]
            sPixel = source[i, j]
            for c in range(3):
                fit += (iPixel[c] - sPixel[c]) ** 2

    return fit


def crossover(A, B):
    pivot = random.randint(0, genelen - 1)
    if pivot < genelen // 2:
        A, B = B, A

    individual = types.SimpleNamespace()
    individual.image = A.image.copy()
    individual.genes = A.genes[:]
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
        individual = types.SimpleNamespace()
        individual.image = np.zeros((field, field, 3))
        individual.genes = [None] * genelen
        for i in range(genelen):
            draw(individual, i, randcolor())

        individual.fit = fit(individual)
        population.append(individual)

    return population


source = cv2.imread("test.png")
field = source.shape[0]
diameter = 4
areas = []
popcount = 10
for i in range(field // diameter):
    for j in range(field // diameter):
        p = (diameter * i, diameter * j)
        areas.append((p[0], p[1], p[0] + diameter, p[1] + diameter))

genelen = len(areas)
mutation = int(0.02 * genelen)
crosspool = int(0.25 * popcount)
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

    cv2.imwrite("result.png", population[0].image)
    print(population[0].fit)
