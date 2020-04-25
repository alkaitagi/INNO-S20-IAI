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
    # return [np.random.randint(0, 255) for _ in range(3)]
    return (0, 0, 0) if np.random.rand() < .5 else (255, 255, 255)


def rrot():
    return np.random.uniform(-np.pi, np.pi)


def line(x, y, rot, rad):
    a, b = int(rad * np.cos(rot)), int(rad * np.sin(rot))
    return (x + a, y + b), (x - a, y - b)


def mut(ind):
    x, y = C * np.random.randint(0, G, 2)
    u, v = x + C, y + C

    ind.fit -= fit(ind.img, x, y, u, v)

    l = np.random.randint(1, C)
    p1, p2 = line(x + Ch, y + Ch, 0, l + 1)
    cv2.line(ind.img, p1, p2, (255, 255, 255), 1)
    p1, p2 = line(x + Ch, y + Ch, 0, l)
    cv2.line(ind.img, p1, p2, rclr(), 1)

    ind.fit += fit(ind.img, x, y, u, v)

    return ind


def fit(img, x, y, u, v):
    return np.sum(np.absolute(np.subtract(img[y:v, x:u], src[y:v, x:u])))


src = cv2.imread("mona.png")

# image size
S = src.shape[0]
# cell size
C = 4
Ch = C // 2
# grid size
G = S // C
# population
N = 50

res = Ind()
res.img = 255 * np.ones((S, S, 3))
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

    if not gnr % 1:
        print(gnr, ": ", res.fit)
        cv2.imwrite("result.png", res.img)
