<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PantallaTV.aspx.cs" Inherits="SolucionBase.PantallaTV" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Pantalla de Turnos</title>
    <link href="bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #111827;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow: hidden;
            height: 100vh;
        }

        .card-principal {
            background-color: #1f2937;
            border: 4px solid #ffd800;
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
        }

        .label-turno-actual {
            font-size: 8.5rem;
            font-weight: 900;
            color: #ffd800;
            line-height: 1;
            letter-spacing: 2px;
        }

        .label-box-actual {
            font-size: 5rem;
            font-weight: 800;
            color: #ffffff;
            margin-top: 20px;
        }

        .tabla-historial {
            width: 100%;
            background-color: #1f2937;
            border-radius: 15px;
            overflow: hidden;
        }

        .tabla-historial th {
            background-color: #374151;
            color: #ffd800;
            font-size: 1.5rem;
            text-align: center;
            padding: 15px;
        }

        .tabla-historial td {
            font-size: 2.2rem;
            font-weight: bold;
            text-align: center;
            padding: 15px;
            border-bottom: 1px solid #374151;
        }

        .parpadeo {
            animation: blink 0.8s iteration-count 5;
        }

        @keyframes blink {
            50% { opacity: 0.3; }
        }
    </style>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.4.1.min.js") %>"></script>
    <%--<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>--%>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid p-4">
            <div class="row">
                <div class="col-md-8">
                    <div class="card-principal" id="contenedorPrincipal">
                        <h2 class="text-uppercase tracking-wider text-muted mb-3" style="font-size: 2rem;">Turno Llamado</h2>
                        <div id="lblCodigoTV" class="label-turno-actual">---</div>
                        <div id="lblBoxTV" class="label-box-actual">ESPERANDO...</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <h3 class="text-center text-uppercase mb-3" style="color: #ffd800; font-size: 1.8rem; font-weight: bold;">Últimos Llamados</h3>
                    <table class="tabla-historial">
                        <thead>
                            <tr>
                                <th>TURNO</th>
                                <th>PUESTO</th>
                            </tr>
                        </thead>
                        <tbody id="tbHistorial">
                            <tr><td colspan="2" class="text-muted fs-4">Sin turnos recientes</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        var historial = [];

        $(function () {
            $.connection.hub.logging = true;

            var hub = $.connection.turnoHub;

            if (!hub) {
                console.error("Error: No se pudo instanciar 'turnoHub'. Verifica que /signalr/hubs esté cargando.");
                return;
            }

            // Suscripción al evento emitido desde C#
            hub.client.TurnoLlamado = function (codigo, box) {
                $('#lblCodigoTV').text(codigo);
                $('#lblBoxTV').text("PUESTO " + box);

                $('#contenedorPrincipal').addClass('parpadeo');
                setTimeout(function () {
                    $('#contenedorPrincipal').removeClass('parpadeo');
                }, 4000);

                agregarAHistorial(codigo, box);
                anunciarTurno(codigo, box);
            };

            // Iniciar conexión y capturar posibles errores
            $.connection.hub.start()
                .done(function () {
                    console.log("Pantalla TV conectada correctamente a SignalR. ID Conexión: " + $.connection.hub.id);
                })
                .fail(function (error) {
                    console.error("Error al conectar con SignalR: " + error.toString());
                });
        });

        function agregarAHistorial(codigo, box) {
            historial.unshift({ codigo: codigo, box: box });
            if (historial.length > 4) historial.pop();

            var html = "";
            for (var i = 1; i < historial.length; i++) {
                html += "<tr>" +
                    "<td style='color:#ffd800;'>" + historial[i].codigo + "</td>" +
                    "<td>PUESTO " + historial[i].box + "</td>" +
                    "</tr>";
            }

            if (html !== "") {
                $('#tbHistorial').html(html);
            }
        }

        function anunciarTurno(codigo, box) {
            try {
                var audioCtx = new (window.AudioContext || window.webkitAudioContext)();
                var osc = audioCtx.createOscillator();
                var gain = audioCtx.createGain();

                osc.type = 'sine';
                osc.frequency.setValueAtTime(587.33, audioCtx.currentTime);
                gain.gain.setValueAtTime(0.1, audioCtx.currentTime);

                osc.connect(gain);
                gain.connect(audioCtx.destination);
                osc.start();
                osc.stop(audioCtx.currentTime + 0.6);

                //var codigoHablado = codigo.split('').join('. ');
                var codigoHablado = codigo.replace(/([A-Za-z])/g, '$1..')
                                          .replace(/([0-9])/g,'$1.')

                setTimeout(function () {
                    //var mensaje = new SpeechSynthesisUtterance(codigoHablado + ", pase al puesto " + box);
                    var mensaje = new SpeechSynthesisUtterance("Turno..." + codigoHablado + "... pase al puesto " + box);

                    mensaje.lang = 'e-AR';
                    mensaje.rate = 0.8;
                    window.speechSynthesis.speak(mensaje);
                }, 700);
            } catch (e) {
                console.warn("Audio bloqueado por el navegador hasta que exista interacción del usuario.", e);
            }
        }
    </script>
</body>
</html>