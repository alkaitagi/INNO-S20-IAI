import types
import random
import cv2
import numpy as np


def rclr():
    return tuple(random.randint(0, 255) for _ in range(3))


def rpnt():
    return (random.randint(0, W), random.randint(0, H))


def fit(img, x1, y1, x2, y2):
    return np.sum(np.square(np.subtract(img[x1:x2, y1:y2], src[x1:x2, y1:y2])))


def mutate(res):
    ind = types.SimpleNamespace()
    ind.img = res.img.copy()
    ind.fit = res.fit

    pnt = rpnt()
    rds = random.randint(10, 20)
    x1, x2, y1, y2 = pnt[0] - rds, pnt[0] + rds, pnt[1] - rds, pnt[1] + rds

    ind.fit -= fit(ind.img, x1, y1, x2, y2)
    ind.img = cv2.circle(ind.img, pnt, rds, rclr(), -1)
    ind.fit += fit(ind.img, x1, y1, x2, y2)

    return ind


src = cv2.imread("image.png")
W, H = src.shape[:2]
N = 5

res = types.SimpleNamespace()
res.img = np.ones((W, H, 3))
res.fit = fit(res.img, 0, 0, W, H)

gnr = 0
while True:
    bst = res
    for _ in range(N):
        ind = mutate(res)
        if ind.fit < bst.fit:
            bst = ind

    res = bst

    gnr += 1
    if gnr % 10 == 0:
        print(gnr, ": ", res.fit)
        cv2.imwrite("result.png", res.img)
