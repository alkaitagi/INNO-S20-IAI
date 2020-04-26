import cv2
import numpy as np
import json


class Cnf:
    ppl = 10
    clr = False
    rtn = [-.25, 25]
    thk = [1, 2]
    lng = [4, 12]

    def __init__(self, J):
        cnf = json.loads(J)
        self.ppl = cnf["ppl"]
        self.clr = cnf["clr"]

        self.rtn = []
        if cnf["axi"]:
            self.rtn += [0, 2]
        if cnf["dgn"]:
            self.rtn += [1, 3]

        self.thk = cnf["thk"]
        self.lng = cnf["lng"]

    def var(self):
        if self.clr:
            C = [np.random.randint(0, 256) for _ in range(3)]
        else:
            C = [np.random.randint(0, 256)] * 3

        T = np.random.randint(self.thk[0], self.thk[1] + 1)
        L = np.random.randint(self.lng[0], self.lng[1] + 1)
        R = np.random.choice(self.rtn)

        return C, T, L, R


class Ind:
    img = None
    fit = 0

    def __init__(self, img=None, fit=0):
        self.img = img
        self.fit = fit

    def cln(self):
        return Ind(self.img.copy(), self.fit)


def lin(y, x, R, L):
    if not R:
        return y, x - L, y, x + L
    elif R == 2:
        return y - L, x,  y + L, x
    elif R == 1:
        return y - L, x - L, y + L, x + L
    else:
        return y + L, x - L, y - L, x + L


def mut(ind):
    C, T, L, R = cnf.var()

    y, x = [T // 2 + T * np.random.randint(0, i // T) for i in [H, W]]
    b, a, d, c = lin(y, x, R, L)

    ind.fit -= fit(ind.img, T, b, a, d, c)
    cv2.line(ind.img, (a, b), (c, d), C, T)
    ind.fit += fit(ind.img, T, b, a, d, c)

    return ind


def fit(img, T, b, a, d, c):
    b, d = np.sort(np.clip([b, d], 0, H))
    if b == d:
        d += T

    a, c = np.sort(np.clip([a, c], 0, W))
    if a == c:
        c += T

    return np.sum(np.absolute(np.subtract(img[b:d, a:c], src[b:d, a:c])))


# source image
src = cv2.imread("src.png")
# image size
H, W = src.shape[:2]
# configuration
cnf = Cnf(open("cnf.json", "r").read())


rsl = Ind(255 * np.ones((H, W, 3)))
rsl.fit = fit(rsl.img, 1, 0, 0, H, W)


gnr = 0
while True:
    bst = rsl
    for _ in range(cnf.ppl):
        ind = mut(rsl.cln())
        if ind.fit < bst.fit:
            bst = ind.cln()

    rsl = bst
    gnr += 1

    if not gnr % 100:
        print(gnr, ":", rsl.fit)
        cv2.imwrite("rsl.png", rsl.img)
