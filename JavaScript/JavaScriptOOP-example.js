$V.com.Grid = function (sHtmlId)
{
	this.id = sHtmlId;
	this.init();
};
$V.com.Grid.prototype = {
	init: function ()
	{
		var self = this;
		//- assign on click event
		this.oTable = $('#' + this.id);
		$('#' + this.id).bind('click', self.onClick);
		$('#table-headers tr th.checkbox_column div').bind('click', self.checkRows);
	},
 
	get: function()
	{
		return this.oTable;
	},
 
	updateRows: function (rows, oDetails, oData, bCloseEditor)
	{
		//statments
	}
}