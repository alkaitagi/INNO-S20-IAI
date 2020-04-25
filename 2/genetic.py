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


def line(y, x, rot, lng):
    if not rot:
        return y, x - lng, y, x + lng
    elif rot == .5:
        return y - lng, x,  y + lng, x
    elif rot == .25:
        return y - lng, x - lng, y + lng, x + lng
    else:
        return y + lng, x - lng, y - lng, x + lng


def mut(ind):
    y = T // 2 + T * np.random.randint(0, H // T)
    x = T // 2 + T * np.random.randint(0, W // T)

    lng = T * np.random.randint(L[0], L[1])
    rot = np.random.choice([-.25, 0, .25, .5])
    # col = [np.random.randint(0, 256) for _ in range(3)]
    col = [np.random.randint(0, 256)] * 3

    b, a, d, c = line(y, x, rot, lng)

    ind.fit -= fit(ind.img, b, a, d, c)
    cv2.line(ind.img, (a, b), (c, d), col, T)
    ind.fit += fit(ind.img, b, a, d, c)

    return ind


def fit(img, b, a, d, c):
    b, d = np.sort(np.clip([b, d], 0, H))
    if b == d:
        d += 1

    a, c = np.sort(np.clip([a, c], 0, W))
    if a == c:
        c += 1

    return np.sum(np.absolute(np.subtract(img[b:d, a:c], src[b:d, a:c])))


# source image
src = cv2.imread(r"C:\Users\alkaitagi\Projects\INNO-S20-IAI\2\mona.png")
# image size
H, W = src.shape[:2]
# stoke radius range (ratio to thickness)
L = (2, 4)
# stroke thickness
T = 1
# variants population
N = 5


res = Ind()
res.img = 255 * np.ones((H, W, 3))
res.fit = fit(res.img, 0, 0, H, W)


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
