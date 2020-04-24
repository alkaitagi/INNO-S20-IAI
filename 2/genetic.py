import types
import cv2
import numpy as np


def rclr():
    return tuple(np.random.randint(0, 255, 3))


def rpnt():
    return tuple(np.random.randint(0, S, 2))


def fit(img, x, y, u, v):
    return np.sum(np.square(np.subtract(img[x:u, y:v], src[x:u, y:v])))


def mutate(ind):
    x, y, = rpnt()
    u, v = (x, y) + np.random.randint(5, 15, 2)

    ind.fit -= fit(ind.img, x, y, u, v)
    ind.img[x:u, y:v] = rclr()
    ind.fit += fit(ind.img, x, y, u, v)

    return ind


src = cv2.imread("mona.png")
S = src.shape[0]
N = 50

res = types.SimpleNamespace()
res.img = np.ones((S, S, 3))
res.fit = fit(res.img, 0, 0, S, S)

gnr = 0
while True:
    bst = res
    for _ in range(N):
        ind = types.SimpleNamespace()
        ind.img = res.img.copy()
        ind.fit = res.fit
        mutate(ind)
        if ind.fit < bst.fit:
            bst = ind

    res = bst
    gnr += 1

    if not gnr % 10:
        print(gnr, ": ", res.fit)
        cv2.imwrite("result.png", res.img)
