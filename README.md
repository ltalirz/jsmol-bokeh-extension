[![Build Status](https://travis-ci.org/ltalirz/jsmol-bokeh-extension.svg?branch=master)](https://travis-ci.org/ltalirz/jsmol-bokeh-extension)

# JSmol bokeh extension

This extension lets you visualize atomic structures in [bokeh](https://bokeh.pydata.org/en/latest/) using [JSmol](https://sourceforge.net/projects/jsmol/).

## Features

 * Works both using bokeh and bokeh server
 * See [example.html](https://rawcdn.githack.com/ltalirz/jsmol-bokeh-extension/f0d16dc8f330ab79dc8882c4d1fcfed268050893/example.html). Structure displays in standalone html, button will start working in bokeh server

## Prerequisites

 * python 2.7 or later
 * NodeJS 6.10 or later (see the [bokeh developer documentation](https://bokeh.pydata.org/en/1.0.4/docs/dev_guide/setup.html) for instructions)

Note: As of 2019-06, NodeJS is required to compile the `.ts` / `.coffee` files.
Once bokeh provides guidelines on [how to bundle compiled javascript](https://github.com/bokeh/bokeh/issues/5345), the NodeJS dependency may be dropped.

## Installation
#### Versioning

 * jsmol-bokeh-extension 0.1.x works with bokeh < 1.1 (written in CoffeScript)
 * jsmol-bokeh-extension 0.2 and above works with bokeh >= 1.1 (written in TypeScript)

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

 * This bokeh extension is based on the [surface3d example](https://bokeh.pydata.org/en/latest/docs/user_guide/extensions_gallery/wrapping.html)
and [extension widget](https://bokeh.pydata.org/en/latest/docs/user_guide/extensions_gallery/widget.html#userguide-extensions-examples-widget)
 * See also the [JSmol Info dict](http://wiki.jmol.org/index.php/Jmol_JavaScript_Object/Info)
