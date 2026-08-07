using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BOL.Controladora;
using BOL;

namespace TurneroWeb
{
    public partial class Totem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
      

        protected void GenerarTurno_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string prefijo = btn.CommandArgument; // ej: "E", "P", "C"
            string servicio = btn.Text;            // ej: "Envíos y Paquetes"

            TurneroCola turnero=CTurneroCola.GenerarTurno(prefijo, servicio);

            // Muestra el código en el Label del modal
            lblNumeroModal.Text = turnero.Codigo;

            // Ejecuta el script para abrir el modal Bootstrap
            ScriptManager.RegisterStartupScript(this, GetType(), "MostrarModal", "abrirModalTicket();", true);
        }
    }
}