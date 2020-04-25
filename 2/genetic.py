import cv2
import numpy as np


class Ind:
    img = None
    trg = []
    fit = 0

    def __init__(self, img=None, fit=0, trg=None):
        self.img = img
        self.fit = fit
        self.trg = trg

    def copy(self):
        return Ind(self.img.copy(), self.fit, self.trg[:])


def bnd(pnts):
    x = min(pnts, key=lambda x: x[0])
    y = min(pnts, key=lambda x: x[1])
    u = max(pnts, key=lambda x: x[0])
    v = max(pnts, key=lambda x: x[1])
    return x, y, u, v


def chk(pnt, trg):
    A = .5 * (-trg[1][1] * trg[2][0] + trg[0][1] * (-trg[1][0] + trg[2][0]) +
              trg[0][0] * (trg[1][1] - trg[2][1]) + trg[1][0] * trg[2][1])
    sign = -1 if A < 0 else 1
    s = (trg[0][1] * trg[2][0] - trg[0][0] * trg[2][1] + (trg[2][1] - trg[0][1])
         * pnt[0] + (trg[0][0] - trg[2][0]) * pnt[1]) * sign
    t = (trg[0][0] * trg[1][1] - trg[0][1] * trg[1][0] + (trg[0][1] - trg[1][1])
         * pnt[0] + (trg[1][0] - trg[0][0]) * pnt[1]) * sign

    return s > 0 and t > 0 and (s + t) < 2 * A * sign


def ins(pnt, trg):
    t1 = [trg[0], trg[1], pnt]
    t2 = [trg[0], trg[2], pnt]
    t3 = [trg[1], trg[2], pnt]
    return [t1, t1, t3]


def rclr():
    return np.random.randint(0, 255, 3)


def rpnt():
    return np.random.randint(0, S, 2)


def rgen():
    return np.random.randint(A, B, 2)


def mut(ind):
    x, y, = rpnt()
    u, v = [x, y] + rgen()

    ind.fit -= fit(ind.img, x, y, u, v)
    ind.img[x:u, y:v] = rclr()
    ind.fit += fit(ind.img, x, y, u, v)

    return ind


def fit(img, x, y, u, v):
    return np.sum(np.absolute(np.subtract(img[x:u, y:v], src[x:u, y:v])))


src = cv2.imread("source.png")

# image size
S = src.shape[0]
# population
N = 50
# rect side range
A, B = 5, 15

res = Ind(np.ones((S, S, 3)))
res.fit = fit(res.img, 0, 0, S, S)
res.trg = [[[0, 0], [S, 0], [0, S]], [0, S], [S, 0], [S, S]]

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
