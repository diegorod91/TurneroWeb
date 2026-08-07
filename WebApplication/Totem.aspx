<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/PantallaCompleta.Master" CodeBehind="Totem.aspx.cs" Inherits="TurneroWeb.Totem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Fuerza a que los botones se apilen en forma vertical */
        .contenedor-botones {
            width: 100%;
            max-width: 450px;
            margin: 0 auto;
        }

        .btn-totem-vertical {
            display: block !important; /* Obliga al botón a ocupar su propia fila */
            width: 100% !important; /* Extiende el ancho al 100% del contenedor */
            margin: 0 0 20px 0 !important; /* Separación de 20px entre botones */
            padding: 20px !important;
            font-size: 1.3rem !important;
            font-weight: bold !important;
            border-radius: 12px !important;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15) !important;
            background-color: #ffffff !important;
            color: #212529 !important;
            border: none !important;
        }

            .btn-totem-vertical:hover {
                background-color: #e2e6ea !important;
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="text-center">
        <h2 style="font-weight: bold; margin-bottom: 35px; color: #000;">SELECCIONE SU TRÁMITE</h2>

        <!-- Contenedor alineado verticalmente -->
        <div class="contenedor-botones">
            <asp:Button ID="btnEnvios" runat="server" Text="Envíos y Paquetes" CommandArgument="EP" OnClick="GenerarTurno_Click" CssClass="btn-totem-vertical" />
            <asp:Button ID="btnPagos" runat="server" Text="Cobros y Pagos" CommandArgument="CP" OnClick="GenerarTurno_Click" CssClass="btn-totem-vertical" />
            <asp:Button ID="btnConsultas" runat="server" Text="Otras Consultas" CommandArgument="OC" OnClick="GenerarTurno_Click" CssClass="btn-totem-vertical" />
            <asp:Button ID="btnRetiros" runat="server" Text="Retiro de Mercadería" CommandArgument="RM" OnClick="GenerarTurno_Click" CssClass="btn-totem-vertical" />
            <asp:Button ID="btnPrioridad" runat="server" Text="Atención Prioritaria" CommandArgument="ATX" OnClick="GenerarTurno_Click" CssClass="btn-totem-vertical" />
        </div>

        <!-- Panel del Ticket -->
        <asp:Panel ID="pnlTicket" runat="server" Visible="false" Style="background: #ffffff; border-radius: 12px; padding: 25px; margin-top: 25px; box-shadow: 0 4px 10px rgba(0,0,0,0.15);">
            <h3 style="color: #666; margin: 0;">Su turno es:</h3>
            <h1 style="font-size: 4rem; font-weight: bold; margin: 10px 0; color: #000;">
                <asp:Label ID="lblNumero" runat="server"></asp:Label></h1>
            <p style="color: #888; margin: 0;">Retire su comprobante y aguarde en la sala</p>
        </asp:Panel>
    </div>

    <div class="modal fade" id="modalTicket" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content" style="border-radius: 15px; padding: 20px; text-align: center;">
                <div class="modal-body">
                    <h3 style="color: #666; margin-bottom: 10px;">Su turno es:</h3>
                    <h1 style="font-size: 5rem; font-weight: bold; color: #000; margin: 10px 0;">
                        <asp:Label ID="lblNumeroModal" runat="server"></asp:Label>
                    </h1>
                    <p style="color: #888; font-size: 1.1rem;">Retire su comprobante y aguarde en la sala</p>
                </div>
                <div class="modal-footer" style="border: none; justify-content: center;">
                    <button type="button" class="btn btn-dark btn-lg" style="padding: 12px 40px; font-size: 1.2rem; border-radius: 8px;" onclick="reiniciarTotem()">
                        Finalizar
                       
                    </button>
                </div>
            </div>
        </div>
    </div>
    <%--<script src="bower_components/jquery/dist/jquery.min.js"></script>--%>
    <script src="<%= ResolveUrl("~/Scripts/jquery-3.4.1.min.js") %>"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script type="text/javascript">
        var timerAutoCierre;

        function abrirModalTicket() {
            // Muestra el modal con jQuery/Bootstrap
            $('#modalTicket').modal({ backdrop: 'static', keyboard: false });
            $('#modalTicket').modal('show');

            // Cierre automático después de 8 segundos (útil para tótem público)
            timerAutoCierre = setTimeout(reiniciarTotem, 8000);
        }

        function reiniciarTotem() {
            clearTimeout(timerAutoCierre);
            // Recarga la página limpia para el siguiente usuario
            window.location.href = 'Totem.aspx';
        }
    </script>
</asp:Content>
