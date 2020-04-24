import cv2
import numpy as np


class Ind:
    img = None
    fit = 0

    def __init__(self, img=None, fit=0):
        self.img = img
        self.fit = fit

    def copy(self):
        return Ind(self.img.copy(), self.fit)


def rclr():
    return np.random.randint(0, 255, 3)


def rpnt():
    return np.random.randint(0, S, 2)


def rgen():
    return np.random.randint(A, B, 2)


def mutate(ind):
    x, y, = rpnt()
    u, v = [x, y] + rgen()

    ind.fit -= fit(ind.img, x, y, u, v)
    ind.img[x:u, y:v] = rclr()
    ind.fit += fit(ind.img, x, y, u, v)

    return ind


def fit(img, x, y, u, v):
    return np.sum(np.square(np.subtract(img[x:u, y:v], src[x:u, y:v])))


src = cv2.imread("test.png")

# image size
S = src.shape[0]
# population
N = 50
# rect side range
A, B = 2, 4

res = Ind(np.ones((S, S, 3)))
res.fit = fit(res.img, 0, 0, S, S)

gnr = 0
while True:
    bst = res
    for _ in range(N):
        ind = mutate(res.copy())
        if ind.fit < bst.fit:
            bst = ind

    res = bst
    gnr += 1

    if not gnr % 10:
        print(gnr, ": ", res.fit)
        cv2.imwrite("result.png", res.img)
