'use strict';
'require baseclass';
'require rpc';

// Status → Overview card for the XE3000 battery (ubus "battery", see battery/rpcd)

var callBatteryInfo = rpc.declare({
	object: 'battery',
	method: 'info'
});

return baseclass.extend({
	title: _('Battery'),

	load: function() {
		return L.resolveDefault(callBatteryInfo(), {});
	},

	render: function(info) {
		if (!L.isObject(info) || info.soc == null)
			return null;

		var fields = [
			_('Charge'), E('div', {
				'class': 'cbi-progressbar',
				'title': '%d%%'.format(info.soc)
			}, E('div', { 'style': 'width:%d%%'.format(info.soc) })),
			_('Status'), info.charging ? _('Charging') : _('On battery'),
			_('Temperature'), '%d °C'.format(info.temperature),
			_('Charge cycles'), info.cycles
		];

		var table = E('table', { 'class': 'table' });

		for (var i = 0; i < fields.length; i += 2)
			table.appendChild(E('tr', { 'class': 'tr' }, [
				E('td', { 'class': 'td left', 'width': '33%' }, [ fields[i] ]),
				E('td', { 'class': 'td left' }, [ fields[i + 1] ])
			]));

		return table;
	}
});
