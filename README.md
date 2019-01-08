# JSmol bokeh extension

Custom extension to [bokeh](https://bokeh.pydata.org/en/latest/) for [JSmol](https://sourceforge.net/projects/jsmol/).

 * Based on the [surface3d example](https://bokeh.pydata.org/en/latest/docs/user_guide/extensions_gallery/wrapping.html)
and [extension widget](https://bokeh.pydata.org/en/latest/docs/user_guide/extensions_gallery/widget.html#userguide-extensions-examples-widget)
 * works both using bokeh and bokeh server

## Installation

```
pip install jsmol-bokeh-extension
```

## Usage

Below a complete `example.py` demonstrating how to use the jsmol bokeh extension:
```python
rom bokeh.models import ColumnDataSource
from bokeh.io import show, curdoc
from bokeh.models.widgets import Button, TextInput
from bokeh.layouts import layout, widgetbox

from jsmol_bokeh_extension import JSMol

script_source = ColumnDataSource()

info = dict(
    height="100%",
    width="100%",
    serverURL="https://chemapps.stolaf.edu/jmol/jsmol/php/jsmol.php",
    use="HTML5",
    j2sPath="https://chemapps.stolaf.edu/jmol/jsmol/j2s",
    script=
    "background black;load https://chemapps.stolaf.edu/jmol/jsmol-2013-09-18/data/caffeine.mol",
)

applet = JSMol(
    width=600,
    height=600,
    script_source=script_source,
    info=info,
)

button = Button(label='Execute')
inp_script = TextInput(value='background white;')


def run_script():
    script_source.data['script'] = [inp_script.value]


button.on_click(run_script)

ly = layout([applet, widgetbox(button, inp_script)])

show(ly)
curdoc().add_root(ly)
```

Note: The example can be run both using bokeh and bokeh server:
```
# run locally (displays structure but button won't work)
python example.py

# run using bokeh server (displays structure and button should work)
bokeh serve example.py --show
```

## Links

 * the [JSmol Info dict](http://wiki.jmol.org/index.php/Jmol_JavaScript_Object/Info)
