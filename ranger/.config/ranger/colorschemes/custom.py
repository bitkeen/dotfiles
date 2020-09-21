from ranger.colorschemes.default import Default
from ranger.gui.color import black, bold, white

class Scheme(Default):

    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.in_titlebar and context.tab:
            if context.good:
                fg = black
                bg = white
            attr &= ~bold

        return fg, bg, attr
