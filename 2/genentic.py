import random
from PIL import Image, ImageDraw, ImageFont


def fit(img):
    pixels = img.load()
    fit = 0

    for i in range(W):
        for j in range(H):
            gPixel = pixels[i, j]
            sPixel = sPixels[i, j]
            for c in range(3):
                fit += (gPixel[c] - sPixel[c]) ** 2

    return fit


def draw(img):
    color = tuple(random.randint(0, 255) for _ in range(3))
    string = random.choice(strings)
    point = (random.randint(-fontsize, W),
             random.randint(-fontsize, H))

    draw = ImageDraw.Draw(img)
    draw.text(point, string, font=font, fill=color)


strings = list("أبجدهوزحطيكلمنسعفصقرشتثخذ")
fontsize = 50
bounds = fontsize // 2
# strings = list("qwertyuiopasdfghjklzxcvbnm")

source = Image.open("image.png")
font = ImageFont.truetype('font.ttf', fontsize)

sPixels = source.load()
W, H = source.size

population = [Image.new('RGB', source.size, (255, 255, 255))
              for _ in range(10)]

for _ in range(5000):
    draw(population[0])
    # for item in population:
    #     draw(item)

population[0].save("gen_image.png")
