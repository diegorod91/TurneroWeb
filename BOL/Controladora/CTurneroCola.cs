using BOL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;


namespace BOL.Controladora
{
    public class CTurneroCola
    {
        public static event Action<string, int> OnTurnoLlamado;
        public static TurneroCola GenerarTurno(string prefijo, string servicio)
        {
            using (var db = new EDM())
            {
                DateTime hoy = DateTime.Today;

                // 1. Cuenta cuántos turnos de ESTE servicio se crearon HOY
                int cantidadHoy = db.TurneroCola
                    .Count(t => t.Servicio == servicio && DbFunctions.TruncateTime(t.FechaHoraEmision) == hoy);

                int siguienteNumero = cantidadHoy + 1;

                // 3. Formatea el código (ej: "E" + 1 -> "E001")
                string codigoGenerado = $"{prefijo}{siguienteNumero:D3}";

                var nuevoTurno = new TurneroCola
                {
                    Codigo = codigoGenerado,
                    Servicio = servicio,
                    FechaHoraEmision = DateTime.Now,
                    Estado = "En Espera"
                };

                db.TurneroCola.Add(nuevoTurno);
                db.SaveChanges();

                return nuevoTurno;
            }
        }


        public static TurneroCola LLamarTurnoSiguiente(int puesto, string prefijo, string servicio)
        {
            using (var db = new EDM())
            {
                DateTime hoy = DateTime.Today;

                var turnoSiguiente = db.TurneroCola
                    .Where(t => t.Servicio == servicio && t.Estado == "En Espera" && DbFunctions.TruncateTime(t.FechaHoraEmision) == hoy)
                    .OrderBy(t => t.FechaHoraEmision)
                    .FirstOrDefault();

                if (turnoSiguiente != null)
                {
                    turnoSiguiente.Estado = "Llamado";
                    turnoSiguiente.BoxAsignado = puesto;
                    turnoSiguiente.FechaHoraLlamado = DateTime.Now;
                    db.SaveChanges();
                    
                    // EMITIR EN TIEMPO REAL A TODAS LAS PANTALLAS TV CONNECTADAS
                    OnTurnoLlamado?.Invoke(turnoSiguiente.Codigo, puesto);
                }
                return turnoSiguiente;
            }

        }

        public static TurneroCola ReLlamadoTurno(int idturno)
        {
            using (var db = new EDM())
            {
                var turno = db.TurneroCola.Find(idturno);
                if (turno != null && turno.BoxAsignado.HasValue)
                {
                    turno.FechaHoraLlamado = DateTime.Now;
                    db.SaveChanges();
                    // Al re-llamar, se emite nuevamente a la pantalla de TV
                    OnTurnoLlamado?.Invoke(turno.Codigo, turno.BoxAsignado.Value);
                }
                return turno;
            }
        }

    }
}
