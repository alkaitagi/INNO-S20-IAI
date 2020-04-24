import cv2
import numpy as np

image = cv2.imread("test.png")
imge2 = image.copy()
cv2.line(imge2, (0, 0), (30, 40), (255, 255, 0, 100), 2)
cv2.addWeighted(image, .5, imge2, 0.5, 0, image)
cv2.imwrite("result.png", image)
