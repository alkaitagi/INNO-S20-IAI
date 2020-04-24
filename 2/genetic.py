import types
import random
import cv2
import numpy as np


def randcolor():
    return np.round(255 * np.random.rand(1, 3))


def draw(ind, i, color):
    ind.gns[i] = color

    # radius = diameter // 2
    # individual.image = cv2.circle(
    #     individual.image, (areas[i][0] + radius, areas[i][1] + radius), radius, color, -1)

    x1, y1, x2, y2 = areas[i]
    ind.img[x1:x2, y1:y2] = color


def fit(ind, rect=None):
    if rect == None:
        rect = (0, 0, size, size)

    x1, y1, x2, y2 = rect
    A = ind.img[x1:x2, y1:y2]
    B = src[x1:x2, y1:y2]

    return np.sum(np.square(np.subtract(A, B)))


def crossover(A, B):
    pivot = random.randint(0, genelen - 1)
    if pivot < genelen // 2:
        A, B = B, A

    ind = types.SimpleNamespace()
    ind.img = A.img.copy()
    ind.gns = A.gns[:]
    for i in range(genelen):
        if i > pivot:
            draw(ind, i, B.gns[i])

    ind.fit = fit(ind)
    return ind


def mutate(ind):
    for i in random.choices(range(genelen), k=mutation):
        ind.fit -= fit(ind, areas[i])

        color = np.random.uniform(-1, 1, 3)
        color = np.multiply(color, randcolor())
        color = np.add(ind.gns[i], color)
        color = np.clip(color, 0, 255)
        draw(ind, i, color)

        ind.fit += fit(ind, areas[i])


def populate(N):
    pop = []
    for _ in range(N):
        ind = types.SimpleNamespace()
        ind.img = np.zeros((size, size, 3))
        ind.gns = [None] * genelen
        for i in range(genelen):
            draw(ind, i, randcolor())

        ind.fit = fit(ind)
        pop.append(ind)

    return pop


src = cv2.imread("image.png")
size = src.shape[0]
diameter = 32
areas = []
popcount = 10
for i in range(size // diameter):
    for j in range(size // diameter):
        p = (diameter * i, diameter * j)
        areas.append((p[0], p[1], p[0] + diameter, p[1] + diameter))

genelen = len(areas)
mutation = int(0.01 * genelen)
crosspool = int(0.5 * popcount)
pairs = list(range(popcount))


pop = populate(popcount)
gnr = 0
while True:
    gnr += 1

    for _ in range(crosspool):
        A = random.choice(pairs)
        pairs.remove(A)
        B = random.choice(pairs)
        pairs.append(A)

        new = crossover(pop[A], pop[B])
        mutate(new)
        pop.append(new)

    pop.sort(key=lambda x: x.fit)
    del pop[popcount:]


    if gnr % 10 == 0:
        print(gnr, ": ", pop[0].fit)
        cv2.imwrite("result.png", pop[0].img)
        # cv2.imshow("result", pop[0].img)
        # cv2.waitKey(100)
