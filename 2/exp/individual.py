from PIL import Image, ImageDraw, ImageFont


class Individual:

    def __init__(self, W, H, genelen):
        self.image = Image.new('RGB', (W, H), (255, 255, 255))
        self.pixels = self.image.load()
        self.draw = ImageDraw.Draw(self.image)
        self.genes = [None] * genelen
