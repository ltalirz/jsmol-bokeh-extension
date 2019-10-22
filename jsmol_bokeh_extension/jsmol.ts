// Model wrapping JSmol.
//
// "jsmol.py" contains the python counterpart.
declare var Jmol: any;
declare var jmolApplet0: any;
 

// These "require" lines are similar to python "import" statements
import {LayoutDOM, LayoutDOMView} from "models/layouts/layout_dom"
import {LayoutItem} from "core/layout"
import {ColumnDataSource} from "models/sources/column_data_source"
import * as p from "core/properties"


// This defines some default options for JSmol
// See https://gist.github.com/jhjensen2/4701339 for more details.
const INFO = {
  height: "100%",
  width: "100%",
  serverURL: "https://chemapps.stolaf.edu/jmol/jsmol/php/jsmol.php",
  use: "HTML5",
  j2sPath: "https://chemapps.stolaf.edu/jmol/jsmol/j2s",
  script: "background black;load https://dev-www.materialscloud.org/cofs/api/v2/cifs/febd2d02-5690-4a07-9013-505c9a06bc5b/content/download",
  //disableJ2SLoadMonitor: true,
}

// To create custom model extensions that will render on to the HTML canvas
// or into the DOM, we must create a View subclass for the model.
//
// In this case we will subclass from the existing BokehJS ``LayoutDOMView``
export class JSMolView extends LayoutDOMView {
  model: JSMol
  private _applet: any

  initialize(): void {
      super.initialize()
  
      var url = this.model.js_url
      if (! url) {
        url = "https://chemapps.stolaf.edu/jmol/jsmol/JSmol.min.js"
      }
      const script = document.createElement('script')
      script.src = url
      script.async = false
      script.onload = () => this._init()
      //script.onreadystatechange = (script.onload = () => this._init())
      //script.onreadystatechange = script.onload
      document.querySelector("head")!.appendChild(script)
  }
     
  private _init(): void {
    // Create a new Jmol applet using the JSmol.js API. This assumes JSmol.js
    // has already been loaded.
    // Models will be able to specify and load external scripts automatically.
    //
    // BokehJS Views create <div> elements by default, accessible as this.el.

    // if no info dict provided, use reasonable default
    if (! this.model.info) {
      this.model.info = INFO
    }

    // disable usage tracker - this conflicts with cross-site-scripting policies when served over https
    delete Jmol._tracker

    // returns html + assigns applet object to "jmolApplet0" variable
    var html = Jmol.getAppletHtml("jmolApplet0", this.model.info)
    this._applet = jmolApplet0
    this.el.innerHTML = html

    // avoid creating a "deferred" applet
    // https://sourceforge.net/p/jsmol/discussion/general/thread/48083aa7///10a6/bc1c
    this._applet._cover(false)

    // Set a listener so that when the Bokeh script input changes it is executed
    this.connect(this.model.script_source.properties.data.change, () => {
        console.log("Script source changed")
        Jmol.script(this._applet, this.model.script_source.get_column('script')![0])
    })
  }

  get child_models(): LayoutDOM[] {
    return []
  }

  _update_layout(): void {
    this.layout = new LayoutItem()
    this.layout.set_sizing(this.box_sizing())
  }
}


// We must also create a corresponding JavaScript BokehJS model subclass to
// correspond to the python Bokeh model subclass. In this case, since we want
// an element that can position itself in the DOM according to a Bokeh layout,
// we subclass from ``LayoutDOM``
export namespace JSMol {
    export type Attrs = p.AttrsOf<Props>
        
    export type Props = LayoutDOM.Props & {
        js_url: p.Property<string>,
        script_source: p.Property<ColumnDataSource>,
        info: p.Property<any>
    }
}


export interface JSMol extends JSMol.Attrs {}

export class JSMol extends LayoutDOM {
    properties: JSMol.Props

    constructor(attrs?: Partial<JSMol.Attrs>) {
        super(attrs)
    }

    static initClass() {
     // The ``type`` class attribute should generally match exactly the name
    // of the corresponding Python class.
    this.prototype.type = "JSMol"

     // This is usually boilerplate. In some cases there may not be a view.
    this.prototype.default_view = JSMolView


    // The define block adds corresponding "properties" to the JS model. These
    // should basically line up 1-1 with the Python model class. Most property
    // types have counterparts, e.g. ``bokeh.core.properties.String`` will be
    // ``p.String`` in the JS implementation. Where the JS type system is not yet
    // as rich, you can use ``p.Any`` as a "wildcard" property type.
    this.define<JSMol.Props>({
      script_source: [ p.Instance         ],
      info:          [ p.Any              ],
      js_url:        [ p.String           ],
    })
  }
}
JSMol.initClass()
