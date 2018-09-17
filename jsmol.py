from __future__ import division

import numpy as np

from bokeh.core.properties import Instance, Dict, String
from bokeh.models import ColumnDataSource, DataSource, LayoutDOM
from bokeh.io import show, curdoc
from bokeh.models.widgets import Button
from bokeh.layouts import layout, widgetbox

with open('jsmol.coffee', 'r') as f:
  JS_CODE = f.read()

# This custom extension model will have a DOM view that should layout-able in
# Bokeh layouts, so use ``LayoutDOM`` as the base class. If you wanted to create
# a custom tool, you could inherit from ``Tool``, or from ``Glyph`` if you
# wanted to create a custom glyph, etc.
class JSMol(LayoutDOM):

    # The special class attribute ``__implementation__`` should contain a string
    # of JavaScript (or CoffeeScript) code that implements the JavaScript side
    # of the custom extension model.
    __implementation__ = JS_CODE

    # Below are all the "properties" for this model. Bokeh properties are
    # class attributes that define the fields (and their types) that can be
    # communicated automatically between Python and the browser. Properties
    # also support type validation. More information about properties in
    # can be found here:
    #
    #    https://bokeh.pydata.org/en/latest/docs/reference/core.html#bokeh-core-properties

    # This is a Bokeh ColumnDataSource that can be updated in the Bokeh
    # server by Python code
    data_source = Instance(ColumnDataSource)

    # This is a Bokeh Dict linked to the JSMol "Info"
    #info = Dict
    info_source = Instance(ColumnDataSource)

    # This is a Bokeh String that can be used to directly pass commands to "Jmol.script"
    #script = String

    # The vis.js library that we are wrapping expects data for x, y, and z.
    # The data will actually be stored in the ColumnDataSource, but these
    # properties let us specify the *name* of the column that should be
    # used for each field.
    x = String

    y = String

    z = String

x = np.arange(0, 300, 10)
y = np.arange(0, 300, 10)
xx, yy = np.meshgrid(x, y)
xx = xx.ravel()
yy = yy.ravel()
value = np.sin(xx/50) * np.cos(yy/50) * 50 + 50

source = ColumnDataSource(data=dict(x=xx, y=yy, z=value))
info_source = ColumnDataSource()

surface = JSMol(x="x", y="y", z="z", data_source=source, width=600, height=600,
       info_source=info_source)

button = Button(label='White background')
def white():
    info_source.data = dict(x=["background white;"])
button.on_click(white)

l = layout( [ surface, widgetbox(button) ] )

show(l)
curdoc().add_root(l)
