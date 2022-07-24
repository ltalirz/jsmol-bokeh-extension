"""JSMol bokeh extension - Python extension"""
from os import path
from bokeh.core.properties import Instance, String, Dict
from bokeh.models import ColumnDataSource, LayoutDOM
from bokeh.util.compiler import TypeScript

directory = path.dirname(path.realpath(__file__))
with open(path.join(directory, 'jsmol.ts'), 'r', encoding='utf8') as f:
    TS_CODE = f.read()


# This custom extension model will have a DOM view that should layout-able in
# Bokeh layouts, so use ``LayoutDOM`` as the base class. If you wanted to create
# a custom tool, you could inherit from ``Tool``, or from ``Glyph`` if you
# wanted to create a custom glyph, etc.
class JSMol(LayoutDOM):  # pylint: disable=too-few-public-methods
    """Extension for visualizing atomic structues via JSMol."""

    # The special class attribute ``__implementation__`` should contain a string
    # of JavaScript (or CoffeeScript) code that implements the JavaScript side
    # of the custom extension model.
    __implementation__ = TypeScript(TS_CODE)

    # Below are all the "properties" for this model. Bokeh properties are
    # class attributes that define the fields (and their types) that can be
    # communicated automatically between Python and the browser. Properties
    # also support type validation. More information about properties in
    # can be found here:
    #
    #    https://bokeh.pydata.org/en/latest/docs/reference/core.html#bokeh-core-properties

    # This is a Bokeh Dict providing the JSMol "Info variable"
    # See http://wiki.jmol.org/index.php/Jmol_JavaScript_Object/Info
    info = Dict(String, String)

    # Currently (mis)using this to pass a script to be executed since there
    # doesn't seem to be a better solution (?)
    # https://groups.google.com/a/continuum.io/forum/#!topic/bokeh/0m17mNMnTys
    script_source = Instance(ColumnDataSource)

    # Path to JSMol javascript file (can be full or relative URL), e.g.
    # e.g. https://chemapps.stolaf.edu/jmol/jsmol/JSmol.min.js
    # or jsmol/JSmol.min.js
    js_url = String()
