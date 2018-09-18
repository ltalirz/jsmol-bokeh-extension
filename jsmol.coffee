# JavaScript (CoffeeScript) implementation for the JSmol Bokeh custom extension.
#
# "jsmol.py" contains the python counterpart.
 

# These "require" lines are similar to python "import" statements
import * as p from "core/properties"
import {LayoutDOM, LayoutDOMView} from "models/layouts/layout_dom"

# This defines some default options for JSmol
# See https://gist.github.com/jhjensen2/4701339 for more details.

Info =
  height: "100%"
  width: "100%"
  serverURL: "https://chemapps.stolaf.edu/jmol/jsmol/php/jsmol.php"
  use: "HTML5"
  j2sPath: "https://chemapps.stolaf.edu/jmol/jsmol/j2s"

#INFO =
#
#
#   width: '100%',
#   height: '100%',
#   debug: false,
#   color: "0xFFFFFF",
#   use: "HTML5",   // JAVA HTML5 WEBGL are all options
#   j2sPath: "{{server_prefix}}/static/jmol/j2s", // this needs to point to where the j2s directory is.
#   jarPath: "{{server_prefix}}/static/jmol/java",// this needs to point to where the java directory is.
#   jarFile: "JmolAppletSigned.jar",
#   isSigned: true,
#   script: "set antialiasDisplay; set frank off; load {{server_prefix}}/static/{{appname}}-structures/set.000000.xyz; {{jmolsettings}}" ,
#   serverURL: "./jmol/php/jsmol.php",
#   readyFunction: jmol_isReady,
#   disableJ2SLoadMonitor: true,
#   disableInitialConsole: true,
#   allowJavaScript: true

# To create custom model extensions that will render on to the HTML canvas
# or into the DOM, we must create a View subclass for the model.
#
# In this case we will subclass from the existing BokehJS ``LayoutDOMView``
export class JSMolView extends LayoutDOMView

  initialize: (options) ->
    super(options)

    url = "https://chemapps.stolaf.edu/jmol/jsmol/JSmol.min.js"
    script = document.createElement('script')
    script.src = url
    script.async = false
    script.onreadystatechange = script.onload = () => @_init()
    document.querySelector("head").appendChild(script)
     
  _init: () ->
    # Create a new Jmol applet using the JSmol.js API. This assumes JSmol.js has
    # already been loaded (e.g. in a custom app template). In the future Bokeh
    # models will be able to specify and load external scripts automatically.
    #
    # BokehJS Views create <div> elements by default, accessible as @el. Many
    # Bokeh views ignore this default <div>, and instead do things like draw
    # to the HTML canvas. In this case though, we use the <div> to attach a
    # Graph3d to the DOM.
    # Note: In coffescript, "@foo" is shorthand for "this.foo"

    # Prevent jmol from directly inserting into the page
    #Jmol.setDocument(0)
    html = Jmol.getAppletHtml("jmolApplet0", Info)
    #Jmol.getApplet("jmolApplet0", Info)
     
    Jmol.script(jmolApplet0,"background black;load https://dev-www.materialscloud.org/cofs/api/v2/cifs/febd2d02-5690-4a07-9013-505c9a06bc5b/content/download")
    @el.innerHTML = html
    @_applet = jmolApplet0

    # avoid creating a "deferred" applet
    # https://sourceforge.net/p/jsmol/discussion/general/thread/48083aa7/#10a6/bc1c
    @_applet._cover(false)

    # Set a listener so that when the Bokeh data source has a change
    # event, we can process the new data
    @connect(@model.data_source.change, () =>
        @_applet.setData(@get_data())
    )
     
    # Set a listener so that when the Bokeh script input changes it is executed
    @connect(@model.info_source.change, () =>
        console.log "Info source chaged"
        Jmol.script(@_applet, @model.info_source.get_column(@model.x)[0])
    )

  # This is the callback executed when the Bokeh data has an change. Its basic
  # function is to adapt the Bokeh data source to the vis.js DataSet format.
  get_data: () ->
    data = new vis.DataSet()
    source = @model.data_source
    for i in [0...source.get_length()]
      data.add({
        x:     source.get_column(@model.x)[i]
        y:     source.get_column(@model.y)[i]
        z:     source.get_column(@model.z)[i]
      })
    return data

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
    x:           [ p.String           ]
    y:           [ p.String           ]
    z:           [ p.String           ]
    script:      [ p.String           ]
    info_source: [ p.Instance         ]
    #info:        [ p.Dict             ]
    data_source: [ p.Instance         ]
  }

