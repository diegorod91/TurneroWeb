<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AtencionBox.aspx.cs" Inherits="SolucionBase.AtencionBox" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Panel de Atención - Box</title>
    <link href="bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server" class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-lg">
                    <div class="card-header bg-primary text-white text-center">
                        <h3>Panel de Atención por Box</h3>
                    </div>
                    <div class="card-body">
                        <!-- Configuración del Puesto -->
                        <div class="mb-3">
                            <label class="form-label font-weight-bold">Número de Box / Puesto:</label>
                            <asp:DropDownList ID="ddlBox" runat="server" CssClass="form-control form-control-lg">
                                <asp:ListItem Text="Box 1" Value="1" />
                                <asp:ListItem Text="Box 2" Value="2" />
                                <asp:ListItem Text="Box 3" Value="3" />
                            </asp:DropDownList>
                        </div>

                        <div class="mb-4">
                            <label class="form-label font-weight-bold">Servicio a Atender:</label>
                            <asp:DropDownList ID="ddlServicio" runat="server" CssClass="form-control form-control-lg">
                                <asp:ListItem Text="Envíos y Paquetes" Value="Envíos y Paquetes" />
                                <asp:ListItem Text="Cobros y Pagos" Value="Cobros y Pagos" />
                                <asp:ListItem Text="Otras Consultas" Value="Otras Consultas" />
                                <asp:ListItem Text="Atención Prioritaria" Value="Atención Prioritaria" />
                                <asp:ListItem Text="Retiro Mercaderia" Value="Retiro de Mercadería" />
                            </asp:DropDownList>
                        </div>

                        <hr />

                        <!-- Visualización del Turno Activo -->
                        <div class="text-center my-4">
                            <small class="text-muted text-uppercase">Atendiendo Actualmente:</small>
                            <h1 class="display-3 font-weight-bold text-success my-2">
                                <asp:Label ID="lblTurnoActual" runat="server" Text="---" />
                            </h1>
                        </div>

                        <!-- Botones de Acción -->
                        <div class="d-grid gap-2">
                            <asp:Button ID="btnLlamar" runat="server" Text="🔔 LLAMAR SIGUIENTE"
                                CssClass="btn btn-success btn-lg w-100 py-3 mb-2" OnClick="btnLlamar_Click" />

                            <asp:Button ID="btnRellamar" runat="server" Text="🔁 RE-LLAMAR"
                                CssClass="btn btn-warning btn-lg w-100 py-2" OnClick="btnRellamar_Click" Enabled="false" />
                        </div>

                        <div class="mt-3 text-center">
                            <asp:Label ID="lblMensaje" runat="server" CssClass="text-danger fw-bold" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
