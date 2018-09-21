# JavaScript (CoffeeScript) implementation for the JSmol Bokeh custom extension.
#
# "jsmol.py" contains the python counterpart.
 

# These "require" lines are similar to python "import" statements
import * as p from "core/properties"
import {LayoutDOM, LayoutDOMView} from "models/layouts/layout_dom"

# This defines some default options for JSmol
# See https://gist.github.com/jhjensen2/4701339 for more details.

INFO =
  height: "100%"
  width: "100%"
  serverURL: "https://chemapps.stolaf.edu/jmol/jsmol/php/jsmol.php"
  use: "HTML5"
  j2sPath: "https://chemapps.stolaf.edu/jmol/jsmol/j2s"
  script: "background black;load https://dev-www.materialscloud.org/cofs/api/v2/cifs/febd2d02-5690-4a07-9013-505c9a06bc5b/content/download"
  #disableJ2SLoadMonitor: true

# To create custom model extensions that will render on to the HTML canvas
# or into the DOM, we must create a View subclass for the model.
#
# In this case we will subclass from the existing BokehJS ``LayoutDOMView``
export class JSMolView extends LayoutDOMView

  initialize: (options) ->
    super(options)

    url = @model.js_url
    if not url then url = "https://chemapps.stolaf.edu/jmol/jsmol/JSmol.min.js"
    script = document.createElement('script')
    script.src = url
    script.async = false
    script.onreadystatechange = script.onload = () => @_init()
    document.querySelector("head").appendChild(script)
     
  _init: () ->
    # Create a new Jmol applet using the JSmol.js API. This assumes JSmol.js has
    # already been loaded.
    # models will be able to specify and load external scripts automatically.
    #
    # BokehJS Views create <div> elements by default, accessible as @el.
    # Note: In coffescript, "@foo" is shorthand for "this.foo"

    # if no info dict provided, use reasonable default
    if not @model.info then @model.info = INFO

    # returns html + assigns applet object to "jmolApplet0" variable
    html = Jmol.getAppletHtml("jmolApplet0", @model.info)
    @_applet = jmolApplet0
    @el.innerHTML = html

    # avoid creating a "deferred" applet
    # https://sourceforge.net/p/jsmol/discussion/general/thread/48083aa7/#10a6/bc1c
    @_applet._cover(false)

    # Set a listener so that when the Bokeh script input changes it is executed
    @connect(@model.script_source.properties.data.change, () =>
        console.log "Script source changed"
        Jmol.script(@_applet, @model.script_source.get_column('script')[0])
    )

  ## This is the callback executed when the Bokeh data has an change. Its basic
  ## function is to adapt the Bokeh data source to the vis.js DataSet format.
  #get_data: () ->
  #  data = new vis.DataSet()
  #  source = @model.data_source
  #  for i in [0...source.get_length()]
  #    data.add({
  #      x:     source.get_column(@model.x)[i]
  #      y:     source.get_column(@model.y)[i]
  #      z:     source.get_column(@model.z)[i]
  #    })
  #  return data

# We must also create a corresponding JavaScript BokehJS model subclass to
# correspond to the python Bokeh model subclass. In this case, since we want
# an element that can position itself in the DOM according to a Bokeh layout,
# we subclass from ``LayoutDOM``
export class JSMol extends LayoutDOM

  # This is usually boilerplate. In some cases there may not be a view.
  default_view: JSMolView

  # The ``type`` class attribute should generally match exactly the name
  # of the corresponding Python class.
  type: "JSMol"

  # The @define block adds corresponding "properties" to the JS model. These
  # should basically line up 1-1 with the Python model class. Most property
  # types have counterparts, e.g. ``bokeh.core.properties.String`` will be
  # ``p.String`` in the JS implementatin. Where the JS type system is not yet
  # as rich, you can use ``p.Any`` as a "wildcard" property type.
  @define {
    script_source: [ p.Instance         ]
    info:          [ p.Any              ]
    js_url:        [ p.String           ]
  }

