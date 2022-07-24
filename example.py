"""Exampel of using jsmol bokeh widget."""
from bokeh.models import ColumnDataSource
from bokeh.io import show, curdoc
from bokeh.models.widgets import Button, TextInput
from bokeh.layouts import layout, widgetbox

from jsmol_bokeh_extension import JSMol

script_source = ColumnDataSource()

info = dict(
    height='100%',
    width='100%',
    serverURL='https://chemapps.stolaf.edu/jmol/jsmol/php/jsmol.php',
    use='HTML5',
    j2sPath='https://chemapps.stolaf.edu/jmol/jsmol/j2s',
    script=
    'background black;load https://chemapps.stolaf.edu/jmol/jsmol-2013-09-18/data/caffeine.mol',
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
    """Run JSMol script specified by user."""
    # pylint: disable=unsupported-assignment-operation
    script_source.data['script'] = [inp_script.value]


button.on_click(run_script)

ly = layout([applet, widgetbox(button, inp_script)])
curdoc().add_root(ly)

show(ly)
