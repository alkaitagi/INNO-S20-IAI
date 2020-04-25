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
    c = np.random.randint(0, 256)
    return (c, c, c)
    # return [np.random.randint(0, 255) for _ in range(3)]


def rrot():
    return (-1 if np.random.rand() < .5 else 1) * .25 * np.pi
    # return 0 if np.random.rand() < .5 else .5 * np.pi


def line(x, y, rot, rad):
    a, b = int(rad * np.cos(rot)), int(rad * np.sin(rot))
    return (x + a, y + b), (x - a, y - b)


def mut(ind):
    x = G * np.random.randint(0, W // G)
    y = np.random.randint(0, H // G)

    l = np.random.randint(L[0], L[1])
    r = rrot()

    ind.fit -= fit(ind.img, x - l, y - l, x + l, y + l)

    p1, p2 = line(x, y, r, l)
    cv2.line(ind.img, p1, p2, rclr(), 1)

    ind.fit += fit(ind.img, x - l, y-l, x + l, y + l)

    return ind


def fit(img, x, y, u, v):
    return np.sum(np.absolute(np.subtract(img[y:v, x:u], src[y:v, x:u])))


src = cv2.imread(r"C:\Users\alkaitagi\Projects\INNO-S20-IAI\2\small.png")

# radius range
L = (2, 8)
# image size
W, H = src.shape[:2]
# gap
G = 2
# grid size
R, C = W // G, H // G
# population
N = 50

res = Ind()
res.img = 255 * np.ones((W, H, 3))
res.fit = fit(res.img, 0, 0, W, H)


gnr = 0
while True:
    bst = res
    for _ in range(N):
        ind = mut(res.copy())
        if ind.fit < bst.fit:
            bst = ind

    res = bst
    gnr += 1

    if not gnr % 100:
        print(gnr, ": ", res.fit)
        cv2.imwrite("result.png", res.img)
