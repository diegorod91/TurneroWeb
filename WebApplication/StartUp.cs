using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Owin;
using BOL.Controladora;

[assembly: OwinStartup(typeof(TurneroWeb.StartUp))]
namespace TurneroWeb
{

    public class StartUp
    {
        public void Configuration(IAppBuilder app)
        {
            // Configuración de OWIN
            app.MapSignalR();
            //se escucha el evento de turno llamado y se notifica a los clientes conectados en TV
            CTurneroCola.OnTurnoLlamado += (codigo, box) =>
            {
                var context = GlobalHost.ConnectionManager.GetHubContext<TurnoHub>();
                context.Clients.All.turnoLlamado(codigo, box);
            }; 
        }
    }
}