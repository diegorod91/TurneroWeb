using BOL;
using BOL.Controladora;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SolucionBase
{
    public partial class AtencionBox : System.Web.UI.Page
    {
        // Guardo el ID del turno en ViewState para poder re-llamar
        private int? TurnoIdActual
        {
            get => (int?)ViewState["TurnoIdActual"];
            set => ViewState["TurnoIdActual"] = value;
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLlamar_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";
            int numeroBox = Convert.ToInt32(ddlBox.SelectedValue);
            string servicio = ddlServicio.SelectedValue;

            // Extrae el prefijo según el servicio para realizar la búsqueda
            string prefijo = servicio.Substring(0, 1);

            // 1. Invoca la lógica en BOL (esto automáticamente notificará a la TV por el Evento/SignalR)
            TurneroCola turno = CTurneroCola.LLamarTurnoSiguiente(numeroBox, prefijo, servicio);

            if (turno != null)
            {
                lblTurnoActual.Text = turno.Codigo;
                TurnoIdActual = turno.Id;
                btnRellamar.Enabled = true;
            }
            else
            {
                lblTurnoActual.Text = "---";
                TurnoIdActual = null;
                btnRellamar.Enabled = false;
                lblMensaje.Text = "No hay turnos pendientes para este servicio.";
            }

        }

        protected void btnRellamar_Click(object sender, EventArgs e)
        {
            if (TurnoIdActual.HasValue)
            {
                // Re-emite la señal a la pantalla de la TV
                CTurneroCola.ReLlamadoTurno(TurnoIdActual.Value);
                lblMensaje.Text = "Re-llamado enviado a la pantalla.";
            }
        }
    }
}