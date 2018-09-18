# JSmol bokeh extension

Custom extension to [bokeh](https://bokeh.pydata.org/en/latest/) for [JSmol](https://sourceforge.net/projects/jsmol/).

Based on the [surface3d example](https://bokeh.pydata.org/en/latest/docs/user_guide/extensions_gallery/wrapping.html)
and [extension widget](https://bokeh.pydata.org/en/latest/docs/user_guide/extensions_gallery/widget.html#userguide-extensions-examples-widget)


## Usage

```
git clone git@github.com:ltalirz/jsmol-bokeh-extension.git
cd jsmol-bokeh-extension
pip install bokeh

# run locally (button won't work)
python jsmol.py

# run using bokeh server (button should work)
bokeh serve jsmol.py --show
```

## Links

 * the [JSmol Info dict](http://wiki.jmol.org/index.php/Jmol_JavaScript_Object/Info)
