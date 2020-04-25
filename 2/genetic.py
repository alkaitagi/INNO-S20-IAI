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


def line(x, y, rot, lng):
    if not rot:
        return (x - lng, y), (x + lng, y)
    elif rot == .5:
        return (x, y - lng), (x, y + lng)
    elif rot == .25:
        return (x - lng, y - lng), (x + lng, y + lng)
    else:
        return (x - lng, y + lng), (x + lng, y - lng)
        


def mut(ind):
    x = T // 2 + T * np.random.randint(0, H // T)
    y = T // 2 + T * np.random.randint(0, W // T)

    lng = T * np.random.randint(L[0], L[1])
    rot = np.random.choice([-.25, 0, .25, .5])
    col = [np.random.randint(0, 255) for _ in range(3)]
    pt1, pt2 = line(x, y, rot, lng)

    ind.fit -= fit(ind.img, x - lng, y - lng, x + lng, y + lng)
    cv2.line(ind.img, pt1, pt2, col, T)
    ind.fit += fit(ind.img, x - lng, y - lng, x + lng, y + lng)

    return ind


def fit(img, x, y, u, v):
    return np.sum(np.absolute(np.subtract(img[y:v, x:u], src[y:v, x:u])))


src = cv2.imread("source.png")

# radius range
L = (4, 12)
# image size
W, H = src.shape[:2]
# thickness
T = 2
# population
N = 1


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
