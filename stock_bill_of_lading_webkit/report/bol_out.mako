## -*- coding: utf-8 -*-
<html>
<head>
    <style type="text/css">
        ${css}
    </style>
</head>

<body>
    <%page expression_filter="entity"/>
    <%
    def carriage_returns(text):
        return text.replace('\n', '<br />')
    %>
    %for picking in objects:
        <% setLang(picking.partner_id.lang) %>
        <div class="address">
            <%
            invoice_addr = invoice_address(picking)
            %>
            <table class="recipient">
                <tr><td class="address_title">${_("Contact info:")}</td></tr>
                %if invoice_addr.phone:
                    <tr><td><b>${_("Phone:")}</b> ${invoice_addr.phone }</td></tr>
                %endif
                %if invoice_addr.mobile:
                    <tr><td><b>${_("Cell:")}</b> ${invoice_addr.mobile }</td></tr>
                %endif
                %if invoice_addr.email:
                    <tr><td><b>${_("Email:")}</b> ${invoice_addr.email }</td></tr>
                %endif
            </table>
            <table class="invoice">
                <tr><td class="address_title">${_("Customer name & address:")}</td></tr>
                <tr><td>${invoice_addr.title and invoice_addr.title.name or ''} ${invoice_addr.name }</td></tr>
                %if invoice_addr.contact_address:
                    <% address_lines = invoice_addr.contact_address.split("\n") %>
                    %for part in address_lines:
                        %if part:
                        <tr><td>${part}</td></tr>
                        %endif
                    %endfor
                %endif
            </table>
        </div>
        <div class="address">
            <%
            picking_addr = picking_address(picking)
            %>
            <table class="recipient">
                <tr><td class="address_title">${_("Ship to:")}</td></tr>
                %if picking.partner_id.parent_id:
                <tr><td>${picking.partner_id.parent_id.name or ''}</td></tr>
                <tr><td>${picking.partner_id.title and picking.partner_id.title.name or ''} ${picking.partner_id.name }</td></tr>
                <% address_lines = picking.partner_id.contact_address.split("\n")[1:] %>
                %else:
                <tr><td >${picking.partner_id.title and picking.partner_id.title.name or ''} ${picking.partner_id.name }</td></tr>
                <% address_lines = picking.partner_id.contact_address.split("\n") %>
                %endif
                %for part in address_lines:
                    %if part:
                    <tr><td>${part}</td></tr>
                    %endif
                %endfor
            </table>
            <table class="invoice">
                <tr><td class="address_title">${_("Pick from:")}</td></tr>
                <tr><td>${picking_addr.title and picking_addr.title.name or ''} ${picking_addr.name }</td></tr>
                %if picking_addr.contact_address:
                    <% address_lines = picking_addr.contact_address.split("\n") %>
                    %for part in address_lines:
                        %if part:
                        <tr><td>${part}</td></tr>
                        %endif
                    %endfor
                %endif
            </table>
        </div>
        
        <h1 style="clear:both;">${_(u'Delivery Order') } ${picking.name}</h1>
        
        <table class="basic_table" width="100%">
            <tr>
                <td style="font-weight:bold;">${_("Customer Ref")}</td>
                <td style="font-weight:bold;">${_("Origin")}</td>
                <td style="font-weight:bold;">${_("Scheduled Date")}</td>
                <td style="font-weight:bold;">${_('Total Weight')}</td>
                <td style="font-weight:bold;">${_('Delivery Method')}</td>
            </tr>
            <tr>
                <td>${picking.sale_id.client_order_ref if picking.sale_id else ''}</td>
                <td>${picking.origin or ''}</td>
                <td>${formatLang(picking.min_date, date=True)}</td>
                <td>${picking.weight}</td>
                <td>${picking.carrier_id and picking.carrier_id.name or ''}</td>
            </tr>
        </table>
    
        <table class="list_sale_table" width="100%" style="margin-top: 20px;">
            <thead>
                <tr>
                    <th style="text-align:left; ">${_("Item")}</th>
                    <th style="text-align:left; ">${_("Description")}</th>
                    <th style="text-align:left; ">${_("Serial Number")}</th>
                    <th style="text-align:right; ">${_("Weight (kg)")}</th>
                    <th class="amount">${_("Quantity")}</th>
                </tr>
            </thead>
            <tbody>
            %for line in picking.move_lines:
                <%
                weight = line.product_id.weight * line.product_qty 
                %>
                <tr class="line">
                    <td style="text-align:left; " >${ line.product_id.name }</td>
                    <td style="text-align:left; " >${ line.product_id.description or ''}</td>
                    <td style="text-align:left; " >${ line.prodlot_id and line.prodlot_id.name or ''}</td>
                    <td style="text-align:right; " >${ formatLang(weight) }</td>
                    <td class="amount" >${ formatLang(line.product_qty) } ${line.product_uom.name}</td>
                </tr>
            %endfor
        </table>
        
        <br/>
        %if picking.note :
            <p class="std_text">${picking.note | carriage_returns}</p>
        %endif

        <p style="page-break-after: always"/>
        <br/>
    %endfor
</body>
</html>
