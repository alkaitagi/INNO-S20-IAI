import cv2
import numpy as np


class Ind:
    img = None
    fit = 0

    def copy(self):
        ind = Ind()
        ind.img = self.img.copy()
        ind.fit = self.fit
        return ind


def rclr():
    return [np.random.randint(0, 255) for _ in range(3)]


def rrot():
    return np.random.uniform(-np.pi, np.pi)


def mut(ind):
    x, y = C * np.random.randint(0, G, 2)
    u, v = x + C, y + C

    # rot = rrot()
    # x, y = int(C * np.cos(rot)), int(C * np.sin(rot))

    # p1 = (pnt[0] + x, pnt[1] + y)
    # p2 = (pnt[0] - x, pnt[1] - y)

    ind.fit -= fit(ind.img, x, y, u, v)
    cv2.rectangle(ind.img, (x, y), (u, v), rclr(), -1)
    ind.fit += fit(ind.img, x, y, u, v)

    return ind


def fit(img, x, y, u, v):
    return np.sum(np.absolute(np.subtract(img[x:u, y:v], src[x:u, y:v])))


src = cv2.imread(r"C:\Users\alkaitagi\Projects\INNO-S20-IAI\2\mona.png")

# image size
S = src.shape[0]
# cell size
C = 2
# grid size
G = S // C
# population
N = 50

res = Ind()
res.img = np.ones((S, S, 3))
res.fit = fit(res.img, 0, 0, S, S)


gnr = 0
while True:
    bst = res
    for _ in range(N):
        ind = mut(res.copy())
        if ind.fit < bst.fit:
            bst = ind

    res = bst
    gnr += 1

    if not gnr % 10:
        print(gnr, ": ", res.fit)
        cv2.imwrite("result.png", res.img)
