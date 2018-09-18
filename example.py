from bokeh.models import ColumnDataSource
from bokeh.io import show, curdoc
from bokeh.models.widgets import Button
from bokeh.layouts import layout, widgetbox

from jsmol import JSMol

source = ColumnDataSource()
info_source = ColumnDataSource()

surface = JSMol(
    x="x",
    y="y",
    z="z",
    data_source=source,
    width=600,
    height=600,
    info_source=info_source)

button = Button(label='White background')


def white():
    info_source.data = dict(x=["background white;"])


button.on_click(white)

ly = layout([surface, widgetbox(button)])

show(ly)
curdoc().add_root(ly)
