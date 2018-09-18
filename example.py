from bokeh.models import ColumnDataSource
from bokeh.io import show, curdoc
from bokeh.models.widgets import Button, TextInput
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

button = Button(label='Execute')
inp_script = TextInput(value='background white;')


def white():
    info_source.data = dict(x=[inp_script.value])


button.on_click(white)

ly = layout([surface, widgetbox(button, inp_script)])

show(ly)
curdoc().add_root(ly)
