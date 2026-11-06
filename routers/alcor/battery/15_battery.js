'use strict';
'require baseclass';
'require rpc';

// Status → Overview card for the XE3000 battery (ubus "battery", see battery/rpcd)

var callBatteryInfo = rpc.declare({
	object: 'battery',
	method: 'info'
});

return baseclass.extend({
	title: '电池',

	load: function() {
		return L.resolveDefault(callBatteryInfo(), {});
	},

	render: function(info) {
		if (!L.isObject(info) || info.soc == null)
			return null;

		var fields = [
			'电量', E('div', {
				'class': 'cbi-progressbar',
				'title': '%d%%'.format(info.soc)
			}, E('div', { 'style': 'width:%d%%'.format(info.soc) })),
			'状态', info.charging ? '充电中' : '使用电池',
			'温度', '%d °C'.format(info.temperature),
			'循环次数', info.cycles
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
